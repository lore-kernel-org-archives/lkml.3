Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186Ab3C1QM7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 12:12:59 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:45360 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756982Ab3C1QMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 12:12:49 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 28/33] regulator: ab8500: Set enable enable_time in regulator_desc
Date: Thu, 28 Mar 2013 16:11:28 +0000
Message-Id: <1364487093-19551-29-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364487093-19551-1-git-send-email-lee.jones@linaro.org>
References: <1364487093-19551-1-git-send-email-lee.jones@linaro.org>
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
index 433cac4..8a9cd45 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -1106,6 +1106,7 @@ static struct ab8500_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 			.volt_table	= fixed_2000000_voltage,
+			.enable_time	= 10000,
 		},
 		.delay			= 10000,
 		.load_lp_uA		= 1000,
@@ -1371,6 +1372,7 @@ static struct ab8500_regulator_info
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 			.volt_table	= fixed_2000000_voltage,
+			.enable_time	= 10000,
 		},
 		.delay			= 10000,
 		.load_lp_uA		= 1000,
@@ -1668,6 +1670,7 @@ static struct ab8500_regulator_info
 			.id		= AB8540_LDO_TVOUT,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
+			.enable_time	= 10000,
 		},
 		.delay			= 10000,
 		.load_lp_uA		= 1000,
-- 
1.7.10.4

