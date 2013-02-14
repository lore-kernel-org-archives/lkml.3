Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763Ab3BNJMl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 04:12:41 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:44905 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756496Ab3BNJMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 04:12:38 -0500
X-AuditID: 9c930179-b7c24ae00000119c-a8-511caa8443ab
From: Kyungsik Lee <kyungsik.lee@lge.com>
To: Chris Mason <chris.mason@fusionio.com>, Li Zefan <lizf@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: hyojun.im@lge.com, chan.jeong@lge.com, raphael.andy.lee@gmail.com,
        Kyungsik Lee <kyungsik.lee@lge.com>
Subject: [PATCH] btrfs: fix decompress buffer size
Date: Thu, 14 Feb 2013 18:12:19 +0900
Message-Id: <1360833139-5850-1-git-send-email-kyungsik.lee@lge.com>
X-Mailer: git-send-email 1.8.0.3
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lzo1x_1_compress() is unnecessarily used for allocating decompress buffer.

Signed-off-by: Kyungsik Lee <kyungsik.lee@lge.com>
---
 fs/btrfs/lzo.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index 743b86f..223893a 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -55,7 +55,7 @@ static struct list_head *lzo_alloc_workspace(void)
 		return ERR_PTR(-ENOMEM);
 
 	workspace->mem = vmalloc(LZO1X_MEM_COMPRESS);
-	workspace->buf = vmalloc(lzo1x_worst_compress(PAGE_CACHE_SIZE));
+	workspace->buf = vmalloc(PAGE_CACHE_SIZE);
 	workspace->cbuf = vmalloc(lzo1x_worst_compress(PAGE_CACHE_SIZE));
 	if (!workspace->mem || !workspace->buf || !workspace->cbuf)
 		goto fail;
@@ -349,7 +349,7 @@ cont:
 			}
 		}
 
-		out_len = lzo1x_worst_compress(PAGE_CACHE_SIZE);
+		out_len = PAGE_CACHE_SIZE;
 		ret = lzo1x_decompress_safe(buf, in_len, workspace->buf,
 					    &out_len);
 		if (need_unmap)
-- 
1.8.0.3

