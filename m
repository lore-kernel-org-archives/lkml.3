Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161942Ab3BOM7n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:59:43 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:54411 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161885Ab3BOM60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:58:26 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Ulf Hansson <ulf.hansson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 32/35] mfd: ab8500-core: Add abx500-clk as an mfd child device
Date: Fri, 15 Feb 2013 12:57:03 +0000
Message-Id: <1360933026-30325-33-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
References: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ulf Hansson <ulf.hansson@stericsson.com>

Hierarchically, the abx500-clk shall be considered as a child of the
ab8500 core. The abx500-clk is intiated at arch init and thus the clks
will be available when clients needs them.

Signed-off-by: Ulf Hansson <ulf.hansson@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Philippe LANGLAIS <philippe.langlais@stericsson.com>
Reviewed-by: Patrice CHOTARD <patrice.chotard@stericsson.com>
Reviewed-by: Gabriel FERNANDEZ <gabriel.fernandez@stericsson.com>
Reviewed-by: Philippe BEGNIC <philippe.begnic@stericsson.com>
---
 drivers/mfd/ab8500-core.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index 153e71e..2716c6c 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -1144,6 +1144,10 @@ static struct mfd_cell ab9540_devs[] = {
 		.name = "ab8500-regulator",
 	},
 	{
+		.name = "abx500-clk",
+		.of_compatible = "stericsson,abx500-clk",
+	},
+	{
 		.name = "ab8500-gpadc",
 		.of_compatible = "stericsson,ab8500-gpadc",
 		.num_resources = ARRAY_SIZE(ab8500_gpadc_resources),
@@ -1210,6 +1214,10 @@ static struct mfd_cell ab8505_devs[] = {
 		.name = "ab8500-regulator",
 	},
 	{
+		.name = "abx500-clk",
+		.of_compatible = "stericsson,abx500-clk",
+	},
+	{
 		.name = "ab8500-gpadc",
 		.num_resources = ARRAY_SIZE(ab8505_gpadc_resources),
 		.resources = ab8505_gpadc_resources,
@@ -1269,6 +1277,10 @@ static struct mfd_cell ab8540_devs[] = {
 		.name = "ab8500-regulator",
 	},
 	{
+		.name = "abx500-clk",
+		.of_compatible = "stericsson,abx500-clk",
+	},
+	{
 		.name = "ab8500-gpadc",
 		.num_resources = ARRAY_SIZE(ab8505_gpadc_resources),
 		.resources = ab8505_gpadc_resources,
-- 
1.7.10.4

