Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757AbaEOH5z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 03:57:55 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:61673 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754066AbaEOH5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 03:57:54 -0400
Message-ID: <1400140671.20469.7.camel@x220>
Subject: [PATCH] ARM: imx: remove check for CONFIG_SDMA_IRAM
From: Paul Bolle <pebolle@tiscali.nl>
To: Shawn Guo <shawn.guo@freescale.com>, Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 15 May 2014 09:57:51 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 May 2014 07:57:52.0183 (UTC) FILETIME=[5F412C70:01CF7013]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A check for CONFIG_SDMA_IRAM was added in v2.6.34. But the Kconfig
symbol SDMA_IRAM was never added. Remove this check.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

Note that none of the MX51_MXC_DMA_CHANNEL_* macros are actually used.
Why are they needed?

 arch/arm/mach-imx/mx51.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm/mach-imx/mx51.h b/arch/arm/mach-imx/mx51.h
index af844f76261a..f2604098fd06 100644
--- a/arch/arm/mach-imx/mx51.h
+++ b/arch/arm/mach-imx/mx51.h
@@ -160,11 +160,7 @@
 #define MX51_MXC_DMA_CHANNEL_SSI1_RX	MXC_DMA_DYNAMIC_CHANNEL
 #define MX51_MXC_DMA_CHANNEL_SSI1_TX	MXC_DMA_DYNAMIC_CHANNEL
 #define MX51_MXC_DMA_CHANNEL_SSI2_RX	MXC_DMA_DYNAMIC_CHANNEL
-#ifdef CONFIG_SDMA_IRAM
-#define MX51_MXC_DMA_CHANNEL_SSI2_TX	(MX51_MXC_DMA_CHANNEL_IRAM + 1)
-#else				/*CONFIG_SDMA_IRAM */
 #define MX51_MXC_DMA_CHANNEL_SSI2_TX	MXC_DMA_DYNAMIC_CHANNEL
-#endif				/*CONFIG_SDMA_IRAM */
 #define MX51_MXC_DMA_CHANNEL_CSPI1_RX	MXC_DMA_DYNAMIC_CHANNEL
 #define MX51_MXC_DMA_CHANNEL_CSPI1_TX	MXC_DMA_DYNAMIC_CHANNEL
 #define MX51_MXC_DMA_CHANNEL_CSPI2_RX	MXC_DMA_DYNAMIC_CHANNEL
-- 
1.9.0

