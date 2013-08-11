Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab3HKQwz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 12:52:55 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:18222
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754437Ab3HKQwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 12:52:11 -0400
X-IronPort-AV: E=Sophos;i="4.89,857,1367964000"; 
   d="scan'208";a="23717957"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Philipp Zabel <philipp.zabel@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Paul Parsons <lost.distance@yahoo.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 13/16] arch/arm/mach-pxa/hx4700.c: Avoid using ARRAY_AND_SIZE(e) as a function argument
Date: Sun, 11 Aug 2013 18:51:54 +0200
Message-Id: <1376239917-15594-14-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1376239917-15594-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1376239917-15594-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Replace ARRAY_AND_SIZE(e) in function argument position to avoid hiding the
arity of the called function.

The semantic match that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e,f;
@@

f(...,
- ARRAY_AND_SIZE(e)
+ e,ARRAY_SIZE(e)
  ,...)
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Not compiled.

 arch/arm/mach-pxa/hx4700.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-pxa/hx4700.c b/arch/arm/mach-pxa/hx4700.c
index 133109e..8cac0a8 100644
--- a/arch/arm/mach-pxa/hx4700.c
+++ b/arch/arm/mach-pxa/hx4700.c
@@ -866,9 +866,9 @@ static void __init hx4700_init(void)
 
 	PCFR = PCFR_GPR_EN | PCFR_OPDE;
 
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(hx4700_pin_config));
+	pxa2xx_mfp_config(hx4700_pin_config, ARRAY_SIZE(hx4700_pin_config));
 	gpio_set_wake(GPIO12_HX4700_ASIC3_IRQ, 1);
-	ret = gpio_request_array(ARRAY_AND_SIZE(global_gpios));
+	ret = gpio_request_array(global_gpios, ARRAY_SIZE(global_gpios));
 	if (ret)
 		pr_err ("hx4700: Failed to request GPIOs.\n");
 
@@ -882,10 +882,13 @@ static void __init hx4700_init(void)
 	pxa_set_ficp_info(&ficp_info);
 	pxa27x_set_i2c_power_info(NULL);
 	pxa_set_i2c_info(NULL);
-	i2c_register_board_info(0, ARRAY_AND_SIZE(i2c_board_info));
-	i2c_register_board_info(1, ARRAY_AND_SIZE(pi2c_board_info));
+	i2c_register_board_info(0, i2c_board_info,
+				ARRAY_SIZE(i2c_board_info));
+	i2c_register_board_info(1, pi2c_board_info,
+				ARRAY_SIZE(pi2c_board_info));
 	pxa2xx_set_spi_info(2, &pxa_ssp2_master_info);
-	spi_register_board_info(ARRAY_AND_SIZE(tsc2046_board_info));
+	spi_register_board_info(tsc2046_board_info,
+				ARRAY_SIZE(tsc2046_board_info));
 
 	gpio_set_value(GPIO71_HX4700_ASIC3_nRESET, 0);
 	mdelay(10);

