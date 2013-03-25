Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772Ab3CYG7H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 02:59:07 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:58191 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755616Ab3CYG7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 02:59:05 -0400
Message-ID: <1364194740.27158.1.camel@phoenix>
Subject: [PATCH 2/2] regulator: ab8500: Use regulator_list_voltage_linear
 for fixed voltage
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Mon, 25 Mar 2013 14:59:00 +0800
In-Reply-To: <1364194430.25717.1.camel@phoenix>
References: <1364194430.25717.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Both ab8500_regulator_mode_ops and ab8500_regulator_ops do not have volt_table
setting, thus we can not use regulator_list_voltage_table for them.
However, they have min_uV setting with n_voltages = 1, so use
regulator_list_voltage_linear instead.

Also remove setting set_voltage_time_sel for ab8500_regulator_mode_ops.
It is used only for fixed voltage, so it does not need to implement
set_voltage_time_sel.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/ab8500.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index a2d19c6..12e2740 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -363,8 +363,7 @@ static struct regulator_ops ab8500_regulator_mode_ops = {
 	.set_mode		= ab8500_regulator_set_mode,
 	.get_mode		= ab8500_regulator_get_mode,
 	.get_voltage_sel 	= ab8500_regulator_get_voltage_sel,
-	.list_voltage		= regulator_list_voltage_table,
-	.set_voltage_time_sel	= ab8500_regulator_set_voltage_time_sel,
+	.list_voltage		= regulator_list_voltage_linear,
 };
 
 static struct regulator_ops ab8500_regulator_ops = {
@@ -372,7 +371,7 @@ static struct regulator_ops ab8500_regulator_ops = {
 	.disable		= ab8500_regulator_disable,
 	.is_enabled		= ab8500_regulator_is_enabled,
 	.get_voltage_sel 	= ab8500_regulator_get_voltage_sel,
-	.list_voltage		= regulator_list_voltage_table,
+	.list_voltage		= regulator_list_voltage_linear,
 };
 
 static struct ab8500_regulator_info
-- 
1.7.10.4




