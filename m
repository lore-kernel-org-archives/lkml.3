Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037Ab3EKLck (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 07:32:40 -0400
Received: from gloria.sntech.de ([95.129.55.99]:50579 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113Ab3EKLcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 07:32:39 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: Dan Williams <djbw@fb.com>
Subject: [RFC 4/4] ARM: SAMSUNG: set s3c24xx_dma_filter for s3c64xx-spi0 device
Date: Sat, 11 May 2013 13:32:35 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        linux-arm-kernel@lists.infradead.org
References: <201305111330.05046.heiko@sntech.de>
In-Reply-To: <201305111330.05046.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201305111332.36077.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The spi-s3c64xx device is also used on the s3c2416 and s3c2443 SoCs.
The driver also already uses only generic dma-engine operations.

Therefore add another elif to set the s3c24xx filter.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 arch/arm/plat-samsung/devs.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/arm/plat-samsung/devs.c b/arch/arm/plat-samsung/devs.c
index 30c2fe2..bb13f99 100644
--- a/arch/arm/plat-samsung/devs.c
+++ b/arch/arm/plat-samsung/devs.c
@@ -32,6 +32,7 @@
 #include <linux/ioport.h>
 #include <linux/platform_data/s3c-hsudc.h>
 #include <linux/platform_data/s3c-hsotg.h>
+#include <linux/platform_data/dma-s3c24xx.h>
 
 #include <media/s5p_hdmi.h>
 
@@ -1513,8 +1514,10 @@ void __init s3c64xx_spi0_set_platdata(int (*cfg_gpio)(void), int src_clk_nr,
 	pd.num_cs = num_cs;
 	pd.src_clk_nr = src_clk_nr;
 	pd.cfg_gpio = (cfg_gpio) ? cfg_gpio : s3c64xx_spi0_cfg_gpio;
-#ifdef CONFIG_PL330_DMA
+#if defined(CONFIG_PL330_DMA)
 	pd.filter = pl330_filter;
+#elif defined(CONFIG_S3C24XX_DMAC)
+	pd.filter = s3c24xx_dma_filter;
 #endif
 
 	s3c_set_platdata(&pd, sizeof(pd), &s3c64xx_device_spi0);
-- 
1.7.2.3

