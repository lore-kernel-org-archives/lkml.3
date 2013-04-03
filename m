Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760815Ab3DCCc2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 22:32:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40931 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759306Ab3DCCc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 22:32:27 -0400
Message-ID: <1364956341.1328.3.camel@phoenix>
Subject: [PATCH 2/4] regulator: ab8500: Remove voltages and voltages_len to
 fix build error
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Wed, 03 Apr 2013 10:32:21 +0800
In-Reply-To: <1364956243.1328.1.camel@phoenix>
References: <1364956243.1328.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both voltages and voltages_len are not exist in struct ab8500_regulator_info.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/ab8500.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index abdfbd4..bdd17e6 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -1124,8 +1124,6 @@ static struct ab8500_regulator_info
 		.voltage_reg		= 0x57,
 		.voltage_mask		= 0x7,
 		.voltage_shift		= 4,
-		.voltages		= ldo_vaudio_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vaudio_voltages),
 	},
 	[AB8505_LDO_ANAMIC1] = {
 		.desc = {
@@ -1207,8 +1205,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x04,
 		.voltage_reg		= 0x29,
 		.voltage_mask		= 0x7,
-		.voltages		= ldo_vana_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vana_voltages),
 	},
 };
 
@@ -1666,6 +1662,7 @@ static struct ab8500_regulator_info
 			.id		= AB8540_LDO_DMIC,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vdmic_voltages),
+			.volt_table	= ldo_vdmic_voltages,
 		},
 		.load_lp_uA		= 1000,
 		.update_bank		= 0x03,
@@ -1675,8 +1672,6 @@ static struct ab8500_regulator_info
 		.voltage_bank		= 0x03,
 		.voltage_reg		= 0x83,
 		.voltage_mask		= 0xc0,
-		.voltages		= ldo_vdmic_voltages,
-		.voltages_len		= ARRAY_SIZE(ldo_vdmic_voltages),
 	},
 
 	/*
-- 
1.7.10.4



