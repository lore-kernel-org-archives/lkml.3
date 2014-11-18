Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933267AbaKROut (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:50:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57203 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932103AbaKROJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:56 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 117/206] jbd2: free bh when descriptor block checksum fails
Date: Tue, 18 Nov 2014 15:07:52 +0100
Message-Id: <3a7fa65d2e144ff488dc2145fea70ef42ae1bdfb.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 064d83892e9ba547f7d4eae22cbca066d95210ce upstream.

Free the buffer head if the journal descriptor block fails checksum
verification.

This is the jbd2 port of the e2fsprogs patch "e2fsck: free bh on csum
verify error in do_one_pass".

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/jbd2/recovery.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/jbd2/recovery.c b/fs/jbd2/recovery.c
index 20dbfabbf874..c4166471ddf0 100644
--- a/fs/jbd2/recovery.c
+++ b/fs/jbd2/recovery.c
@@ -525,6 +525,7 @@ static int do_one_pass(journal_t *journal,
 			    !jbd2_descr_block_csum_verify(journal,
 							  bh->b_data)) {
 				err = -EIO;
+				brelse(bh);
 				goto failed;
 			}
 
-- 
2.1.3

