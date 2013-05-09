Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288Ab3EIVFR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 17:05:17 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:47779 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783Ab3EIVFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 17:05:08 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 11/12] drm: DRM should depend on HAS_DMA
Date: Thu,  9 May 2013 23:04:53 +0200
Message-Id: <1368133494-22198-11-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1368133494-22198-1-git-send-email-geert@linux-m68k.org>
References: <1368133494-22198-1-git-send-email-geert@linux-m68k.org>
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
Cc: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org
---
 drivers/gpu/drm/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index b16c50e..38f1228 100644
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
1.7.0.4

