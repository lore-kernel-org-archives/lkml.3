Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118AbaCCQFT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 11:05:19 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:59786 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754821AbaCCQCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 11:02:41 -0500
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tomasz Figa <t.figa@samsung.com>, Mark Brown <broonie@kernel.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: [PATCH v2 04/11] ARM: s3c64xx: pm: Use name field of generic_pm_domain
Date: Mon,  3 Mar 2014 17:02:09 +0100
Message-Id: <1393862536-9842-5-git-send-email-tomasz.figa@gmail.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393862536-9842-1-git-send-email-tomasz.figa@gmail.com>
References: <1393862536-9842-1-git-send-email-tomasz.figa@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes name field from private s3c64xx_pm_domain struct and
moves domain name to dedicated field of generic_pm_domain struct.

Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
---
 arch/arm/mach-s3c64xx/pm.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/arm/mach-s3c64xx/pm.c b/arch/arm/mach-s3c64xx/pm.c
index b5a6698..df4b7b2 100644
--- a/arch/arm/mach-s3c64xx/pm.c
+++ b/arch/arm/mach-s3c64xx/pm.c
@@ -36,7 +36,6 @@
 #include "regs-syscon-power.h"
 
 struct s3c64xx_pm_domain {
-	char *const name;
 	u32 ena;
 	u32 pwr_stat;
 	struct generic_pm_domain pd;
@@ -77,7 +76,7 @@ static int s3c64xx_pd_on(struct generic_pm_domain *domain)
 		} while (retry--);
 
 		if (!retry) {
-			pr_err("Failed to start domain %s\n", pd->name);
+			pr_err("Failed to start domain %s\n", pd->pd.name);
 			return -EBUSY;
 		}
 	}
@@ -86,78 +85,78 @@ static int s3c64xx_pd_on(struct generic_pm_domain *domain)
 }
 
 static struct s3c64xx_pm_domain s3c64xx_pm_irom = {
-	.name = "IROM",
 	.ena = S3C64XX_NORMALCFG_IROM_ON,
 	.pd = {
+		.name = "IROM",
 		.power_off = s3c64xx_pd_off,
 		.power_on = s3c64xx_pd_on,
 	},
 };
 
 static struct s3c64xx_pm_domain s3c64xx_pm_etm = {
-	.name = "ETM",
 	.ena = S3C64XX_NORMALCFG_DOMAIN_ETM_ON,
 	.pwr_stat = S3C64XX_BLKPWRSTAT_ETM,
 	.pd = {
+		.name = "ETM",
 		.power_off = s3c64xx_pd_off,
 		.power_on = s3c64xx_pd_on,
 	},
 };
 
 static struct s3c64xx_pm_domain s3c64xx_pm_s = {
-	.name = "S",
 	.ena = S3C64XX_NORMALCFG_DOMAIN_S_ON,
 	.pwr_stat = S3C64XX_BLKPWRSTAT_S,
 	.pd = {
+		.name = "S",
 		.power_off = s3c64xx_pd_off,
 		.power_on = s3c64xx_pd_on,
 	},
 };
 
 static struct s3c64xx_pm_domain s3c64xx_pm_f = {
-	.name = "F",
 	.ena = S3C64XX_NORMALCFG_DOMAIN_F_ON,
 	.pwr_stat = S3C64XX_BLKPWRSTAT_F,
 	.pd = {
+		.name = "F",
 		.power_off = s3c64xx_pd_off,
 		.power_on = s3c64xx_pd_on,
 	},
 };
 
 static struct s3c64xx_pm_domain s3c64xx_pm_p = {
-	.name = "P",
 	.ena = S3C64XX_NORMALCFG_DOMAIN_P_ON,
 	.pwr_stat = S3C64XX_BLKPWRSTAT_P,
 	.pd = {
+		.name = "P",
 		.power_off = s3c64xx_pd_off,
 		.power_on = s3c64xx_pd_on,
 	},
 };
 
 static struct s3c64xx_pm_domain s3c64xx_pm_i = {
-	.name = "I",
 	.ena = S3C64XX_NORMALCFG_DOMAIN_I_ON,
 	.pwr_stat = S3C64XX_BLKPWRSTAT_I,
 	.pd = {
+		.name = "I",
 		.power_off = s3c64xx_pd_off,
 		.power_on = s3c64xx_pd_on,
 	},
 };
 
 static struct s3c64xx_pm_domain s3c64xx_pm_g = {
-	.name = "G",
 	.ena = S3C64XX_NORMALCFG_DOMAIN_G_ON,
 	.pd = {
+		.name = "G",
 		.power_off = s3c64xx_pd_off,
 		.power_on = s3c64xx_pd_on,
 	},
 };
 
 static struct s3c64xx_pm_domain s3c64xx_pm_v = {
-	.name = "V",
 	.ena = S3C64XX_NORMALCFG_DOMAIN_V_ON,
 	.pwr_stat = S3C64XX_BLKPWRSTAT_V,
 	.pd = {
+		.name = "V",
 		.power_off = s3c64xx_pd_off,
 		.power_on = s3c64xx_pd_on,
 	},
-- 
1.9.0

