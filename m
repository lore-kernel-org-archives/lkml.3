Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921AbaLTMfw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 07:35:52 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:39218 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbaLTMft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 07:35:49 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arch: arm: plat-samsung: setup-camif.c:  Remove some unused functions
Date: Sat, 20 Dec 2014 13:38:36 +0100
Message-Id: <1419079116-31868-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
s3c_camif_gpio_put() s3c_camif_gpio_get()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/arm/plat-samsung/setup-camif.c |   41 -----------------------------------
 include/media/s3c_camif.h           |    4 ----
 2 files changed, 45 deletions(-)

diff --git a/arch/arm/plat-samsung/setup-camif.c b/arch/arm/plat-samsung/setup-camif.c
index 72d8edb..3a56ee3 100644
--- a/arch/arm/plat-samsung/setup-camif.c
+++ b/arch/arm/plat-samsung/setup-camif.c
@@ -28,44 +28,3 @@ static void camif_get_gpios(int *gpio_start, int *gpio_reset)
 	*gpio_reset = S3C64XX_GPF(3);
 #endif
 }
-
-int s3c_camif_gpio_get(void)
-{
-	int gpio_start, gpio_reset;
-	int ret, i;
-
-	camif_get_gpios(&gpio_start, &gpio_reset);
-
-	for (i = 0; i < S3C_CAMIF_NUM_GPIOS; i++) {
-		int gpio = gpio_start + i;
-
-		if (gpio == gpio_reset)
-			continue;
-
-		ret = gpio_request(gpio, "camif");
-		if (!ret)
-			ret = s3c_gpio_cfgpin(gpio, S3C_GPIO_SFN(2));
-		if (ret) {
-			pr_err("failed to configure GPIO %d\n", gpio);
-			for (--i; i >= 0; i--)
-				gpio_free(gpio--);
-			return ret;
-		}
-		s3c_gpio_setpull(gpio, S3C_GPIO_PULL_NONE);
-	}
-
-	return 0;
-}
-
-void s3c_camif_gpio_put(void)
-{
-	int i, gpio_start, gpio_reset;
-
-	camif_get_gpios(&gpio_start, &gpio_reset);
-
-	for (i = 0; i < S3C_CAMIF_NUM_GPIOS; i++) {
-		int gpio = gpio_start + i;
-		if (gpio != gpio_reset)
-			gpio_free(gpio);
-	}
-}
diff --git a/include/media/s3c_camif.h b/include/media/s3c_camif.h
index df96c2c..aa2f851 100644
--- a/include/media/s3c_camif.h
+++ b/include/media/s3c_camif.h
@@ -38,8 +38,4 @@ struct s3c_camif_plat_data {
 	int (*gpio_put)(void);
 };
 
-/* Platform default helper functions */
-int s3c_camif_gpio_get(void);
-int s3c_camif_gpio_put(void);
-
 #endif /* MEDIA_S3C_CAMIF_ */
-- 
1.7.10.4

