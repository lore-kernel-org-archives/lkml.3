Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934094Ab3CUQB2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 12:01:28 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:35717 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934063Ab3CUQBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 12:01:23 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        broonie@opensource.wolfsonmicro.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 40/46] regulator: ab8500: Set enable enable_time in regulator_desc
Date: Thu, 21 Mar 2013 15:59:37 +0000
Message-Id: <1363881583-15234-41-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363881583-15234-1-git-send-email-lee.jones@linaro.org>
References: <1363881583-15234-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow the regulator framework to directly access the time it takes
any given regulator to settle. This saves time and code because
without it we would have to implement a dedication function to read
the value from elsewhere.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/regulator/ab8500.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index e6b77a7..324444e 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -1098,6 +1098,7 @@ static struct ab8500_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 			.volt_table	= fixed_2000000_voltage,
+			.enable_time	= 10000,
 		},
 		.delay			= 10000,
 		.load_lp_uA		= 1000,
@@ -1363,6 +1364,7 @@ static struct ab8500_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 			.volt_table	= fixed_2000000_voltage,
+			.enable_time	= 10000,
 		},
 		.delay			= 10000,
 		.load_lp_uA		= 1000,
@@ -1660,6 +1662,7 @@ static struct ab8500_regulator_info
 			.id		= AB8540_LDO_TVOUT,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
+			.enable_time	= 10000,
 		},
 		.delay			= 10000,
 		.load_lp_uA		= 1000,
-- 
1.7.10.4

