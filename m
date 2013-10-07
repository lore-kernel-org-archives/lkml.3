Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190Ab3JGLkJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 07:40:09 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:42205 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527Ab3JGLjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 07:39:53 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>, Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        devicetree@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 04/12] pwm-backlight: Add optional enable GPIO
Date: Mon,  7 Oct 2013 13:37:38 +0200
Message-Id: <1381145866-445-5-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381145866-445-1-git-send-email-treding@nvidia.com>
References: <1381145866-445-1-git-send-email-treding@nvidia.com>
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

