Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422850Ab3FUAf6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 20:35:58 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:48981 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965830Ab3FUAfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 20:35:52 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Kukjin Kim <kgene.kim@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Mark Brown <broonie@kernel.org>, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>,
        Benoit Cousson <benoit.cousson@linaro.org>,
        devicetree-discuss@lists.ozlabs.org,
        Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org,
        Marc Zyngier <marc.zyngier@arm.com>, Nicolas Pitre <nico@fluxnic.net>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will.deacon@arm.com>, Tomasz Figa <tomasz.figa@gmail.com>
Subject: [PATCH v6 3/8] gpio: samsung: Skip legacy GPIO registration if pinctrl-s3c64xx is present
Date: Fri, 21 Jun 2013 02:35:19 +0200
Message-Id: <1371774924-9224-4-git-send-email-tomasz.figa@gmail.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1371774924-9224-1-git-send-email-tomasz.figa@gmail.com>
References: <1371774924-9224-1-git-send-email-tomasz.figa@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new driver handles GPIO on DT-enabled platforms.

Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
---
 drivers/gpio/gpio-samsung.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-samsung.c b/drivers/gpio/gpio-samsung.c
index a1392f4..8d512b1 100644
--- a/drivers/gpio/gpio-samsung.c
+++ b/drivers/gpio/gpio-samsung.c
@@ -2949,7 +2949,7 @@ static __init int samsung_gpiolib_init(void)
 	int i, nr_chips;
 	int group = 0;
 
-#if defined(CONFIG_PINCTRL_EXYNOS) || defined(CONFIG_PINCTRL_EXYNOS5440)
+#if defined(CONFIG_PINCTRL_SAMSUNG) || defined(CONFIG_PINCTRL_EXYNOS5440)
 	/*
 	* This gpio driver includes support for device tree support and there
 	* are platforms using it. In order to maintain compatibility with those
@@ -2967,6 +2967,7 @@ static __init int samsung_gpiolib_init(void)
 		{ .compatible = "samsung,s3c2416-pinctrl", },
 		{ .compatible = "samsung,s3c2440-pinctrl", },
 		{ .compatible = "samsung,s3c2450-pinctrl", },
+		{ .compatible = "samsung,s3c64xx-pinctrl", },
 		{ .compatible = "samsung,exynos4210-pinctrl", },
 		{ .compatible = "samsung,exynos4x12-pinctrl", },
 		{ .compatible = "samsung,exynos5250-pinctrl", },
-- 
1.8.2.1

