Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005Ab3GNMCX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 08:02:23 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:62693 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751595Ab3GNMCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 08:02:22 -0400
Message-ID: <1373803339.1370.18.camel@x61.thuisdomein>
Subject: [PATCH] cpufreq: s3c24xx: fix typo "ARM_S3C24XX"
From: Paul Bolle <pebolle@tiscali.nl>
To: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 14 Jul 2013 14:02:19 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jul 2013 12:02:21.0012 (UTC) FILETIME=[FE911940:01CE8089]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kconfig symbol S3C24XX_PLL depends on ARM_S3C24XX. But that symbol
doesn't exist. Commit f023f8dd59bf ("cpufreq: s3c24xx: move cpufreq
driver to drivers/cpufreq"), which added this typo, makes clear that
ARM_S3C24XX_CPUFREQ was intended here.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested!

 arch/arm/mach-s3c24xx/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-s3c24xx/Kconfig b/arch/arm/mach-s3c24xx/Kconfig
index 6d9252e..7791ac7 100644
--- a/arch/arm/mach-s3c24xx/Kconfig
+++ b/arch/arm/mach-s3c24xx/Kconfig
@@ -208,7 +208,7 @@ config S3C24XX_GPIO_EXTRA128
 
 config S3C24XX_PLL
 	bool "Support CPUfreq changing of PLL frequency (EXPERIMENTAL)"
-	depends on ARM_S3C24XX
+	depends on ARM_S3C24XX_CPUFREQ
 	help
 	  Compile in support for changing the PLL frequency from the
 	  S3C24XX series CPUfreq driver. The PLL takes time to settle
-- 
1.8.1.4

