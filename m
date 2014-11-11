Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216AbaKKML5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 07:11:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57143 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494AbaKKLJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:09:13 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 013/170] jbd2: free bh when descriptor block checksum fails
Date: Tue, 11 Nov 2014 11:06:12 +0000
Message-Id: <1415704129-12709-14-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/jbd2/recovery.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/jbd2/recovery.c b/fs/jbd2/recovery.c
index 9b329b55ffe3..bcbef08a4d8f 100644
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
2.1.0

