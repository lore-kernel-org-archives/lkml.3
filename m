Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab3BVG6g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 01:58:36 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:58210 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087Ab3BVG6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 01:58:32 -0500
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, john.stultz@linaro.org, patches@linaro.org
Subject: [PATCH] ARM: EXYNOS: Keep USB related LDOs always active on Origen
Date: Fri, 22 Feb 2013 12:18:27 +0530
Message-Id: <1361515707-8571-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <51271673.9090003@linaro.org>
References: <51271673.9090003@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LDO3 and LDO8 are used for powering both device and host phy controllers.
These regulators are not handled in USB host driver. Hence we get
unexpected behaviour when the regulators are disabled elsewhere.

It would be best to keep these regulators always on.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---

Based on v3.8.

 arch/arm/mach-exynos/mach-origen.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-exynos/mach-origen.c b/arch/arm/mach-exynos/mach-origen.c
index 5e34b9c..7351063 100644
--- a/arch/arm/mach-exynos/mach-origen.c
+++ b/arch/arm/mach-exynos/mach-origen.c
@@ -169,6 +169,7 @@ static struct regulator_init_data __initdata max8997_ldo3_data = {
 		.min_uV		= 1100000,
 		.max_uV		= 1100000,
 		.apply_uV	= 1,
+		.always_on	= 1,
 		.valid_ops_mask	= REGULATOR_CHANGE_STATUS,
 		.state_mem	= {
 			.disabled	= 1,
@@ -227,6 +228,7 @@ static struct regulator_init_data __initdata max8997_ldo8_data = {
 		.min_uV		= 3300000,
 		.max_uV		= 3300000,
 		.apply_uV	= 1,
+		.always_on	= 1,
 		.valid_ops_mask	= REGULATOR_CHANGE_STATUS,
 		.state_mem	= {
 			.disabled	= 1,
-- 
1.7.4.1

