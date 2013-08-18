Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110Ab3HRKyo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 06:54:44 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:57569 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194Ab3HRKyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 06:54:43 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Airlie <airlied@linux.ie>, Andrew Morton <akpm@linux-foundation.org>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH -resend] drm: DRM should depend on HAS_DMA
Date: Sun, 18 Aug 2013 12:54:25 +0200
Message-Id: <1376823265-14845-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If NO_DMA=y:

drivers/built-in.o: In function `__drm_pci_free':
drivers/gpu/drm/drm_pci.c:112: undefined reference to `dma_free_coherent'
drivers/built-in.o: In function `drm_pci_alloc':
drivers/gpu/drm/drm_pci.c:72: undefined reference to `dma_alloc_coherent'
drivers/built-in.o: In function `drm_gem_unmap_dma_buf':
drivers/gpu/drm/drm_prime.c:87: undefined reference to `dma_unmap_sg'
drivers/built-in.o: In function `drm_gem_map_dma_buf':
drivers/gpu/drm/drm_prime.c:78: undefined reference to `dma_map_sg'

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/gpu/drm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index a7c54c8..626bc0c 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -6,7 +6,7 @@
 #
 menuconfig DRM
 	tristate "Direct Rendering Manager (XFree86 4.1.0 and higher DRI support)"
-	depends on (AGP || AGP=n) && !EMULATED_CMPXCHG && MMU
+	depends on (AGP || AGP=n) && !EMULATED_CMPXCHG && MMU && HAS_DMA
 	select HDMI
 	select I2C
 	select I2C_ALGOBIT
-- 
1.7.9.5

