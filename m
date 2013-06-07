Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741Ab3FGQMK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 12:12:10 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:44418 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756688Ab3FGQMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 12:12:05 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, broonie@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 10/10] regulator: ab8500: Provide supply names for the AUX regulators
Date: Fri,  7 Jun 2013 17:11:28 +0100
Message-Id: <1370621488-18130-11-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370621488-18130-1-git-send-email-lee.jones@linaro.org>
References: <1370621488-18130-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some platforms the AUX[1|2|3] regulators are supplied voltage by
a separate regulator. For example on Snowball these are provided by
the EXT3. If we list them here, we can supply voltage to them by
simply listing them in as a consumer of EXT3 in the Snowball case.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/regulator/ab8500.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index aea9fdae..603f192 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -719,6 +719,7 @@ static struct ab8500_regulator_info
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
 			.volt_table	= ldo_vauxn_voltages,
 			.enable_time	= 200,
+			.supply_name    = "vin",
 		},
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x04,
@@ -741,6 +742,7 @@ static struct ab8500_regulator_info
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
 			.volt_table	= ldo_vauxn_voltages,
 			.enable_time	= 200,
+			.supply_name    = "vin",
 		},
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x04,
@@ -763,6 +765,7 @@ static struct ab8500_regulator_info
 			.n_voltages	= ARRAY_SIZE(ldo_vaux3_voltages),
 			.volt_table	= ldo_vaux3_voltages,
 			.enable_time	= 450,
+			.supply_name    = "vin",
 		},
 		.load_lp_uA		= 5000,
 		.update_bank		= 0x04,
-- 
1.7.10.4

