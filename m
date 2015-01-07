Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254AbbAGVYx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 16:24:53 -0500
Received: from mga11.intel.com ([192.55.52.93]:8722 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754502AbbAGVYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 16:24:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,717,1413270000"; 
   d="scan'208";a="666049831"
Date: Wed, 7 Jan 2015 13:24:50 -0800
From: Todd E Brandt <todd.e.brandt@linux.intel.com>
To: linux-pm@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: jacob.jun.pan@linux.intel.com, sameo@linux.intel.com, lee.jones@linaro.org,
        sre@kernel.org, dbaryshkov@gmail.com, dwmw2@infradead.org,
        david.woodhouse@intel.com, todd.e.brandt@intel.com
Subject: [PATCH 1/3] mfd/axp20x: change battery cell name to fuel gauge
Message-ID: <20150107212450.GB3440@linux.intel.com>
Reply-To: todd.e.brandt@linux.intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mfd/axp20x: change battery cell name to fuel gauge

Name changes to the battery cell structure to a
more generic cell type: fuel gauge.

Signed-off-by: Todd Brandt <todd.e.brandt@intel.com>
----
 drivers/mfd/axp20x.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/axp20x.c b/drivers/mfd/axp20x.c
index b1b580a..e75717e 100644
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
@@ -236,7 +236,7 @@ static const struct i2c_device_id axp20x_i2c_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, axp20x_i2c_id);
 
-static const struct acpi_device_id axp20x_acpi_match[] = {
+static struct acpi_device_id axp20x_acpi_match[] = {
 	{
 		.id = "INT33F4",
 		.driver_data = AXP288_ID,
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
