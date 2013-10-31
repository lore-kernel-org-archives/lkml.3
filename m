Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862Ab3JaIXE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 04:23:04 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:59166
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753644Ab3JaIW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 04:22:57 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6h1082kzz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h1155h)
From: Nicolin Chen <b42378@freescale.com>
To: <s.hauer@pengutronix.de>, <timur@tabi.org>, <shawn.guo@linaro.org>,
        <broonie@kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dmaengine@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <alsa-devel@alsa-project.org>, <rob.herring@calxeda.com>,
        <mark.rutland@arm.com>, <swarren@wwwdotorg.org>, <pawel.moll@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <philippe.retornaz@gmail.com>
Subject: [PATCH v3 2/4] dma: imx-sdma: Add new dma type for ssi dual fifo script
Date: Thu, 31 Oct 2013 16:22:39 +0800
Message-ID: <cc3826390838f98455647eb47338e0fbf4be57b2.1383207153.git.b42378@freescale.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <cover.1383207153.git.b42378@freescale.com>
References: <cover.1383207153.git.b42378@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new DMA_TYPE for SSI dual FIFO script, included
in SDMA firmware version 2. This script would allow SSI use dual
fifo mode to transimit/receive data without occasional hardware
underrun/overrun.

Signed-off-by: Nicolin Chen <b42378@freescale.com>
---
 Documentation/devicetree/bindings/dma/fsl-imx-sdma.txt | 1 +
 drivers/dma/imx-sdma.c                                 | 4 ++++
 include/linux/platform_data/dma-imx.h                  | 1 +
 3 files changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/dma/fsl-imx-sdma.txt b/Documentation/devicetree/bindings/dma/fsl-imx-sdma.txt
index 4fa814d..68b83ec 100644
--- a/Documentation/devicetree/bindings/dma/fsl-imx-sdma.txt
+++ b/Documentation/devicetree/bindings/dma/fsl-imx-sdma.txt
@@ -42,6 +42,7 @@ The full ID of peripheral types can be found below.
 	19	IPU Memory
 	20	ASRC
 	21	ESAI
+	22	SSI Dual FIFO	(needs firmware ver >= 2)
 
 The third cell specifies the transfer priority as below.
 
diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index c7ece8d..efaa9a9 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -725,6 +725,10 @@ static void sdma_get_pc(struct sdma_channel *sdmac,
 		per_2_emi = sdma->script_addrs->app_2_mcu_addr;
 		emi_2_per = sdma->script_addrs->mcu_2_app_addr;
 		break;
+	case IMX_DMATYPE_SSI_DUAL:
+		per_2_emi = sdma->script_addrs->ssish_2_mcu_addr;
+		emi_2_per = sdma->script_addrs->mcu_2_ssish_addr;
+		break;
 	case IMX_DMATYPE_SSI_SP:
 	case IMX_DMATYPE_MMC:
 	case IMX_DMATYPE_SDHC:
diff --git a/include/linux/platform_data/dma-imx.h b/include/linux/platform_data/dma-imx.h
index beac6b8..bcbc6c3 100644
--- a/include/linux/platform_data/dma-imx.h
+++ b/include/linux/platform_data/dma-imx.h
@@ -39,6 +39,7 @@ enum sdma_peripheral_type {
 	IMX_DMATYPE_IPU_MEMORY,	/* IPU Memory */
 	IMX_DMATYPE_ASRC,	/* ASRC */
 	IMX_DMATYPE_ESAI,	/* ESAI */
+	IMX_DMATYPE_SSI_DUAL,	/* SSI Dual FIFO */
 };
 
 enum imx_dma_prio {
-- 
1.8.4


