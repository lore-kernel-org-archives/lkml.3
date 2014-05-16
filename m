Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074AbaEPM3U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 08:29:20 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:57086 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751004AbaEPM3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 08:29:18 -0400
Message-ID: <1400243355.20342.43.camel@x220>
Subject: [PATCH] ARM: S3C24XX: check for
 'CONFIG_SND_SOC_SAMSUNG_SMDK2443_WM9710'
From: Paul Bolle <pebolle@tiscali.nl>
To: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 16 May 2014 14:29:15 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 May 2014 12:29:16.0021 (UTC) FILETIME=[73976A50:01CF7102]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since v2.6.34 there are two checks for CONFIG_SND_SOC_SMDK2443_WM9710.
But a Kconfig symbol SND_SOC_SMDK2443_WM9710 has never been part of the
tree. However, in v2.6.38 a symbol SND_SOC_SAMSUNG_SMDK2443_WM9710 was
added, so it seems these checks should be for its macro.

But the second check is a guard for
    s3c24xx_ac97_setup_gpio(S3C24XX_AC97_GPE0);

And since neither s3c24xx_ac97_setup_gpio nor S3C24XX_AC97_GPE0 are
defined anywhere, that second check can be dropped entirely.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested with git grep. Needs further testing, obviously.

 arch/arm/mach-s3c24xx/mach-smdk2443.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/arm/mach-s3c24xx/mach-smdk2443.c b/arch/arm/mach-s3c24xx/mach-smdk2443.c
index 06c4d77de3a5..ce842189bc64 100644
--- a/arch/arm/mach-s3c24xx/mach-smdk2443.c
+++ b/arch/arm/mach-s3c24xx/mach-smdk2443.c
@@ -112,7 +112,7 @@ static struct platform_device *smdk2443_devices[] __initdata = {
 	&s3c_device_wdt,
 	&s3c_device_i2c0,
 	&s3c_device_hsmmc1,
-#ifdef CONFIG_SND_SOC_SMDK2443_WM9710
+#ifdef CONFIG_SND_SOC_SAMSUNG_SMDK2443_WM9710
 	&s3c_device_ac97,
 #endif
 	&s3c2443_device_dma,
@@ -130,10 +130,6 @@ static void __init smdk2443_machine_init(void)
 {
 	s3c_i2c0_set_platdata(NULL);
 
-#ifdef CONFIG_SND_SOC_SMDK2443_WM9710
-	s3c24xx_ac97_setup_gpio(S3C24XX_AC97_GPE0);
-#endif
-
 	platform_add_devices(smdk2443_devices, ARRAY_SIZE(smdk2443_devices));
 	smdk_machine_init();
 }
-- 
1.9.0

