Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933928Ab3DGPR5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 11:17:57 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:51476 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932651Ab3DGPR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 11:17:56 -0400
Message-ID: <1365347870.9931.7.camel@phoenix>
Subject: [PATCH 4/4] regulator: ab8500-ext: Remove get_voltage to avoid
 duplicate implementation
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Sun, 07 Apr 2013 23:17:50 +0800
In-Reply-To: <1365347548.9931.1.camel@phoenix>
References: <1365347548.9931.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The implementation of ab8500_ext_fixed_get_voltage is identical to
ab8500_ext_list_voltage. We can avoid the duplicate implementation by just
remove get_voltage. For fixed regulator, regulator core will call
list_voltage(rdev, 0) to get voltage if both get_voltage get_voltage_sel are
not implemented.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/ab8500-ext.c |   16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/drivers/regulator/ab8500-ext.c b/drivers/regulator/ab8500-ext.c
index c7896af..9aee21c 100644
--- a/drivers/regulator/ab8500-ext.c
+++ b/drivers/regulator/ab8500-ext.c
@@ -237,21 +237,6 @@ static unsigned int ab8500_ext_regulator_get_mode(struct regulator_dev *rdev)
 	return ret;
 }
 
-static int ab8500_ext_fixed_get_voltage(struct regulator_dev *rdev)
-{
-	struct regulation_constraints *regu_constraints = rdev->constraints;
-
-	if (regu_constraints == NULL) {
-		dev_err(rdev_get_dev(rdev), "regulator constraints null pointer\n");
-		return -EINVAL;
-	}
-	if (regu_constraints->min_uV && regu_constraints->max_uV) {
-		if (regu_constraints->min_uV == regu_constraints->max_uV)
-			return regu_constraints->min_uV;
-	}
-	return -EINVAL;
-}
-
 static int ab8500_ext_list_voltage(struct regulator_dev *rdev,
 				   unsigned selector)
 {
@@ -275,7 +260,6 @@ static struct regulator_ops ab8500_ext_regulator_ops = {
 	.is_enabled		= ab8500_ext_regulator_is_enabled,
 	.set_mode		= ab8500_ext_regulator_set_mode,
 	.get_mode		= ab8500_ext_regulator_get_mode,
-	.get_voltage		= ab8500_ext_fixed_get_voltage,
 	.list_voltage		= ab8500_ext_list_voltage,
 };
 
-- 
1.7.10.4



