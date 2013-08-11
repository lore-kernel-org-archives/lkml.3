Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab3HKQzT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 12:55:19 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:18222
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754435Ab3HKQwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 12:52:07 -0400
X-IronPort-AV: E=Sophos;i="4.89,857,1367964000"; 
   d="scan'208";a="23717950"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/16] arch/arm/mach-pxa: Avoid using ARRAY_AND_SIZE(e) as a function argument
Date: Sun, 11 Aug 2013 18:51:47 +0200
Message-Id: <1376239917-15594-7-git-send-email-Julia.Lawall@lip6.fr>
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

 arch/arm/mach-pxa/palmld.c  |    2 +-
 arch/arm/mach-pxa/palmt5.c  |    2 +-
 arch/arm/mach-pxa/palmtc.c  |    2 +-
 arch/arm/mach-pxa/palmte2.c |    7 ++++---
 arch/arm/mach-pxa/palmtx.c  |    2 +-
 5 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-pxa/palmld.c b/arch/arm/mach-pxa/palmld.c
index cf210b1..4e3016a 100644
--- a/arch/arm/mach-pxa/palmld.c
+++ b/arch/arm/mach-pxa/palmld.c
@@ -322,7 +322,7 @@ static void __init palmld_map_io(void)
 
 static void __init palmld_init(void)
 {
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(palmld_pin_config));
+	pxa2xx_mfp_config(palmld_pin_config, ARRAY_SIZE(palmld_pin_config));
 	pxa_set_ffuart_info(NULL);
 	pxa_set_btuart_info(NULL);
 	pxa_set_stuart_info(NULL);
diff --git a/arch/arm/mach-pxa/palmt5.c b/arch/arm/mach-pxa/palmt5.c
index 3ed9b02..c054003 100644
--- a/arch/arm/mach-pxa/palmt5.c
+++ b/arch/arm/mach-pxa/palmt5.c
@@ -184,7 +184,7 @@ static void __init palmt5_reserve(void)
 
 static void __init palmt5_init(void)
 {
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(palmt5_pin_config));
+	pxa2xx_mfp_config(palmt5_pin_config, ARRAY_SIZE(palmt5_pin_config));
 	pxa_set_ffuart_info(NULL);
 	pxa_set_btuart_info(NULL);
 	pxa_set_stuart_info(NULL);
diff --git a/arch/arm/mach-pxa/palmtc.c b/arch/arm/mach-pxa/palmtc.c
index 100b176..aea2e19 100644
--- a/arch/arm/mach-pxa/palmtc.c
+++ b/arch/arm/mach-pxa/palmtc.c
@@ -517,7 +517,7 @@ static inline void palmtc_lcd_init(void) {}
  ******************************************************************************/
 static void __init palmtc_init(void)
 {
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(palmtc_pin_config));
+	pxa2xx_mfp_config(palmtc_pin_config, ARRAY_SIZE(palmtc_pin_config));
 
 	pxa_set_ffuart_info(NULL);
 	pxa_set_btuart_info(NULL);
diff --git a/arch/arm/mach-pxa/palmte2.c b/arch/arm/mach-pxa/palmte2.c
index 0742721..6cfd6b0 100644
--- a/arch/arm/mach-pxa/palmte2.c
+++ b/arch/arm/mach-pxa/palmte2.c
@@ -145,7 +145,8 @@ static struct gpio palmte_bl_gpios[] = {
 
 static int palmte2_backlight_init(struct device *dev)
 {
-	return gpio_request_array(ARRAY_AND_SIZE(palmte_bl_gpios));
+	return gpio_request_array(palmte_bl_gpios,
+				  ARRAY_SIZE(palmte_bl_gpios));
 }
 
 static int palmte2_backlight_notify(struct device *dev, int brightness)
@@ -157,7 +158,7 @@ static int palmte2_backlight_notify(struct device *dev, int brightness)
 
 static void palmte2_backlight_exit(struct device *dev)
 {
-	gpio_free_array(ARRAY_AND_SIZE(palmte_bl_gpios));
+	gpio_free_array(palmte_bl_gpios, ARRAY_SIZE(palmte_bl_gpios));
 }
 
 static struct platform_pwm_backlight_data palmte2_backlight_data = {
@@ -342,7 +343,7 @@ static void __init palmte2_udc_init(void)
 
 static void __init palmte2_init(void)
 {
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(palmte2_pin_config));
+	pxa2xx_mfp_config(palmte2_pin_config, ARRAY_SIZE(palmte2_pin_config));
 
 	pxa_set_ffuart_info(NULL);
 	pxa_set_btuart_info(NULL);
diff --git a/arch/arm/mach-pxa/palmtx.c b/arch/arm/mach-pxa/palmtx.c
index 83f830d..750ff97 100644
--- a/arch/arm/mach-pxa/palmtx.c
+++ b/arch/arm/mach-pxa/palmtx.c
@@ -341,7 +341,7 @@ static void __init palmtx_map_io(void)
 
 static void __init palmtx_init(void)
 {
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(palmtx_pin_config));
+	pxa2xx_mfp_config(palmtx_pin_config, ARRAY_SIZE(palmtx_pin_config));
 	pxa_set_ffuart_info(NULL);
 	pxa_set_btuart_info(NULL);
 	pxa_set_stuart_info(NULL);

