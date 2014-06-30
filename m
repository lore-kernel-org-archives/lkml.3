Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096AbaF3P5z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 11:57:55 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:35799 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755074AbaF3P5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 11:57:47 -0400
From: Nishanth Menon <nm@ti.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Keerthy J <j-keerthy@ti.com>
CC: Tero Kristo <t-kristo@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH V2 1/6] regulator: palmas: Squelch sparse warnings
Date: Mon, 30 Jun 2014 10:57:34 -0500
Message-ID: <1404143859-8160-2-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404143859-8160-1-git-send-email-nm@ti.com>
References: <1404143859-8160-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

convert to static variables to squelch the following sparse warnings:
drivers/regulator/palmas-regulator.c:325:36: warning: symbol 'palma_sleep_req_info' was not declared. Should it be static?
drivers/regulator/palmas-regulator.c:1414:32: warning: symbol 'palmas_ddata' was not declared. Should it be static?
drivers/regulator/palmas-regulator.c:1427:32: warning: symbol 'tps65917_ddata' was not declared. Should it be static?

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 drivers/regulator/palmas-regulator.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index 7c8b441..91f60fa 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -322,7 +322,7 @@ static struct regs_info tps65917_regs_info[] = {
 		.bit_pos = _pos,			\
 	}
 
-struct palmas_sleep_requestor_info palma_sleep_req_info[] = {
+static struct palmas_sleep_requestor_info palma_sleep_req_info[] = {
 	EXTERNAL_REQUESTOR(REGEN1, 0, 0),
 	EXTERNAL_REQUESTOR(REGEN2, 0, 1),
 	EXTERNAL_REQUESTOR(SYSEN1, 0, 2),
@@ -1408,7 +1408,7 @@ static struct of_regulator_match tps65917_matches[] = {
 	{ .name = "sysen2", },
 };
 
-struct palmas_pmic_driver_data palmas_ddata = {
+static struct palmas_pmic_driver_data palmas_ddata = {
 	.smps_start = PALMAS_REG_SMPS12,
 	.smps_end = PALMAS_REG_SMPS10_OUT1,
 	.ldo_begin = PALMAS_REG_LDO1,
@@ -1421,7 +1421,7 @@ struct palmas_pmic_driver_data palmas_ddata = {
 	.ldo_register = palmas_ldo_registration,
 };
 
-struct palmas_pmic_driver_data tps65917_ddata = {
+static struct palmas_pmic_driver_data tps65917_ddata = {
 	.smps_start = TPS65917_REG_SMPS1,
 	.smps_end = TPS65917_REG_SMPS5,
 	.ldo_begin = TPS65917_REG_LDO1,
-- 
1.7.9.5

