Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178AbaF3P7S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 11:59:18 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:36563 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755185AbaF3P5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 11:57:49 -0400
From: Nishanth Menon <nm@ti.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Keerthy J <j-keerthy@ti.com>
CC: Tero Kristo <t-kristo@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH V2 2/6] regulator: palmas: Rename reg_info to palmas_reg_info
Date: Mon, 30 Jun 2014 10:57:35 -0500
Message-ID: <1404143859-8160-3-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404143859-8160-1-git-send-email-nm@ti.com>
References: <1404143859-8160-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reg_info is a generic term which might cause conflict at a later point
in time. To prevent such a thing from occuring in future, rename to
palmas_reg_info.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 drivers/regulator/palmas-regulator.c |    4 ++--
 include/linux/mfd/palmas.h           |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index 91f60fa..05f11b9 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -41,7 +41,7 @@ static const struct regulator_linear_range smps_high_ranges[] = {
 	REGULATOR_LINEAR_RANGE(3300000, 0x7A, 0x7f, 0),
 };
 
-static struct regs_info palmas_regs_info[] = {
+static struct palmas_regs_info palmas_regs_info[] = {
 	{
 		.name		= "SMPS12",
 		.sname		= "smps1-in",
@@ -227,7 +227,7 @@ static struct regs_info palmas_regs_info[] = {
 	},
 };
 
-static struct regs_info tps65917_regs_info[] = {
+static struct palmas_regs_info tps65917_regs_info[] = {
 	{
 		.name		= "SMPS1",
 		.sname		= "smps1-in",
diff --git a/include/linux/mfd/palmas.h b/include/linux/mfd/palmas.h
index 1a045ba..fb0390a 100644
--- a/include/linux/mfd/palmas.h
+++ b/include/linux/mfd/palmas.h
@@ -102,7 +102,7 @@ struct palmas_sleep_requestor_info {
 	int bit_pos;
 };
 
-struct regs_info {
+struct palmas_regs_info {
 	char	*name;
 	char	*sname;
 	u8	vsel_addr;
@@ -117,7 +117,7 @@ struct palmas_pmic_driver_data {
 	int ldo_begin;
 	int ldo_end;
 	int max_reg;
-	struct regs_info *palmas_regs_info;
+	struct palmas_regs_info *palmas_regs_info;
 	struct of_regulator_match *palmas_matches;
 	struct palmas_sleep_requestor_info *sleep_req_info;
 	int (*smps_register)(struct palmas_pmic *pmic,
-- 
1.7.9.5

