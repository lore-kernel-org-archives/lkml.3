Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbaJXTiH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 15:38:07 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:49903 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbaJXTiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 15:38:05 -0400
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: vinod.koul@intel.com
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        dan.j.williams@intel.com, s.hauer@pengutronix.de, shawn.guo@linaro.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org, b38343@freescale.com
Subject: [PATCH] dma: imx-sdma: Add a new DMATYPE for SAI
Date: Fri, 24 Oct 2014 12:37:41 -0700
Message-Id: <1414179461-3522-1-git-send-email-nicoleotsuka@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch simply adds a new DMATYPE for SAI which's included
in i.MX6 Solo X.

Signed-off-by: Nicolin Chen <nicoleotsuka@gmail.com>
---
 Documentation/devicetree/bindings/dma/fsl-imx-sdma.txt | 1 +
 drivers/dma/imx-sdma.c                                 | 1 +
 include/linux/platform_data/dma-imx.h                  | 1 +
 3 files changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/dma/fsl-imx-sdma.txt b/Documentation/devicetree/bindings/dma/fsl-imx-sdma.txt
index 4659fd9..dc8d3aa 100644
--- a/Documentation/devicetree/bindings/dma/fsl-imx-sdma.txt
+++ b/Documentation/devicetree/bindings/dma/fsl-imx-sdma.txt
@@ -48,6 +48,7 @@ The full ID of peripheral types can be found below.
 	21	ESAI
 	22	SSI Dual FIFO	(needs firmware ver >= 2)
 	23	Shared ASRC
+	24	SAI
 
 The third cell specifies the transfer priority as below.
 
diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index 88afc48..05fd6b1 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -729,6 +729,7 @@ static void sdma_get_pc(struct sdma_channel *sdmac,
 	case IMX_DMATYPE_CSPI:
 	case IMX_DMATYPE_EXT:
 	case IMX_DMATYPE_SSI:
+	case IMX_DMATYPE_SAI:
 		per_2_emi = sdma->script_addrs->app_2_mcu_addr;
 		emi_2_per = sdma->script_addrs->mcu_2_app_addr;
 		break;
diff --git a/include/linux/platform_data/dma-imx.h b/include/linux/platform_data/dma-imx.h
index 6a1357d..7d964e7 100644
--- a/include/linux/platform_data/dma-imx.h
+++ b/include/linux/platform_data/dma-imx.h
@@ -41,6 +41,7 @@ enum sdma_peripheral_type {
 	IMX_DMATYPE_ESAI,	/* ESAI */
 	IMX_DMATYPE_SSI_DUAL,	/* SSI Dual FIFO */
 	IMX_DMATYPE_ASRC_SP,	/* Shared ASRC */
+	IMX_DMATYPE_SAI,	/* SAI */
 };
 
 enum imx_dma_prio {
-- 
1.9.1

