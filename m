Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760555Ab3DBGdA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 02:33:00 -0400
Received: from mail-da0-f53.google.com ([209.85.210.53]:39146 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759544Ab3DBGc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 02:32:58 -0400
Message-ID: <1364884370.12936.0.camel@phoenix>
Subject: [RFT][PATCH 1/2] regulator: ab8500: Fix list_voltage for fixed
 voltage regulators
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Tue, 02 Apr 2013 14:32:50 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit b080c78a4e447e9c212c207f725999d4e32c5f19
"regulator: ab8500: Update voltage handling for fixed voltage regulators"
remove min_uV settings and set volt_table for all fixed voltage, thus we can not
use regulator_list_voltage_linear now. Use regulator_list_voltage_table instead.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/ab8500.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 09eea32..5fd764e 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -423,14 +423,14 @@ static struct regulator_ops ab8500_regulator_mode_ops = {
 	.get_optimum_mode	= ab8500_regulator_get_optimum_mode,
 	.set_mode		= ab8500_regulator_set_mode,
 	.get_mode		= ab8500_regulator_get_mode,
-	.list_voltage		= regulator_list_voltage_linear,
+	.list_voltage		= regulator_list_voltage_table,
 };
 
 static struct regulator_ops ab8500_regulator_ops = {
 	.enable			= ab8500_regulator_enable,
 	.disable		= ab8500_regulator_disable,
 	.is_enabled		= ab8500_regulator_is_enabled,
-	.list_voltage		= regulator_list_voltage_linear,
+	.list_voltage		= regulator_list_voltage_table,
 };
 
 /* AB8500 regulator information */
-- 
1.7.10.4



