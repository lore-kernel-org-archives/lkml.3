Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744AbaBUT5V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 14:57:21 -0500
Received: from albert.telenet-ops.be ([195.130.137.90]:57807 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117AbaBUT5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 14:57:20 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] [media] v4l: VIDEO_SH_VOU should depend on HAS_DMA
Date: Fri, 21 Feb 2014 20:57:17 +0100
Message-Id: <1393012637-22623-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If NO_DMA=y:

    warning: (VIDEO_DM6446_CCDC && VIDEO_DM355_CCDC && VIDEO_DM365_ISIF && VIDEO_OMAP2_VOUT && VIDEO_SH_VOU && VIDEO_VIU && VIDEO_TIMBERDALE && VIDEO_MX1 && VIDEO_OMAP1) selects VIDEOBUF_DMA_CONTIG which has unmet direct dependencies (MEDIA_SUPPORT && HAS_DMA)

    drivers/built-in.o: In function `videobuf_vm_close':
    videobuf-dma-contig.c:(.text+0x407aa0): undefined reference to `videobuf_queue_cancel'
    drivers/built-in.o: In function `__videobuf_dc_alloc':
    videobuf-dma-contig.c:(.text+0x407ba2): undefined reference to `dma_alloc_coherent'
    drivers/built-in.o: In function `__videobuf_mmap_mapper':
    videobuf-dma-contig.c:(.text+0x407d44): undefined reference to `dma_free_coherent'
    drivers/built-in.o: In function `free_buffer':
    sh_vou.c:(.text+0x41f73a): undefined reference to `videobuf_waiton'
    drivers/built-in.o: In function `sh_vou_poll':
    sh_vou.c:(.text+0x41f884): undefined reference to `videobuf_poll_stream'
    drivers/built-in.o: In function `sh_vou_buf_prepare':
    sh_vou.c:(.text+0x41fdf6): undefined reference to `videobuf_iolock'
    drivers/built-in.o: In function `sh_vou_reqbufs':
    sh_vou.c:(.text+0x4203b0): undefined reference to `videobuf_reqbufs'
    drivers/built-in.o: In function `sh_vou_querybuf':
    sh_vou.c:(.text+0x42040a): undefined reference to `videobuf_querybuf'
    drivers/built-in.o: In function `sh_vou_qbuf':
    sh_vou.c:(.text+0x42045e): undefined reference to `videobuf_qbuf'
    drivers/built-in.o: In function `sh_vou_dqbuf':
    sh_vou.c:(.text+0x4204c2): undefined reference to `videobuf_dqbuf'
    drivers/built-in.o: In function `sh_vou_streamon':
    sh_vou.c:(.text+0x420572): undefined reference to `videobuf_streamon'
    drivers/built-in.o: In function `sh_vou_streamoff':
    sh_vou.c:(.text+0x4205d2): undefined reference to `videobuf_streamoff'
    drivers/built-in.o: In function `sh_vou_mmap':
    sh_vou.c:(.text+0x420c46): undefined reference to `videobuf_mmap_mapper'

VIDEO_SH_VOU selects VIDEOBUF_DMA_CONTIG, which bypasses its dependency on
HAS_DMA.  Make VIDEO_SH_VOU depend on HAS_DMA to fix this.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/media/platform/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index b2a4403940c5..c137abfa0c54 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -36,7 +36,7 @@ source "drivers/media/platform/blackfin/Kconfig"
 config VIDEO_SH_VOU
 	tristate "SuperH VOU video output driver"
 	depends on MEDIA_CAMERA_SUPPORT
-	depends on VIDEO_DEV && I2C
+	depends on VIDEO_DEV && I2C && HAS_DMA
 	depends on ARCH_SHMOBILE || COMPILE_TEST
 	select VIDEOBUF_DMA_CONTIG
 	help
-- 
1.7.9.5

