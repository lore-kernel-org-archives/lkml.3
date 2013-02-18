Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557Ab3BRC7K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 21:59:10 -0500
Received: from mail-da0-f41.google.com ([209.85.210.41]:53500 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754653Ab3BRC7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 21:59:09 -0500
Message-ID: <1361156343.24231.2.camel@phoenix>
Subject: [RFT][PATCH 2/2] regulator: ab8500: Use
 regulator_list_voltage_linear for fixed voltage
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Mattias WALLIN <mattias.wallin@stericsson.com>,
        Emeric Vigier <emeric.vigier@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Mon, 18 Feb 2013 10:59:03 +0800
In-Reply-To: <1361156277.24231.1.camel@phoenix>
References: <1361156277.24231.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both ab8500_regulator_mode_ops and ab8500_regulator_ops do not have volt_table
setting, thus we can not use regulator_list_voltage_table for them.
However, they have min_uV setting with n_voltages = 1, so use
regulator_list_voltage_linear instead.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/ab8500.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index ffabff7..24d490e 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -363,7 +363,7 @@ static struct regulator_ops ab8500_regulator_mode_ops = {
 	.set_mode		= ab8500_regulator_set_mode,
 	.get_mode		= ab8500_regulator_get_mode,
 	.get_voltage_sel 	= ab8500_regulator_get_voltage_sel,
-	.list_voltage		= regulator_list_voltage_table,
+	.list_voltage		= regulator_list_voltage_linear,
 	.set_voltage_time_sel 	= ab8500_regulator_set_voltage_time_sel,
 };
 
@@ -372,7 +372,7 @@ static struct regulator_ops ab8500_regulator_ops = {
 	.disable		= ab8500_regulator_disable,
 	.is_enabled		= ab8500_regulator_is_enabled,
 	.get_voltage_sel 	= ab8500_regulator_get_voltage_sel,
-	.list_voltage		= regulator_list_voltage_table,
+	.list_voltage		= regulator_list_voltage_linear,
 };
 
 static struct ab8500_regulator_info
-- 
1.7.9.5



