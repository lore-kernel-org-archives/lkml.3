Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab3HKQwx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 12:52:53 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:38019
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754539Ab3HKQwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 12:52:12 -0400
X-IronPort-AV: E=Sophos;i="4.89,857,1367964000"; 
   d="scan'208";a="23717958"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Daniel Ribeiro <drwyrm@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Stefan Schmidt <stefan@openezx.org>,
        Harald Welte <laforge@openezx.org>, Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        openezx-devel@lists.openezx.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 14/16] arch/arm/mach-pxa/ezx.c: Avoid using ARRAY_AND_SIZE(e) as a function argument
Date: Sun, 11 Aug 2013 18:51:55 +0200
Message-Id: <1376239917-15594-15-git-send-email-Julia.Lawall@lip6.fr>
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

 arch/arm/mach-pxa/ezx.c |   75 +++++++++++++++++++++++++-----------------------
 1 file changed, 40 insertions(+), 35 deletions(-)

diff --git a/arch/arm/mach-pxa/ezx.c b/arch/arm/mach-pxa/ezx.c
index fe2eb83..879cb1b 100644
--- a/arch/arm/mach-pxa/ezx.c
+++ b/arch/arm/mach-pxa/ezx.c
@@ -797,9 +797,9 @@ static struct platform_device *a780_devices[] __initdata = {
 
 static void __init a780_init(void)
 {
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(ezx_pin_config));
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(gen1_pin_config));
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(a780_pin_config));
+	pxa2xx_mfp_config(ezx_pin_config, ARRAY_SIZE(ezx_pin_config));
+	pxa2xx_mfp_config(gen1_pin_config, ARRAY_SIZE(gen1_pin_config));
+	pxa2xx_mfp_config(a780_pin_config, ARRAY_SIZE(a780_pin_config));
 
 	pxa_set_ffuart_info(NULL);
 	pxa_set_btuart_info(NULL);
@@ -816,8 +816,8 @@ static void __init a780_init(void)
 		platform_device_register(&a780_camera);
 	}
 
-	platform_add_devices(ARRAY_AND_SIZE(ezx_devices));
-	platform_add_devices(ARRAY_AND_SIZE(a780_devices));
+	platform_add_devices(ezx_devices, ARRAY_SIZE(ezx_devices));
+	platform_add_devices(a780_devices, ARRAY_SIZE(a780_devices));
 }
 
 MACHINE_START(EZX_A780, "Motorola EZX A780")
@@ -868,23 +868,24 @@ static struct platform_device *e680_devices[] __initdata = {
 
 static void __init e680_init(void)
 {
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(ezx_pin_config));
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(gen1_pin_config));
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(e680_pin_config));
+	pxa2xx_mfp_config(ezx_pin_config, ARRAY_SIZE(ezx_pin_config));
+	pxa2xx_mfp_config(gen1_pin_config, ARRAY_SIZE(gen1_pin_config));
+	pxa2xx_mfp_config(e680_pin_config, ARRAY_SIZE(e680_pin_config));
 
 	pxa_set_ffuart_info(NULL);
 	pxa_set_btuart_info(NULL);
 	pxa_set_stuart_info(NULL);
 
 	pxa_set_i2c_info(NULL);
-	i2c_register_board_info(0, ARRAY_AND_SIZE(e680_i2c_board_info));
+	i2c_register_board_info(0, e680_i2c_board_info,
+				ARRAY_SIZE(e680_i2c_board_info));
 
 	pxa_set_fb_info(NULL, &ezx_fb_info_1);
 
 	pxa_set_keypad_info(&e680_keypad_platform_data);
 
-	platform_add_devices(ARRAY_AND_SIZE(ezx_devices));
-	platform_add_devices(ARRAY_AND_SIZE(e680_devices));
+	platform_add_devices(ezx_devices, ARRAY_SIZE(ezx_devices));
+	platform_add_devices(e680_devices, ARRAY_SIZE(e680_devices));
 }
 
 MACHINE_START(EZX_E680, "Motorola EZX E680")
@@ -935,23 +936,24 @@ static struct platform_device *a1200_devices[] __initdata = {
 
 static void __init a1200_init(void)
 {
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(ezx_pin_config));
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(gen2_pin_config));
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(a1200_pin_config));
+	pxa2xx_mfp_config(ezx_pin_config, ARRAY_SIZE(ezx_pin_config));
+	pxa2xx_mfp_config(gen2_pin_config, ARRAY_SIZE(gen2_pin_config));
+	pxa2xx_mfp_config(a1200_pin_config, ARRAY_SIZE(a1200_pin_config));
 
 	pxa_set_ffuart_info(NULL);
 	pxa_set_btuart_info(NULL);
 	pxa_set_stuart_info(NULL);
 
 	pxa_set_i2c_info(NULL);
-	i2c_register_board_info(0, ARRAY_AND_SIZE(a1200_i2c_board_info));
+	i2c_register_board_info(0, a1200_i2c_board_info,
+				ARRAY_SIZE(a1200_i2c_board_info));
 
 	pxa_set_fb_info(NULL, &ezx_fb_info_2);
 
 	pxa_set_keypad_info(&a1200_keypad_platform_data);
 
-	platform_add_devices(ARRAY_AND_SIZE(ezx_devices));
-	platform_add_devices(ARRAY_AND_SIZE(a1200_devices));
+	platform_add_devices(ezx_devices, ARRAY_SIZE(ezx_devices));
+	platform_add_devices(a1200_devices, ARRAY_SIZE(a1200_devices));
 }
 
 MACHINE_START(EZX_A1200, "Motorola EZX A1200")
@@ -1122,16 +1124,17 @@ static struct platform_device *a910_devices[] __initdata = {
 
 static void __init a910_init(void)
 {
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(ezx_pin_config));
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(gen2_pin_config));
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(a910_pin_config));
+	pxa2xx_mfp_config(ezx_pin_config, ARRAY_SIZE(ezx_pin_config));
+	pxa2xx_mfp_config(gen2_pin_config, ARRAY_SIZE(gen2_pin_config));
+	pxa2xx_mfp_config(a910_pin_config, ARRAY_SIZE(a910_pin_config));
 
 	pxa_set_ffuart_info(NULL);
 	pxa_set_btuart_info(NULL);
 	pxa_set_stuart_info(NULL);
 
 	pxa_set_i2c_info(NULL);
-	i2c_register_board_info(0, ARRAY_AND_SIZE(a910_i2c_board_info));
+	i2c_register_board_info(0, a910_i2c_board_info,
+				ARRAY_SIZE(a910_i2c_board_info));
 
 	pxa_set_fb_info(NULL, &ezx_fb_info_2);
 
@@ -1142,8 +1145,8 @@ static void __init a910_init(void)
 		platform_device_register(&a910_camera);
 	}
 
-	platform_add_devices(ARRAY_AND_SIZE(ezx_devices));
-	platform_add_devices(ARRAY_AND_SIZE(a910_devices));
+	platform_add_devices(ezx_devices, ARRAY_SIZE(ezx_devices));
+	platform_add_devices(a910_devices, ARRAY_SIZE(a910_devices));
 }
 
 MACHINE_START(EZX_A910, "Motorola EZX A910")
@@ -1194,23 +1197,24 @@ static struct platform_device *e6_devices[] __initdata = {
 
 static void __init e6_init(void)
 {
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(ezx_pin_config));
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(gen2_pin_config));
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(e6_pin_config));
+	pxa2xx_mfp_config(ezx_pin_config, ARRAY_SIZE(ezx_pin_config));
+	pxa2xx_mfp_config(gen2_pin_config, ARRAY_SIZE(gen2_pin_config));
+	pxa2xx_mfp_config(e6_pin_config, ARRAY_SIZE(e6_pin_config));
 
 	pxa_set_ffuart_info(NULL);
 	pxa_set_btuart_info(NULL);
 	pxa_set_stuart_info(NULL);
 
 	pxa_set_i2c_info(NULL);
-	i2c_register_board_info(0, ARRAY_AND_SIZE(e6_i2c_board_info));
+	i2c_register_board_info(0, e6_i2c_board_info,
+				ARRAY_SIZE(e6_i2c_board_info));
 
 	pxa_set_fb_info(NULL, &ezx_fb_info_2);
 
 	pxa_set_keypad_info(&e6_keypad_platform_data);
 
-	platform_add_devices(ARRAY_AND_SIZE(ezx_devices));
-	platform_add_devices(ARRAY_AND_SIZE(e6_devices));
+	platform_add_devices(ezx_devices, ARRAY_SIZE(ezx_devices));
+	platform_add_devices(e6_devices, ARRAY_SIZE(e6_devices));
 }
 
 MACHINE_START(EZX_E6, "Motorola EZX E6")
@@ -1235,23 +1239,24 @@ static struct platform_device *e2_devices[] __initdata = {
 
 static void __init e2_init(void)
 {
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(ezx_pin_config));
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(gen2_pin_config));
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(e2_pin_config));
+	pxa2xx_mfp_config(ezx_pin_config, ARRAY_SIZE(ezx_pin_config));
+	pxa2xx_mfp_config(gen2_pin_config, ARRAY_SIZE(gen2_pin_config));
+	pxa2xx_mfp_config(e2_pin_config, ARRAY_SIZE(e2_pin_config));
 
 	pxa_set_ffuart_info(NULL);
 	pxa_set_btuart_info(NULL);
 	pxa_set_stuart_info(NULL);
 
 	pxa_set_i2c_info(NULL);
-	i2c_register_board_info(0, ARRAY_AND_SIZE(e2_i2c_board_info));
+	i2c_register_board_info(0, e2_i2c_board_info,
+				ARRAY_SIZE(e2_i2c_board_info));
 
 	pxa_set_fb_info(NULL, &ezx_fb_info_2);
 
 	pxa_set_keypad_info(&e2_keypad_platform_data);
 
-	platform_add_devices(ARRAY_AND_SIZE(ezx_devices));
-	platform_add_devices(ARRAY_AND_SIZE(e2_devices));
+	platform_add_devices(ezx_devices, ARRAY_SIZE(ezx_devices));
+	platform_add_devices(e2_devices, ARRAY_SIZE(e2_devices));
 }
 
 MACHINE_START(EZX_E2, "Motorola EZX E2")

