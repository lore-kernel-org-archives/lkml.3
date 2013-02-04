Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863Ab3BDL7F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 06:59:05 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:37980 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755674Ab3BDL6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:58:10 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 70/73] regulator: ab8500: Set enable enable_time in regulator_desc
Date: Mon,  4 Feb 2013 11:54:25 +0000
Message-Id: <1359978868-28736-71-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
References: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
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
index 6a96618..8ec5c4f 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -1097,6 +1097,7 @@ static struct ab8500_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 			.volt_table	= fixed_2000000_voltage,
+			.enable_time    = 10000,
 		},
 		.delay			= 10000,
 		.load_lp_uA		= 1000,
@@ -1361,6 +1362,7 @@ static struct ab8500_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 			.volt_table	= fixed_2000000_voltage,
+			.enable_time    = 10000,
 		},
 		.delay			= 10000,
 		.load_lp_uA		= 1000,
@@ -1657,6 +1659,7 @@ static struct ab8500_regulator_info
 			.id		= AB8540_LDO_TVOUT,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
+			.enable_time    = 10000,
 		},
 		.delay			= 10000,
 		.load_lp_uA		= 1000,
-- 
1.7.9.5

