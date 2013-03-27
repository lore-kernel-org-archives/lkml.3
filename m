Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342Ab3C0Jrb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 05:47:31 -0400
Received: from mail-da0-f51.google.com ([209.85.210.51]:35128 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156Ab3C0Jr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 05:47:29 -0400
Message-ID: <1364377642.13084.0.camel@phoenix>
Subject: [PATCH RFT 1/2] regulator: ab8500: Add missing enable_time settings
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Wed, 27 Mar 2013 17:47:22 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Base on the data provide by Bengt Jönsson, add below enable_time settings:

Worst case enable time from data sheet:
Vana: enable time = 140 us
Vaux1/2: enable time = 200 us
Vaux3: enable time = 450 us
Vintcore: enable time = 750 us
Vamic1/2: enable time = 500 us
Vdmic: enable time = 420 us
VTVout: enable time = 500 us
Vaudio: enable time = 140 us
Vusb: enable time = 150 us

This discussion thread is available at: https://lkml.org/lkml/2013/3/26/795

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/ab8500.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 12e2740..1a38524 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -391,6 +391,7 @@ static struct ab8500_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
 			.volt_table	= ldo_vauxn_voltages,
+			.enable_time	= 200,
 		},
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x04,
@@ -412,6 +413,7 @@ static struct ab8500_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
 			.volt_table	= ldo_vauxn_voltages,
+			.enable_time	= 200,
 		},
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x04,
@@ -433,6 +435,7 @@ static struct ab8500_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vaux3_voltages),
 			.volt_table	= ldo_vaux3_voltages,
+			.enable_time	= 450,
 		},
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x04,
@@ -454,6 +457,7 @@ static struct ab8500_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vintcore_voltages),
 			.volt_table	= ldo_vintcore_voltages,
+			.enable_time	= 750,
 		},
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x03,
@@ -506,6 +510,7 @@ static struct ab8500_regulator_info
 			.owner          = THIS_MODULE,
 			.n_voltages     = 1,
 			.min_uV		= 3300000,
+			.enable_time	= 150,
 		},
 		.update_bank            = 0x03,
 		.update_reg             = 0x82,
@@ -520,6 +525,7 @@ static struct ab8500_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 			.min_uV		= 2000000,
+			.enable_time	= 140,
 		},
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
@@ -535,6 +541,7 @@ static struct ab8500_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 			.min_uV		= 2050000,
+			.enable_time	= 500,
 		},
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
@@ -550,6 +557,7 @@ static struct ab8500_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 			.min_uV		= 2050000,
+			.enable_time	= 500,
 		},
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
@@ -565,6 +573,7 @@ static struct ab8500_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 			.min_uV		= 1800000,
+			.enable_time	= 420,
 		},
 		.update_bank		= 0x03,
 		.update_reg		= 0x83,
@@ -584,6 +593,7 @@ static struct ab8500_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 			.min_uV		= 1200000,
+			.enable_time	= 140,
 		},
 		.load_lp_uA		= 1000,
 		.update_bank		= 0x04,
-- 
1.7.10.4



