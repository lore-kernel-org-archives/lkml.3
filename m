Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215AbaHFEof (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 00:44:35 -0400
Received: from s87.loopia.se ([194.9.94.112]:34495 "EHLO s87.loopia.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752943AbaHFEo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 00:44:28 -0400
X-Spam-Flag: NO
X-Spam-Score: -1
From: Hans Wennborg <hans@hanshq.net>
To: david@fromorbit.com, xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Cc: Hans Wennborg <hans@hanshq.net>
Subject: [PATCH 14/15] xfs: fix decimal printf format specifiers prefixed with 0x
Date: Tue,  5 Aug 2014 21:44:16 -0700
Message-Id: <1407300256-495-1-git-send-email-hans@hanshq.net>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The prefix suggests the number should be printed in hex, so use
the %x specifier to do that.

Found by using regex suggested by Joe Perches.

Signed-off-by: Hans Wennborg <hans@hanshq.net>
---
 fs/xfs/xfs_discard.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 13d08a1..b4a2415 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -228,7 +228,7 @@ xfs_discard_extents(
 				GFP_NOFS, 0);
 		if (error && error != -EOPNOTSUPP) {
 			xfs_info(mp,
-	 "discard failed for extent [0x%llu,%u], error %d",
+	 "discard failed for extent [0x%llx,%u], error %d",
 				 (unsigned long long)busyp->bno,
 				 busyp->length,
 				 error);
-- 
2.0.0.526.g5318336

