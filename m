Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab3HKQw2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 12:52:28 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:18222
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754568Ab3HKQwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 12:52:14 -0400
X-IronPort-AV: E=Sophos;i="4.89,857,1367964000"; 
   d="scan'208";a="23717960"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: kernel-janitors@vger.kernel.org, Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 16/16] arch/arm/mach-pxa/stargate2.c: Avoid using ARRAY_AND_SIZE(e) as a function argument
Date: Sun, 11 Aug 2013 18:51:57 +0200
Message-Id: <1376239917-15594-17-git-send-email-Julia.Lawall@lip6.fr>
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

 arch/arm/mach-pxa/stargate2.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-pxa/stargate2.c b/arch/arm/mach-pxa/stargate2.c
index 62aea3e..adacedd 100644
--- a/arch/arm/mach-pxa/stargate2.c
+++ b/arch/arm/mach-pxa/stargate2.c
@@ -406,7 +406,8 @@ static struct i2c_pxa_platform_data i2c_pdata = {
 static void __init imote2_stargate2_init(void)
 {
 
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(sg2_im2_unified_pin_config));
+	pxa2xx_mfp_config(sg2_im2_unified_pin_config,
+			  ARRAY_SIZE(sg2_im2_unified_pin_config));
 
 	pxa_set_ffuart_info(NULL);
 	pxa_set_btuart_info(NULL);
@@ -604,7 +605,7 @@ static struct platform_device *imote2_devices[] = {
 
 static void __init imote2_init(void)
 {
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(imote2_pin_config));
+	pxa2xx_mfp_config(imote2_pin_config, ARRAY_SIZE(imote2_pin_config));
 
 	imote2_stargate2_init();
 
@@ -983,13 +984,15 @@ static void __init stargate2_init(void)
 	   prior to connecting the MFP stuff up. */
 	__raw_writel(__raw_readl(MECR) & ~MECR_NOS, MECR);
 
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(stargate2_pin_config));
+	pxa2xx_mfp_config(stargate2_pin_config,
+			  ARRAY_SIZE(stargate2_pin_config));
 
 	imote2_stargate2_init();
 
-	platform_add_devices(ARRAY_AND_SIZE(stargate2_devices));
+	platform_add_devices(stargate2_devices, ARRAY_SIZE(stargate2_devices));
 
-	i2c_register_board_info(0, ARRAY_AND_SIZE(stargate2_i2c_board_info));
+	i2c_register_board_info(0, stargate2_i2c_board_info,
+				ARRAY_SIZE(stargate2_i2c_board_info));
 	i2c_register_board_info(1, stargate2_pwr_i2c_board_info,
 				ARRAY_SIZE(stargate2_pwr_i2c_board_info));
 

