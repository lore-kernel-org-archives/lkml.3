Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab3IWVmj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 17:42:39 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:34660 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193Ab3IWVmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 17:42:36 -0400
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
Subject: [PATCH 02/10] pwm-backlight: Add optional enable GPIO
Date: Mon, 23 Sep 2013 23:40:59 +0200
Message-Id: <1379972467-11243-3-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1379972467-11243-1-git-send-email-treding@nvidia.com>
References: <1379972467-11243-1-git-send-email-treding@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To support a wider variety of backlight setups, introduce an optional
enable GPIO. Legacy users of the platform data already have a means of
supporting GPIOs by using the .init(), .exit() and .notify() hooks. DT
users however cannot use those, so an alternative method is required.

In order to ease the introduction of the optional enable GPIO, make it
available in the platform data first, so that existing users can be
converted. Once that has happened a second patch will add code to make
use of it in the driver.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 include/linux/pwm_backlight.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/pwm_backlight.h b/include/linux/pwm_backlight.h
index 56f4a86..2de2e27 100644
--- a/include/linux/pwm_backlight.h
+++ b/include/linux/pwm_backlight.h
@@ -6,6 +6,9 @@
 
 #include <linux/backlight.h>
 
+/* TODO: convert to gpiod_*() API once it has been merged */
+#define PWM_BACKLIGHT_GPIO_ACTIVE_LOW	(1 << 0)
+
 struct platform_pwm_backlight_data {
 	int pwm_id;
 	unsigned int max_brightness;
@@ -13,6 +16,8 @@ struct platform_pwm_backlight_data {
 	unsigned int lth_brightness;
 	unsigned int pwm_period_ns;
 	unsigned int *levels;
+	int enable_gpio;
+	unsigned long enable_gpio_flags;
 	int (*init)(struct device *dev);
 	int (*notify)(struct device *dev, int brightness);
 	void (*notify_after)(struct device *dev, int brightness);
-- 
1.8.4

