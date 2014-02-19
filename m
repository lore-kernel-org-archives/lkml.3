Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634AbaBSQhV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 11:37:21 -0500
Received: from mail1.bemta5.messagelabs.com ([195.245.231.149]:48966 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754121AbaBSQhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 11:37:13 -0500
X-Env-Sender: anthony.olech.opensource@diasemi.com
X-Msg-Ref: server-8.tower-178.messagelabs.com!1392827831!24257303!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <201402191637.s1JGb45N017694@swsrvapps-02.lan>
From: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
Date: Wed, 19 Feb 2014 16:32:47 +0000
Subject: [PATCH V1 2/3] MFD: da9052: Add new DA9053 BC chip variant
To: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
CC: Liam Girdwood <lgirdwood@gmail.com>, <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for a new BC variant of the DA9053 PMIC.

There is one difference between it and the AA, BA and BB.

This patch also corrects a typing mistake in one of the BA
name strings that was incorrectly typed as "ab".

Signed-off-by: Anthony Olech <anthony.olech.opensource@diasemi.com>
---

This patch is relative to linux-next repository tag next-20140219

This patch depends on patch number 1 of this patch
series being applied first or it will not compile.

 drivers/mfd/da9052-i2c.c |    5 ++++-
 drivers/mfd/da9052-spi.c |    1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/da9052-i2c.c b/drivers/mfd/da9052-i2c.c
index c319c4e..6da8ec8 100644
--- a/drivers/mfd/da9052-i2c.c
+++ b/drivers/mfd/da9052-i2c.c
@@ -75,6 +75,7 @@ static int da9052_i2c_fix(struct da9052 *da9052, unsigned char reg)
 					   DA9052_PARK_REGISTER,
 					   &val);
 		break;
+	case DA9053_BC:
 	default:
 		/*
 		 * For other chips parking of I2C register
@@ -114,6 +115,7 @@ static const struct i2c_device_id da9052_i2c_id[] = {
 	{"da9053-aa", DA9053_AA},
 	{"da9053-ba", DA9053_BA},
 	{"da9053-bb", DA9053_BB},
+	{"da9053-bc", DA9053_BC},
 	{}
 };
 
@@ -121,8 +123,9 @@ static const struct i2c_device_id da9052_i2c_id[] = {
 static const struct of_device_id dialog_dt_ids[] = {
 	{ .compatible = "dlg,da9052", .data = &da9052_i2c_id[0] },
 	{ .compatible = "dlg,da9053-aa", .data = &da9052_i2c_id[1] },
-	{ .compatible = "dlg,da9053-ab", .data = &da9052_i2c_id[2] },
+	{ .compatible = "dlg,da9053-ba", .data = &da9052_i2c_id[2] },
 	{ .compatible = "dlg,da9053-bb", .data = &da9052_i2c_id[3] },
+	{ .compatible = "dlg,da9053-bc", .data = &da9052_i2c_id[4] },
 	{ /* sentinel */ }
 };
 #endif
diff --git a/drivers/mfd/da9052-spi.c b/drivers/mfd/da9052-spi.c
index 0680bcb..17666b4 100644
--- a/drivers/mfd/da9052-spi.c
+++ b/drivers/mfd/da9052-spi.c
@@ -71,6 +71,7 @@ static struct spi_device_id da9052_spi_id[] = {
 	{"da9053-aa", DA9053_AA},
 	{"da9053-ba", DA9053_BA},
 	{"da9053-bb", DA9053_BB},
+	{"da9053-bc", DA9053_BC},
 	{}
 };
 
-- 
end-of-patch 2/3 for PATCH V1

