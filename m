Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932964AbaHGRFG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 13:05:06 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35299 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932538AbaHGRFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 13:05:04 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dmaengine@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH] dmaengine: sun6i: depends on RESET_CONTROLLER
Date: Thu,  7 Aug 2014 19:00:44 +0200
Message-Id: <1407430844-30498-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes a compilation error when RESET_CONTROLLER is not enabled in the
configuration.

drivers/dma/sun6i-dma.c: In function 'sun6i_dma_probe':
drivers/dma/sun6i-dma.c:911:2: error: implicit declaration of function 'devm_reset_control_get' [-Werror=implicit-function-declaration]

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
---
 drivers/dma/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 4b439270fb11..a85e54af5eb1 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -378,6 +378,7 @@ config XILINX_VDMA
 config DMA_SUN6I
 	tristate "Allwinner A31 SoCs DMA support"
 	depends on MACH_SUN6I || COMPILE_TEST
+	depends on RESET_CONTROLLER
 	select DMA_ENGINE
 	select DMA_VIRTUAL_CHANNELS
 	help
-- 
2.0.2

