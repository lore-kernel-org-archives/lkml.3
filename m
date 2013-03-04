Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932434Ab3CDUwl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 15:52:41 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:43225 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932198Ab3CDUwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 15:52:40 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>, linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] media/v4l2: VIDEOBUF2_DMA_CONTIG should depend on HAS_DMA
Date: Mon,  4 Mar 2013 21:52:36 +0100
Message-Id: <1362430356-31626-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

m68k/sun3:

drivers/media/v4l2-core/videobuf2-dma-contig.c: In function ‘vb2_dc_mmap’:
drivers/media/v4l2-core/videobuf2-dma-contig.c:204: error: implicit declaration of function ‘dma_mmap_coherent’
drivers/media/v4l2-core/videobuf2-dma-contig.c: In function ‘vb2_dc_get_base_sgt’:
drivers/media/v4l2-core/videobuf2-dma-contig.c:387: error: implicit declaration of function ‘dma_get_sgtable’

Make VIDEOBUF2_DMA_CONTIG and VIDEO_SH_VEU (which selects the former and
doesn't have a platform dependency) depend on HAS_DMA to fix this.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/media/platform/Kconfig  |    2 +-
 drivers/media/v4l2-core/Kconfig |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 05d7b63..42c62aa 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -204,7 +204,7 @@ config VIDEO_SAMSUNG_EXYNOS_GSC
 
 config VIDEO_SH_VEU
 	tristate "SuperH VEU mem2mem video processing driver"
-	depends on VIDEO_DEV && VIDEO_V4L2
+	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	help
diff --git a/drivers/media/v4l2-core/Kconfig b/drivers/media/v4l2-core/Kconfig
index 976d029..8c05565 100644
--- a/drivers/media/v4l2-core/Kconfig
+++ b/drivers/media/v4l2-core/Kconfig
@@ -67,6 +67,7 @@ config VIDEOBUF2_MEMOPS
 
 config VIDEOBUF2_DMA_CONTIG
 	tristate
+	depends on HAS_DMA
 	select VIDEOBUF2_CORE
 	select VIDEOBUF2_MEMOPS
 	select DMA_SHARED_BUFFER
-- 
1.7.0.4

