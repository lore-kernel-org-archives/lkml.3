Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137AbaF3MDf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:03:35 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:52047 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753815AbaF3LxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>,
        Eric Sandeen <sandeen@redhat.com>, Ben Myers <bpm@sgi.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 038/181] xfs: don't emit corruption noise on fs probes
Date: Mon, 30 Jun 2014 13:50:59 +0200
Message-Id: <15fc2070ca014dda9834a361d56ba8d218d6eefc.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Sandeen <sandeen@sandeen.net>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 31625f28ad7be67701dc4cefcf52087addd88af4 upstream.

If we get EWRONGFS due to probing of non-xfs filesystems,
there's no need to issue the scary corruption error and backtrace.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ben Myers <bpm@sgi.com>

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/xfs/xfs_sb.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_sb.c b/fs/xfs/xfs_sb.c
index 039708122038..38b7df67ba7c 100644
--- a/fs/xfs/xfs_sb.c
+++ b/fs/xfs/xfs_sb.c
@@ -633,8 +633,9 @@ xfs_sb_read_verify(
 
 out_error:
 	if (error) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW,
-				     mp, bp->b_addr);
+		if (error != EWRONGFS)
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW,
+					     mp, bp->b_addr);
 		xfs_buf_ioerror(bp, error);
 	}
 }
-- 
2.0.0

