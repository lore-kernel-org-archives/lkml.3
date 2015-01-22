Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035AbbAVUwZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 15:52:25 -0500
Received: from mga01.intel.com ([192.55.52.88]:27748 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754130AbbAVUwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 15:52:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,450,1418112000"; 
   d="scan'208";a="516232803"
From: Todd Brandt <todd.e.brandt@linux.intel.com>
To: linux-pm@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: todd.e.brandt@linux.intel.com, todd.e.brandt@intel.com,
        jacob.jun.pan@linux.intel.com, sameo@linux.intel.com,
        lee.jones@linaro.org, sre@kernel.org, dbaryshkov@gmail.com,
        dwmw2@infradead.org, david.woodhouse@intel.com
Subject: [PATCH v2 1/3] mfd/axp20x: change battery cell name to fuel gauge
Date: Thu, 22 Jan 2015 12:52:05 -0800
Message-Id: <b7c6d711c78eb85fc0c7d5904da4e4c930be0ca9.1421957474.git.todd.e.brandt@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1421957474.git.todd.e.brandt@linux.intel.com>
References: <cover.1421957474.git.todd.e.brandt@linux.intel.com>
In-Reply-To: <cover.1421957474.git.todd.e.brandt@linux.intel.com>
References: <cover.1421957474.git.todd.e.brandt@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Name changes to the battery cell structure to a
more generic cell type: fuel gauge.

Signed-off-by: Todd Brandt <todd.e.brandt@linux.intel.com>
---
 drivers/mfd/axp20x.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

v1: 01/07/14
v2: 01/22/14
- replaced the const in axp20x_acpi_match declaration

diff --git a/drivers/mfd/axp20x.c b/drivers/mfd/axp20x.c
index b1b580a..0acbe52 100644
--- a/drivers/mfd/axp20x.c
+++ b/drivers/mfd/axp20x.c
@@ -87,7 +87,7 @@ static struct resource axp20x_pek_resources[] = {
 	},
 };
 
-static struct resource axp288_battery_resources[] = {
+static struct resource axp288_fuel_gauge_resources[] = {
 	{
 		.start = AXP288_IRQ_QWBTU,
 		.end   = AXP288_IRQ_QWBTU,
@@ -350,9 +350,9 @@ static struct mfd_cell axp288_cells[] = {
 		.resources = axp288_charger_resources,
 	},
 	{
-		.name = "axp288_battery",
-		.num_resources = ARRAY_SIZE(axp288_battery_resources),
-		.resources = axp288_battery_resources,
+		.name = "axp288_fuel_gauge",
+		.num_resources = ARRAY_SIZE(axp288_fuel_gauge_resources),
+		.resources = axp288_fuel_gauge_resources,
 	},
 	{
 		.name = "axp288_pmic_acpi",
-- 
2.1.0

