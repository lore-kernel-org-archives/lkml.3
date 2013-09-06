Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498Ab3IFMoO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 08:44:14 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:46615 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab3IFMoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 08:44:12 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] [media] media/v4l2: VIDEO_RENESAS_VSP1 should depend on HAS_DMA
Date: Fri,  6 Sep 2013 14:43:56 +0200
Message-Id: <1378471436-7045-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If NO_DMA=y:

warning: (... && VIDEO_RENESAS_VSP1 && ...) selects VIDEOBUF2_DMA_CONTIG which has unmet direct dependencies (MEDIA_SUPPORT && HAS_DMA)

drivers/media/v4l2-core/videobuf2-dma-contig.c: In function ‘vb2_dc_mmap’:
drivers/media/v4l2-core/videobuf2-dma-contig.c:202: error: implicit declaration of function ‘dma_mmap_coherent’
drivers/media/v4l2-core/videobuf2-dma-contig.c: In function ‘vb2_dc_get_base_sgt’:
drivers/media/v4l2-core/videobuf2-dma-contig.c:385: error: implicit declaration of function ‘dma_get_sgtable’
make[7]: *** [drivers/media/v4l2-core/videobuf2-dma-contig.o] Error 1

VIDEO_RENESAS_VSP1 (which doesn't have a platform dependency) selects
VIDEOBUF2_DMA_CONTIG, but the latter depends on HAS_DMA.

Make VIDEO_RENESAS_VSP1 depend on HAS_DMA to fix this.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/media/platform/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 8068d7b..fbc0611 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -212,7 +212,7 @@ config VIDEO_SH_VEU
 
 config VIDEO_RENESAS_VSP1
 	tristate "Renesas VSP1 Video Processing Engine"
-	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
+	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	---help---
 	  This is a V4L2 driver for the Renesas VSP1 video processing engine.
-- 
1.7.9.5

