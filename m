Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874AbaAKTqv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 14:46:51 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:42522 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753670AbaAKTnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 14:43:15 -0500
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
        Tomasz Figa <t.figa@samsung.com>, Tomasz Figa <tomasz.figa@gmail.com>
Subject: [PATCH RFC 01/10] ARM: s3c64xx: pm: Use name field of generic_pm_domain
Date: Sat, 11 Jan 2014 20:42:43 +0100
Message-Id: <1389469372-17199-2-git-send-email-tomasz.figa@gmail.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1389469372-17199-1-git-send-email-tomasz.figa@gmail.com>
References: <1389469372-17199-1-git-send-email-tomasz.figa@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes name field from private s3c64xx_pm_domain struct and
moves domain name to dedicated field of generic_pm_domain struct.

When at it, beautify the names a bit, since they are used by genpd core
as message prefixes.

Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
---
 arch/arm/mach-s3c64xx/pm.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/arm/mach-s3c64xx/pm.c b/arch/arm/mach-s3c64xx/pm.c
index 8cdb824..5238d66 100644
--- a/arch/arm/mach-s3c64xx/pm.c
+++ b/arch/arm/mach-s3c64xx/pm.c
@@ -35,7 +35,6 @@
 #include "regs-syscon-power.h"
 
 struct s3c64xx_pm_domain {
-	char *const name;
 	u32 ena;
 	u32 pwr_stat;
 	struct generic_pm_domain pd;
@@ -76,7 +75,7 @@ static int s3c64xx_pd_on(struct generic_pm_domain *domain)
 		} while (retry--);
 
 		if (!retry) {
-			pr_err("Failed to start domain %s\n", pd->name);
+			pr_err("Failed to start domain %s\n", pd->pd.name);
 			return -EBUSY;
 		}
 	}
@@ -85,78 +84,78 @@ static int s3c64xx_pd_on(struct generic_pm_domain *domain)
 }
 
 static struct s3c64xx_pm_domain s3c64xx_pm_irom = {
-	.name = "IROM",
 	.ena = S3C64XX_NORMALCFG_IROM_ON,
 	.pd = {
+		.name = "domain_irom",
 		.power_off = s3c64xx_pd_off,
 		.power_on = s3c64xx_pd_on,
 	},
 };
 
 static struct s3c64xx_pm_domain s3c64xx_pm_etm = {
-	.name = "ETM",
 	.ena = S3C64XX_NORMALCFG_DOMAIN_ETM_ON,
 	.pwr_stat = S3C64XX_BLKPWRSTAT_ETM,
 	.pd = {
+		.name = "domain_etm",
 		.power_off = s3c64xx_pd_off,
 		.power_on = s3c64xx_pd_on,
 	},
 };
 
 static struct s3c64xx_pm_domain s3c64xx_pm_s = {
-	.name = "S",
 	.ena = S3C64XX_NORMALCFG_DOMAIN_S_ON,
 	.pwr_stat = S3C64XX_BLKPWRSTAT_S,
 	.pd = {
+		.name = "domain_s",
 		.power_off = s3c64xx_pd_off,
 		.power_on = s3c64xx_pd_on,
 	},
 };
 
 static struct s3c64xx_pm_domain s3c64xx_pm_f = {
-	.name = "F",
 	.ena = S3C64XX_NORMALCFG_DOMAIN_F_ON,
 	.pwr_stat = S3C64XX_BLKPWRSTAT_F,
 	.pd = {
+		.name = "domain_f",
 		.power_off = s3c64xx_pd_off,
 		.power_on = s3c64xx_pd_on,
 	},
 };
 
 static struct s3c64xx_pm_domain s3c64xx_pm_p = {
-	.name = "P",
 	.ena = S3C64XX_NORMALCFG_DOMAIN_P_ON,
 	.pwr_stat = S3C64XX_BLKPWRSTAT_P,
 	.pd = {
+		.name = "domain_p",
 		.power_off = s3c64xx_pd_off,
 		.power_on = s3c64xx_pd_on,
 	},
 };
 
 static struct s3c64xx_pm_domain s3c64xx_pm_i = {
-	.name = "I",
 	.ena = S3C64XX_NORMALCFG_DOMAIN_I_ON,
 	.pwr_stat = S3C64XX_BLKPWRSTAT_I,
 	.pd = {
+		.name = "domain_i",
 		.power_off = s3c64xx_pd_off,
 		.power_on = s3c64xx_pd_on,
 	},
 };
 
 static struct s3c64xx_pm_domain s3c64xx_pm_g = {
-	.name = "G",
 	.ena = S3C64XX_NORMALCFG_DOMAIN_G_ON,
 	.pd = {
+		.name = "domain_g",
 		.power_off = s3c64xx_pd_off,
 		.power_on = s3c64xx_pd_on,
 	},
 };
 
 static struct s3c64xx_pm_domain s3c64xx_pm_v = {
-	.name = "V",
 	.ena = S3C64XX_NORMALCFG_DOMAIN_V_ON,
 	.pwr_stat = S3C64XX_BLKPWRSTAT_V,
 	.pd = {
+		.name = "domain_v",
 		.power_off = s3c64xx_pd_off,
 		.power_on = s3c64xx_pd_on,
 	},
-- 
1.8.5.2

