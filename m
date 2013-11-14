Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221Ab3KNFQK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 00:16:10 -0500
Received: from mdfmta005.mxout.tbr.inty.net ([91.221.168.46]:54854 "EHLO
	smtp.demon.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751881Ab3KNFPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 00:15:52 -0500
From: Phillip Lougher <phillip@squashfs.org.uk>
To: linux-kernel@vger.kernel.org
Cc: minchan@kernel.org, Phillip Lougher <phillip@squashfs.org.uk>
Subject: [PATCH 4/4] Squashfs: Check stream is not NULL in decompressor_multi.c
Date: Thu, 14 Nov 2013 05:14:19 +0000
Message-Id: <1384406059-28567-5-git-send-email-phillip@squashfs.org.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1384406059-28567-1-git-send-email-phillip@squashfs.org.uk>
References: <1384406059-28567-1-git-send-email-phillip@squashfs.org.uk>
X-MDF-HostID: 8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix static checker complaint that stream is not checked in
squashfs_decompressor_destroy().

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
---
 fs/squashfs/decompressor_multi.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/squashfs/decompressor_multi.c b/fs/squashfs/decompressor_multi.c
index ae54675..d6008a6 100644
--- a/fs/squashfs/decompressor_multi.c
+++ b/fs/squashfs/decompressor_multi.c
@@ -119,11 +119,10 @@ void squashfs_decompressor_destroy(struct squashfs_sb_info *msblk)
 			kfree(decomp_strm);
 			stream->avail_decomp--;
 		}
+		WARN_ON(stream->avail_decomp);
+		kfree(stream->comp_opts);
+		kfree(stream);
 	}
-
-	WARN_ON(stream->avail_decomp);
-	kfree(stream->comp_opts);
-	kfree(stream);
 }
 
 
-- 
1.7.10.4

