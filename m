Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625Ab3IWVpV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 17:45:21 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:48543 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754356Ab3IWVmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 17:42:42 -0400
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
Subject: [PATCH 05/10] ARM: SAMSUNG: Initialize PWM backlight enable_gpio field
Date: Mon, 23 Sep 2013 23:41:02 +0200
Message-Id: <1379972467-11243-6-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1379972467-11243-1-git-send-email-treding@nvidia.com>
References: <1379972467-11243-1-git-send-email-treding@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The GPIO API defines 0 as being a valid GPIO number, so this field needs
to be initialized explicitly.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 arch/arm/mach-s3c24xx/mach-h1940.c    | 1 +
 arch/arm/mach-s3c24xx/mach-rx1950.c   | 1 +
 arch/arm/mach-s3c64xx/mach-crag6410.c | 1 +
 arch/arm/mach-s3c64xx/mach-hmt.c      | 1 +
 arch/arm/mach-s3c64xx/mach-smartq.c   | 1 +
 arch/arm/mach-s3c64xx/mach-smdk6410.c | 1 +
 arch/arm/mach-s5p64x0/mach-smdk6440.c | 1 +
 arch/arm/mach-s5p64x0/mach-smdk6450.c | 1 +
 arch/arm/mach-s5pc100/mach-smdkc100.c | 1 +
 arch/arm/mach-s5pv210/mach-smdkv210.c | 1 +
 arch/arm/plat-samsung/dev-backlight.c | 5 +++++
 11 files changed, 15 insertions(+)

diff --git a/arch/arm/mach-s3c24xx/mach-h1940.c b/arch/arm/mach-s3c24xx/mach-h1940.c
index 74dd479..952b6a0 100644
--- a/arch/arm/mach-s3c24xx/mach-h1940.c
+++ b/arch/arm/mach-s3c24xx/mach-h1940.c
@@ -504,6 +504,7 @@ static struct platform_pwm_backlight_data backlight_data = {
 	.dft_brightness = 50,
 	/* tcnt = 0x31 */
 	.pwm_period_ns  = 36296,
+	.enable_gpio    = -1,
 	.init           = h1940_backlight_init,
 	.notify		= h1940_backlight_notify,
 	.exit           = h1940_backlight_exit,
diff --git a/arch/arm/mach-s3c24xx/mach-rx1950.c b/arch/arm/mach-s3c24xx/mach-rx1950.c
index 206b1f7..034b7fe 100644
--- a/arch/arm/mach-s3c24xx/mach-rx1950.c
+++ b/arch/arm/mach-s3c24xx/mach-rx1950.c
@@ -522,6 +522,7 @@ static struct platform_pwm_backlight_data rx1950_backlight_data = {
 	.max_brightness = 24,
 	.dft_brightness = 4,
 	.pwm_period_ns = 48000,
+	.enable_gpio = -1,
 	.init = rx1950_backlight_init,
 	.notify = rx1950_backlight_notify,
 	.exit = rx1950_backlight_exit,
diff --git a/arch/arm/mach-s3c64xx/mach-crag6410.c b/arch/arm/mach-s3c64xx/mach-crag6410.c
index 1a911df..b319bf9 100644
--- a/arch/arm/mach-s3c64xx/mach-crag6410.c
+++ b/arch/arm/mach-s3c64xx/mach-crag6410.c
@@ -114,6 +114,7 @@ static struct platform_pwm_backlight_data crag6410_backlight_data = {
 	.max_brightness	= 1000,
 	.dft_brightness	= 600,
 	.pwm_period_ns	= 100000,	/* about 1kHz */
+	.enable_gpio	= -1,
 };
 
 static struct platform_device crag6410_backlight_device = {
diff --git a/arch/arm/mach-s3c64xx/mach-hmt.c b/arch/arm/mach-s3c64xx/mach-hmt.c
index e806404..614a03a 100644
--- a/arch/arm/mach-s3c64xx/mach-hmt.c
+++ b/arch/arm/mach-s3c64xx/mach-hmt.c
@@ -114,6 +114,7 @@ static struct platform_pwm_backlight_data hmt_backlight_data = {
 	.max_brightness	= 100 * 256,
 	.dft_brightness	= 40 * 256,
 	.pwm_period_ns	= 1000000000 / (100 * 256 * 20),
+	.enable_gpio	= -1,
 	.init		= hmt_bl_init,
 	.notify		= hmt_bl_notify,
 	.exit		= hmt_bl_exit,
diff --git a/arch/arm/mach-s3c64xx/mach-smartq.c b/arch/arm/mach-s3c64xx/mach-smartq.c
index 0f47237..a6b338f 100644
--- a/arch/arm/mach-s3c64xx/mach-smartq.c
+++ b/arch/arm/mach-s3c64xx/mach-smartq.c
@@ -151,6 +151,7 @@ static struct platform_pwm_backlight_data smartq_backlight_data = {
 	.max_brightness	= 1000,
 	.dft_brightness	= 600,
 	.pwm_period_ns	= 1000000000 / (1000 * 20),
+	.enable_gpio	= -1,
 	.init		= smartq_bl_init,
 };
 
diff --git a/arch/arm/mach-s3c64xx/mach-smdk6410.c b/arch/arm/mach-s3c64xx/mach-smdk6410.c
index 2a7b32c..d5ea938 100644
--- a/arch/arm/mach-s3c64xx/mach-smdk6410.c
+++ b/arch/arm/mach-s3c64xx/mach-smdk6410.c
@@ -625,6 +625,7 @@ static struct samsung_bl_gpio_info smdk6410_bl_gpio_info = {
 
 static struct platform_pwm_backlight_data smdk6410_bl_data = {
 	.pwm_id = 1,
+	.enable_gpio = -1,
 };
 
 static struct s3c_hsotg_plat smdk6410_hsotg_pdata;
diff --git a/arch/arm/mach-s5p64x0/mach-smdk6440.c b/arch/arm/mach-s5p64x0/mach-smdk6440.c
index 0b00304..9efdcc0 100644
--- a/arch/arm/mach-s5p64x0/mach-smdk6440.c
+++ b/arch/arm/mach-s5p64x0/mach-smdk6440.c
@@ -223,6 +223,7 @@ static struct samsung_bl_gpio_info smdk6440_bl_gpio_info = {
 
 static struct platform_pwm_backlight_data smdk6440_bl_data = {
 	.pwm_id = 1,
+	.enable_gpio = -1,
 };
 
 static void __init smdk6440_map_io(void)
diff --git a/arch/arm/mach-s5p64x0/mach-smdk6450.c b/arch/arm/mach-s5p64x0/mach-smdk6450.c
index 5949296..c3cacc0 100644
--- a/arch/arm/mach-s5p64x0/mach-smdk6450.c
+++ b/arch/arm/mach-s5p64x0/mach-smdk6450.c
@@ -242,6 +242,7 @@ static struct samsung_bl_gpio_info smdk6450_bl_gpio_info = {
 
 static struct platform_pwm_backlight_data smdk6450_bl_data = {
 	.pwm_id = 1,
+	.enable_gpio = -1,
 };
 
 static void __init smdk6450_map_io(void)
diff --git a/arch/arm/mach-s5pc100/mach-smdkc100.c b/arch/arm/mach-s5pc100/mach-smdkc100.c
index 7c57a22..9e256b9 100644
--- a/arch/arm/mach-s5pc100/mach-smdkc100.c
+++ b/arch/arm/mach-s5pc100/mach-smdkc100.c
@@ -216,6 +216,7 @@ static struct samsung_bl_gpio_info smdkc100_bl_gpio_info = {
 
 static struct platform_pwm_backlight_data smdkc100_bl_data = {
 	.pwm_id = 0,
+	.enable_gpio = -1,
 };
 
 static void __init smdkc100_map_io(void)
diff --git a/arch/arm/mach-s5pv210/mach-smdkv210.c b/arch/arm/mach-s5pv210/mach-smdkv210.c
index 6d72bb99..f52cc15 100644
--- a/arch/arm/mach-s5pv210/mach-smdkv210.c
+++ b/arch/arm/mach-s5pv210/mach-smdkv210.c
@@ -279,6 +279,7 @@ static struct samsung_bl_gpio_info smdkv210_bl_gpio_info = {
 static struct platform_pwm_backlight_data smdkv210_bl_data = {
 	.pwm_id = 3,
 	.pwm_period_ns = 1000,
+	.enable_gpio = -1,
 };
 
 static void __init smdkv210_map_io(void)
diff --git a/arch/arm/plat-samsung/dev-backlight.c b/arch/arm/plat-samsung/dev-backlight.c
index d51f956..80e7450 100644
--- a/arch/arm/plat-samsung/dev-backlight.c
+++ b/arch/arm/plat-samsung/dev-backlight.c
@@ -70,6 +70,7 @@ static struct samsung_bl_drvdata samsung_dfl_bl_data __initdata = {
 		.max_brightness = 255,
 		.dft_brightness = 255,
 		.pwm_period_ns  = 78770,
+		.enable_gpio    = -1,
 		.init           = samsung_bl_init,
 		.exit           = samsung_bl_exit,
 	},
@@ -121,6 +122,10 @@ void __init samsung_bl_set(struct samsung_bl_gpio_info *gpio_info,
 		samsung_bl_data->lth_brightness = bl_data->lth_brightness;
 	if (bl_data->pwm_period_ns)
 		samsung_bl_data->pwm_period_ns = bl_data->pwm_period_ns;
+	if (bl_data->enable_gpio)
+		samsung_bl_data->enable_gpio = bl_data->enable_gpio;
+	if (bl_data->enable_gpio_flags)
+		samsung_bl_data->enable_gpio_flags = bl_data->enable_gpio_flags;
 	if (bl_data->init)
 		samsung_bl_data->init = bl_data->init;
 	if (bl_data->notify)
-- 
1.8.4

