Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090AbaAKTpz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 14:45:55 -0500
Received: from mail-ea0-f172.google.com ([209.85.215.172]:63050 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759AbaAKTnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 14:43:18 -0500
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
Subject: [PATCH RFC 03/10] ARM: s3c64xx: pm: Add pwr_stat bit for domain G
Date: Sat, 11 Jan 2014 20:42:45 +0100
Message-Id: <1389469372-17199-4-git-send-email-tomasz.figa@gmail.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1389469372-17199-1-git-send-email-tomasz.figa@gmail.com>
References: <1389469372-17199-1-git-send-email-tomasz.figa@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a status bit for domain G present in BLK_PWR_STAT register, but
it is currently not specified in the driver.

This patch adds the status bit of domain G to structure describing it.

Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
---
 arch/arm/mach-s3c64xx/pm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-s3c64xx/pm.c b/arch/arm/mach-s3c64xx/pm.c
index 605bfa9..717d9be 100644
--- a/arch/arm/mach-s3c64xx/pm.c
+++ b/arch/arm/mach-s3c64xx/pm.c
@@ -146,6 +146,7 @@ static struct s3c64xx_pm_domain s3c64xx_pm_i = {
 
 static struct s3c64xx_pm_domain s3c64xx_pm_g = {
 	.ena = S3C64XX_NORMALCFG_DOMAIN_G_ON,
+	.pwr_stat = S3C64XX_BLKPWRSTAT_G,
 	.pd = {
 		.name = "domain_g",
 		.power_off = s3c64xx_pd_off,
-- 
1.8.5.2

