Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762165Ab3IDWg1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 18:36:27 -0400
Received: from gloria.sntech.de ([95.129.55.99]:59060 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760558Ab3IDWgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 18:36:25 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: kgene.kim@samsung.com
Subject: [PATCH v4 4/4] ARM: SAMSUNG: set s3c24xx_dma_filter for s3c64xx-spi0 device
Date: Thu, 5 Sep 2013 00:36:18 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Dan Williams <djbw@fb.com>, Vinod Koul <vinod.koul@intel.com>,
        linus.walleij@linaro.org, Tomasz Figa <tomasz.figa@gmail.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
References: <201309050033.50333.heiko@sntech.de>
In-Reply-To: <201309050033.50333.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201309050036.18394.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The spi-s3c64xx device is also used on the s3c2416 and s3c2443 SoCs.
The driver also already uses only generic dma-engine operations.

Therefore add another elif to set the s3c24xx filter.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/plat-samsung/devs.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm/plat-samsung/devs.c b/arch/arm/plat-samsung/devs.c
index 8ce0ac0..a7b9b9e 100644
--- a/arch/arm/plat-samsung/devs.c
+++ b/arch/arm/plat-samsung/devs.c
@@ -32,6 +32,7 @@
 #include <linux/ioport.h>
 #include <linux/platform_data/s3c-hsudc.h>
 #include <linux/platform_data/s3c-hsotg.h>
+#include <linux/platform_data/dma-s3c24xx.h>
 
 #include <media/s5p_hdmi.h>
 
@@ -1499,8 +1500,10 @@ void __init s3c64xx_spi0_set_platdata(int (*cfg_gpio)(void), int src_clk_nr,
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
1.7.10.4

