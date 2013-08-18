Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289Ab3HRMQG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 08:16:06 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:52450 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330Ab3HRMQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 08:16:04 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] [media] media/v4l2: VIDEO_SH_VEU should depend on HAS_DMA
Date: Sun, 18 Aug 2013 14:15:37 +0200
Message-Id: <1376828137-12806-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If NO_DMA=y:

drivers/media/v4l2-core/videobuf2-dma-contig.c: In function ‘vb2_dc_mmap’:
drivers/media/v4l2-core/videobuf2-dma-contig.c:204: error: implicit declaration of function ‘dma_mmap_coherent’
drivers/media/v4l2-core/videobuf2-dma-contig.c: In function ‘vb2_dc_get_base_sgt’:
drivers/media/v4l2-core/videobuf2-dma-contig.c:387: error: implicit declaration of function ‘dma_get_sgtable’

Commit da508f5799659241a359e2d07abb8af905f6291c ("[media] media/v4l2:
VIDEOBUF2_DMA_CONTIG should depend on HAS_DMA") added a dependency on
HAS_DMA to VIDEO_SH_VEU, as it selects VIDEOBUF2_DMA_CONTIG.

However, this got lost in the merge conflict resolution in commit
df90e2258950fd631cdbf322c1ee1f22068391aa ("Merge branch 'devel-for-v3.10'
into v4l_for_linus").

Re-add the dependency to fix this.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/media/platform/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 08de865..126d0fc 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -203,7 +203,7 @@ config VIDEO_SAMSUNG_EXYNOS_GSC
 
 config VIDEO_SH_VEU
 	tristate "SuperH VEU mem2mem video processing driver"
-	depends on VIDEO_DEV && VIDEO_V4L2 && GENERIC_HARDIRQS
+	depends on VIDEO_DEV && VIDEO_V4L2 && GENERIC_HARDIRQS && HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	help
-- 
1.7.9.5

