Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406Ab3IWVmp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 17:42:45 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:45735 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319Ab3IWVmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 17:42:40 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Tony Lindgren <tony@atomide.com>, Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        openezx-devel@lists.openezx.org, linux-samsung-soc@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 04/10] ARM: pxa: Initialize PWM backlight enable_gpio field
Date: Mon, 23 Sep 2013 23:41:01 +0200
Message-Id: <1379972467-11243-5-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1379972467-11243-1-git-send-email-treding@nvidia.com>
References: <1379972467-11243-1-git-send-email-treding@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The GPIO API defines 0 as being a valid GPIO number, so this field needs
to be initialized explicitly.

A special case is the Palm Tungsten|C board. Since it doesn't use any
quirks that would require the existing .init() or .exit() hooks it can
simply use the new enable_gpio field.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 arch/arm/mach-pxa/cm-x300.c               |  1 +
 arch/arm/mach-pxa/colibri-pxa270-income.c |  1 +
 arch/arm/mach-pxa/ezx.c                   |  1 +
 arch/arm/mach-pxa/hx4700.c                |  1 +
 arch/arm/mach-pxa/lpd270.c                |  1 +
 arch/arm/mach-pxa/magician.c              |  1 +
 arch/arm/mach-pxa/mainstone.c             |  1 +
 arch/arm/mach-pxa/mioa701.c               |  1 +
 arch/arm/mach-pxa/palm27x.c               |  1 +
 arch/arm/mach-pxa/palmtc.c                | 35 +------------------------------
 arch/arm/mach-pxa/palmte2.c               |  1 +
 arch/arm/mach-pxa/pcm990-baseboard.c      |  1 +
 arch/arm/mach-pxa/raumfeld.c              |  1 +
 arch/arm/mach-pxa/tavorevb.c              |  2 ++
 arch/arm/mach-pxa/viper.c                 |  1 +
 arch/arm/mach-pxa/z2.c                    |  2 ++
 arch/arm/mach-pxa/zylonite.c              |  1 +
 17 files changed, 19 insertions(+), 34 deletions(-)

diff --git a/arch/arm/mach-pxa/cm-x300.c b/arch/arm/mach-pxa/cm-x300.c
index f942349..584439b 100644
--- a/arch/arm/mach-pxa/cm-x300.c
+++ b/arch/arm/mach-pxa/cm-x300.c
@@ -310,6 +310,7 @@ static struct platform_pwm_backlight_data cm_x300_backlight_data = {
 	.max_brightness	= 100,
 	.dft_brightness	= 100,
 	.pwm_period_ns	= 10000,
+	.enable_gpio	= -1,
 };
 
 static struct platform_device cm_x300_backlight_device = {
diff --git a/arch/arm/mach-pxa/colibri-pxa270-income.c b/arch/arm/mach-pxa/colibri-pxa270-income.c
index 2d4a7b4..3aa2646 100644
--- a/arch/arm/mach-pxa/colibri-pxa270-income.c
+++ b/arch/arm/mach-pxa/colibri-pxa270-income.c
@@ -189,6 +189,7 @@ static struct platform_pwm_backlight_data income_backlight_data = {
 	.max_brightness	= 0x3ff,
 	.dft_brightness	= 0x1ff,
 	.pwm_period_ns	= 1000000,
+	.enable_gpio	= -1,
 };
 
 static struct platform_device income_backlight = {
diff --git a/arch/arm/mach-pxa/ezx.c b/arch/arm/mach-pxa/ezx.c
index fe2eb83..ab93441 100644
--- a/arch/arm/mach-pxa/ezx.c
+++ b/arch/arm/mach-pxa/ezx.c
@@ -54,6 +54,7 @@ static struct platform_pwm_backlight_data ezx_backlight_data = {
 	.max_brightness	= 1023,
 	.dft_brightness	= 1023,
 	.pwm_period_ns	= 78770,
+	.enable_gpio	= -1,
 };
 
 static struct platform_device ezx_backlight_device = {
diff --git a/arch/arm/mach-pxa/hx4700.c b/arch/arm/mach-pxa/hx4700.c
index 133109e..a7c30eb 100644
--- a/arch/arm/mach-pxa/hx4700.c
+++ b/arch/arm/mach-pxa/hx4700.c
@@ -561,6 +561,7 @@ static struct platform_pwm_backlight_data backlight_data = {
 	.max_brightness = 200,
 	.dft_brightness = 100,
 	.pwm_period_ns  = 30923,
+	.enable_gpio    = -1,
 };
 
 static struct platform_device backlight = {
diff --git a/arch/arm/mach-pxa/lpd270.c b/arch/arm/mach-pxa/lpd270.c
index 1255ee0..9f6ec16 100644
--- a/arch/arm/mach-pxa/lpd270.c
+++ b/arch/arm/mach-pxa/lpd270.c
@@ -269,6 +269,7 @@ static struct platform_pwm_backlight_data lpd270_backlight_data = {
 	.max_brightness	= 1,
 	.dft_brightness	= 1,
 	.pwm_period_ns	= 78770,
+	.enable_gpio	= -1,
 };
 
 static struct platform_device lpd270_backlight_device = {
diff --git a/arch/arm/mach-pxa/magician.c b/arch/arm/mach-pxa/magician.c
index f44532f..fab30d6 100644
--- a/arch/arm/mach-pxa/magician.c
+++ b/arch/arm/mach-pxa/magician.c
@@ -378,6 +378,7 @@ static struct platform_pwm_backlight_data backlight_data = {
 	.max_brightness = 272,
 	.dft_brightness = 100,
 	.pwm_period_ns  = 30923,
+	.enable_gpio    = -1,
 	.init           = magician_backlight_init,
 	.notify         = magician_backlight_notify,
 	.exit           = magician_backlight_exit,
diff --git a/arch/arm/mach-pxa/mainstone.c b/arch/arm/mach-pxa/mainstone.c
index dd70343..08ccc07 100644
--- a/arch/arm/mach-pxa/mainstone.c
+++ b/arch/arm/mach-pxa/mainstone.c
@@ -338,6 +338,7 @@ static struct platform_pwm_backlight_data mainstone_backlight_data = {
 	.max_brightness	= 1023,
 	.dft_brightness	= 1023,
 	.pwm_period_ns	= 78770,
+	.enable_gpio	= -1,
 };
 
 static struct platform_device mainstone_backlight_device = {
diff --git a/arch/arm/mach-pxa/mioa701.c b/arch/arm/mach-pxa/mioa701.c
index acc9d3c..f70583f 100644
--- a/arch/arm/mach-pxa/mioa701.c
+++ b/arch/arm/mach-pxa/mioa701.c
@@ -186,6 +186,7 @@ static struct platform_pwm_backlight_data mioa701_backlight_data = {
 	.max_brightness	= 100,
 	.dft_brightness	= 50,
 	.pwm_period_ns	= 4000 * 1024,	/* Fl = 250kHz */
+	.enable_gpio	= -1,
 };
 
 /*
diff --git a/arch/arm/mach-pxa/palm27x.c b/arch/arm/mach-pxa/palm27x.c
index 17d4c53..e54a296 100644
--- a/arch/arm/mach-pxa/palm27x.c
+++ b/arch/arm/mach-pxa/palm27x.c
@@ -322,6 +322,7 @@ static struct platform_pwm_backlight_data palm27x_backlight_data = {
 	.max_brightness	= 0xfe,
 	.dft_brightness	= 0x7e,
 	.pwm_period_ns	= 3500 * 1024,
+	.enable_gpio	= -1,
 	.init		= palm27x_backlight_init,
 	.notify		= palm27x_backlight_notify,
 	.exit		= palm27x_backlight_exit,
diff --git a/arch/arm/mach-pxa/palmtc.c b/arch/arm/mach-pxa/palmtc.c
index 100b176f..7691c97 100644
--- a/arch/arm/mach-pxa/palmtc.c
+++ b/arch/arm/mach-pxa/palmtc.c
@@ -166,45 +166,12 @@ static inline void palmtc_keys_init(void) {}
  * Backlight
  ******************************************************************************/
 #if defined(CONFIG_BACKLIGHT_PWM) || defined(CONFIG_BACKLIGHT_PWM_MODULE)
-static int palmtc_backlight_init(struct device *dev)
-{
-	int ret;
-
-	ret = gpio_request(GPIO_NR_PALMTC_BL_POWER, "BL POWER");
-	if (ret)
-		goto err;
-	ret = gpio_direction_output(GPIO_NR_PALMTC_BL_POWER, 1);
-	if (ret)
-		goto err2;
-
-	return 0;
-
-err2:
-	gpio_free(GPIO_NR_PALMTC_BL_POWER);
-err:
-	return ret;
-}
-
-static int palmtc_backlight_notify(struct device *dev, int brightness)
-{
-	/* backlight is on when GPIO16 AF0 is high */
-	gpio_set_value(GPIO_NR_PALMTC_BL_POWER, brightness);
-	return brightness;
-}
-
-static void palmtc_backlight_exit(struct device *dev)
-{
-	gpio_free(GPIO_NR_PALMTC_BL_POWER);
-}
-
 static struct platform_pwm_backlight_data palmtc_backlight_data = {
 	.pwm_id		= 1,
 	.max_brightness	= PALMTC_MAX_INTENSITY,
 	.dft_brightness	= PALMTC_MAX_INTENSITY,
 	.pwm_period_ns	= PALMTC_PERIOD_NS,
-	.init		= palmtc_backlight_init,
-	.notify		= palmtc_backlight_notify,
-	.exit		= palmtc_backlight_exit,
+	.enable_gpio	= GPIO_NR_PALMTC_BL_POWER,
 };
 
 static struct platform_device palmtc_backlight = {
diff --git a/arch/arm/mach-pxa/palmte2.c b/arch/arm/mach-pxa/palmte2.c
index 0742721..956fd24 100644
--- a/arch/arm/mach-pxa/palmte2.c
+++ b/arch/arm/mach-pxa/palmte2.c
@@ -165,6 +165,7 @@ static struct platform_pwm_backlight_data palmte2_backlight_data = {
 	.max_brightness	= PALMTE2_MAX_INTENSITY,
 	.dft_brightness	= PALMTE2_MAX_INTENSITY,
 	.pwm_period_ns	= PALMTE2_PERIOD_NS,
+	.enable_gpio	= -1,
 	.init		= palmte2_backlight_init,
 	.notify		= palmte2_backlight_notify,
 	.exit		= palmte2_backlight_exit,
diff --git a/arch/arm/mach-pxa/pcm990-baseboard.c b/arch/arm/mach-pxa/pcm990-baseboard.c
index 3133ba8..9a4e470 100644
--- a/arch/arm/mach-pxa/pcm990-baseboard.c
+++ b/arch/arm/mach-pxa/pcm990-baseboard.c
@@ -153,6 +153,7 @@ static struct platform_pwm_backlight_data pcm990_backlight_data = {
 	.max_brightness	= 1023,
 	.dft_brightness	= 1023,
 	.pwm_period_ns	= 78770,
+	.enable_gpio	= -1,
 };
 
 static struct platform_device pcm990_backlight_device = {
diff --git a/arch/arm/mach-pxa/raumfeld.c b/arch/arm/mach-pxa/raumfeld.c
index 969b0ba..8386dc3 100644
--- a/arch/arm/mach-pxa/raumfeld.c
+++ b/arch/arm/mach-pxa/raumfeld.c
@@ -539,6 +539,7 @@ static struct platform_pwm_backlight_data raumfeld_pwm_backlight_data = {
 	.dft_brightness	= 100,
 	/* 10000 ns = 10 ms ^= 100 kHz */
 	.pwm_period_ns	= 10000,
+	.enable_gpio	= -1,
 };
 
 static struct platform_device raumfeld_pwm_backlight_device = {
diff --git a/arch/arm/mach-pxa/tavorevb.c b/arch/arm/mach-pxa/tavorevb.c
index 4680efe..a71da84 100644
--- a/arch/arm/mach-pxa/tavorevb.c
+++ b/arch/arm/mach-pxa/tavorevb.c
@@ -175,6 +175,7 @@ static struct platform_pwm_backlight_data tavorevb_backlight_data[] = {
 		.max_brightness	= 100,
 		.dft_brightness	= 100,
 		.pwm_period_ns	= 100000,
+		.enable_gpio	= -1,
 	},
 	[1] = {
 		/* secondary backlight */
@@ -182,6 +183,7 @@ static struct platform_pwm_backlight_data tavorevb_backlight_data[] = {
 		.max_brightness	= 100,
 		.dft_brightness	= 100,
 		.pwm_period_ns	= 100000,
+		.enable_gpio	= -1,
 	},
 };
 
diff --git a/arch/arm/mach-pxa/viper.c b/arch/arm/mach-pxa/viper.c
index 9c363c0..29905b1 100644
--- a/arch/arm/mach-pxa/viper.c
+++ b/arch/arm/mach-pxa/viper.c
@@ -401,6 +401,7 @@ static struct platform_pwm_backlight_data viper_backlight_data = {
 	.max_brightness	= 100,
 	.dft_brightness	= 100,
 	.pwm_period_ns	= 1000000,
+	.enable_gpio	= -1,
 	.init		= viper_backlight_init,
 	.notify		= viper_backlight_notify,
 	.exit		= viper_backlight_exit,
diff --git a/arch/arm/mach-pxa/z2.c b/arch/arm/mach-pxa/z2.c
index 2513d8f..e1a121b 100644
--- a/arch/arm/mach-pxa/z2.c
+++ b/arch/arm/mach-pxa/z2.c
@@ -206,6 +206,7 @@ static struct platform_pwm_backlight_data z2_backlight_data[] = {
 		.max_brightness	= 1023,
 		.dft_brightness	= 0,
 		.pwm_period_ns	= 1260320,
+		.enable_gpio	= -1,
 	},
 	[1] = {
 		/* LCD Backlight */
@@ -213,6 +214,7 @@ static struct platform_pwm_backlight_data z2_backlight_data[] = {
 		.max_brightness	= 1023,
 		.dft_brightness	= 512,
 		.pwm_period_ns	= 1260320,
+		.enable_gpio	= -1,
 	},
 };
 
diff --git a/arch/arm/mach-pxa/zylonite.c b/arch/arm/mach-pxa/zylonite.c
index 36cf7cf..77daea4 100644
--- a/arch/arm/mach-pxa/zylonite.c
+++ b/arch/arm/mach-pxa/zylonite.c
@@ -125,6 +125,7 @@ static struct platform_pwm_backlight_data zylonite_backlight_data = {
 	.max_brightness	= 100,
 	.dft_brightness	= 100,
 	.pwm_period_ns	= 10000,
+	.enable_gpio	= -1,
 };
 
 static struct platform_device zylonite_backlight_device = {
-- 
1.8.4

