Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367Ab3GCJRQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 05:17:16 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40751 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038Ab3GCJRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 05:17:14 -0400
From: Mark Brown <broonie@kernel.org>
To: Liam Girdwood <lgirdwood@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Mark Brown <broonie@linaro.org>
Date: Wed,  3 Jul 2013 10:16:32 +0100
Message-Id: <1372842992-18712-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.3.1
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] regulator: ab8500: Provide map_voltage() functions
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

Since all the voltage tables for ab8500 are sorted in ascending order we
can improve performance by using regulator_map_voltage_ascend(). A couple
of the regulators can actually use linear maps which would be even better.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/regulator/ab8500.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 603f192..43cb354 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -651,6 +651,7 @@ static struct regulator_ops ab8500_regulator_volt_mode_ops = {
 	.get_voltage_sel 	= ab8500_regulator_get_voltage_sel,
 	.set_voltage_sel	= ab8500_regulator_set_voltage_sel,
 	.list_voltage		= regulator_list_voltage_table,
+	.map_voltage		= regulator_map_voltage_ascend,
 };
 
 static struct regulator_ops ab8540_aux3_regulator_volt_mode_ops = {
@@ -663,6 +664,7 @@ static struct regulator_ops ab8540_aux3_regulator_volt_mode_ops = {
 	.get_voltage_sel = ab8540_aux3_regulator_get_voltage_sel,
 	.set_voltage_sel = ab8540_aux3_regulator_set_voltage_sel,
 	.list_voltage	= regulator_list_voltage_table,
+	.map_voltage	= regulator_map_voltage_ascend,
 };
 
 static struct regulator_ops ab8500_regulator_volt_ops = {
@@ -672,6 +674,7 @@ static struct regulator_ops ab8500_regulator_volt_ops = {
 	.get_voltage_sel = ab8500_regulator_get_voltage_sel,
 	.set_voltage_sel = ab8500_regulator_set_voltage_sel,
 	.list_voltage	= regulator_list_voltage_table,
+	.map_voltage	= regulator_map_voltage_ascend,
 };
 
 static struct regulator_ops ab8500_regulator_mode_ops = {
@@ -682,6 +685,7 @@ static struct regulator_ops ab8500_regulator_mode_ops = {
 	.set_mode		= ab8500_regulator_set_mode,
 	.get_mode		= ab8500_regulator_get_mode,
 	.list_voltage		= regulator_list_voltage_table,
+	.map_voltage	= regulator_map_voltage_ascend,
 };
 
 static struct regulator_ops ab8500_regulator_ops = {
@@ -689,6 +693,7 @@ static struct regulator_ops ab8500_regulator_ops = {
 	.disable		= ab8500_regulator_disable,
 	.is_enabled		= ab8500_regulator_is_enabled,
 	.list_voltage		= regulator_list_voltage_table,
+	.map_voltage		= regulator_map_voltage_ascend,
 };
 
 static struct regulator_ops ab8500_regulator_anamic_mode_ops = {
@@ -698,6 +703,7 @@ static struct regulator_ops ab8500_regulator_anamic_mode_ops = {
 	.set_mode	= ab8500_regulator_set_mode,
 	.get_mode	= ab8500_regulator_get_mode,
 	.list_voltage	= regulator_list_voltage_table,
+	.map_voltage	= regulator_map_voltage_ascend,
 };
 
 /* AB8500 regulator information */
-- 
1.8.3.1

