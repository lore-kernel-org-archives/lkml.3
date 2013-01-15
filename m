Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925Ab3AOTrM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 14:47:12 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:46145 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab3AOTrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 14:47:11 -0500
From: Cong Ding <dinggnu@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rob Clark <rob@ti.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        YAMANE Toshiaki <yamanetoshi@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Cong Ding <dinggnu@gmail.com>
Subject: [PATCH] staging: omapdrm/omap_gem_dmabuf.c: fix memory leakage
Date: Tue, 15 Jan 2013 20:46:50 +0100
Message-Id: <1358279214-4820-1-git-send-email-dinggnu@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a memory leakage in variable sg if it goes to error.

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 drivers/staging/omapdrm/omap_gem_dmabuf.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/omapdrm/omap_gem_dmabuf.c b/drivers/staging/omapdrm/omap_gem_dmabuf.c
index b6c5b5c..a3236ab 100644
--- a/drivers/staging/omapdrm/omap_gem_dmabuf.c
+++ b/drivers/staging/omapdrm/omap_gem_dmabuf.c
@@ -53,10 +53,10 @@ static struct sg_table *omap_gem_map_dma_buf(
 	/* this should be after _get_paddr() to ensure we have pages attached */
 	omap_gem_dma_sync(obj, dir);
 
-out:
-	if (ret)
-		return ERR_PTR(ret);
 	return sg;
+out:
+	kfree(sg);
+	return ERR_PTR(ret);
 }
 
 static void omap_gem_unmap_dma_buf(struct dma_buf_attachment *attachment,
-- 
1.7.10.4

