Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636Ab3BRDYw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 22:24:52 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:37993 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754439Ab3BRDYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 22:24:51 -0500
Message-ID: <1361157880.30510.1.camel@phoenix>
Subject: [RFT][PATCH] regulator: ab8500: Remove get_voltage_sel for fixed
 voltage
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Emeric Vigier <emeric.vigier@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Mon, 18 Feb 2013 11:24:40 +0800
In-Reply-To: <1361156277.24231.1.camel@phoenix>
References: <1361156277.24231.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code sets get_voltage_sel to ab8500_regulator_get_voltage_sel,
however both ab8500_regulator_mode_ops and ab8500_regulator_ops do not
have voltage_bank, voltage_reg and voltage_mask settings.
So it looks wrong to use ab8500_regulator_get_voltage_sel as
get_voltage_sel callback in these cases.

A simple fix is just not implement get_voltage_sel, regulator core will
report microvolts in sysfs even with only list_voltage().

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
Just found this needs to be fixed after I sent previous ab8500 patches,
this patch is on top of previous ab8500 fixes.

Axel
 drivers/regulator/ab8500.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 24d490e..67b4412 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -362,7 +362,6 @@ static struct regulator_ops ab8500_regulator_mode_ops = {
 	.get_optimum_mode	= ab8500_regulator_get_optimum_mode,
 	.set_mode		= ab8500_regulator_set_mode,
 	.get_mode		= ab8500_regulator_get_mode,
-	.get_voltage_sel 	= ab8500_regulator_get_voltage_sel,
 	.list_voltage		= regulator_list_voltage_linear,
 	.set_voltage_time_sel 	= ab8500_regulator_set_voltage_time_sel,
 };
@@ -371,7 +370,6 @@ static struct regulator_ops ab8500_regulator_ops = {
 	.enable			= ab8500_regulator_enable,
 	.disable		= ab8500_regulator_disable,
 	.is_enabled		= ab8500_regulator_is_enabled,
-	.get_voltage_sel 	= ab8500_regulator_get_voltage_sel,
 	.list_voltage		= regulator_list_voltage_linear,
 };
 
-- 
1.7.9.5



