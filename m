Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677AbaKFWwT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:52:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59087 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558AbaKFWoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:44:05 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 058/162] jbd2: free bh when descriptor block checksum fails
Date: Thu,  6 Nov 2014 14:35:22 -0800
Message-Id: <1415313426-9622-59-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 064d83892e9ba547f7d4eae22cbca066d95210ce upstream.

Free the buffer head if the journal descriptor block fails checksum
verification.

This is the jbd2 port of the e2fsprogs patch "e2fsck: free bh on csum
verify error in do_one_pass".

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/jbd2/recovery.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/jbd2/recovery.c b/fs/jbd2/recovery.c
index 9b329b5..bcbef08 100644
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
1.9.1

