Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094Ab3KRNdQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 08:33:16 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:57644 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab3KRNdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 08:33:10 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH -v2 04/10] mfd: maxim: Constify struct mfd_cell where possible
Date: Mon, 18 Nov 2013 14:33:00 +0100
Message-Id: <1384781586-4798-4-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384781586-4798-1-git-send-email-geert@linux-m68k.org>
References: <1384781586-4798-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As of commit 03e361b25ee8dfb1fd9b890072c23c4aae01c6c7 ("mfd: Stop setting
refcounting pointers in original mfd_cell arrays"), the "cell" parameter of
mfd_add_devices() is "const" again. Hence make all cell data passed to
mfd_add_devices() const where possible.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
v2: Split in groups

 drivers/mfd/max77686.c     |    2 +-
 drivers/mfd/max77693.c     |    2 +-
 drivers/mfd/max8907.c      |    2 +-
 drivers/mfd/max8925-core.c |    8 ++++----
 drivers/mfd/max8997.c      |    2 +-
 drivers/mfd/max8998.c      |    4 ++--
 6 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/mfd/max77686.c b/drivers/mfd/max77686.c
index 34520cbe8afb..fb0848544b76 100644
--- a/drivers/mfd/max77686.c
+++ b/drivers/mfd/max77686.c
@@ -35,7 +35,7 @@
 
 #define I2C_ADDR_RTC	(0x0C >> 1)
 
-static struct mfd_cell max77686_devs[] = {
+static const struct mfd_cell max77686_devs[] = {
 	{ .name = "max77686-pmic", },
 	{ .name = "max77686-rtc", },
 	{ .name = "max77686-clk", },
diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
index 9f92463f4f7e..a0093a839d4b 100644
--- a/drivers/mfd/max77693.c
+++ b/drivers/mfd/max77693.c
@@ -41,7 +41,7 @@
 #define I2C_ADDR_MUIC	(0x4A >> 1)
 #define I2C_ADDR_HAPTIC	(0x90 >> 1)
 
-static struct mfd_cell max77693_devs[] = {
+static const struct mfd_cell max77693_devs[] = {
 	{ .name = "max77693-pmic", },
 	{ .name = "max77693-charger", },
 	{ .name = "max77693-flash", },
diff --git a/drivers/mfd/max8907.c b/drivers/mfd/max8907.c
index 3bbfedc07f41..07740314b29d 100644
--- a/drivers/mfd/max8907.c
+++ b/drivers/mfd/max8907.c
@@ -22,7 +22,7 @@
 #include <linux/regmap.h>
 #include <linux/slab.h>
 
-static struct mfd_cell max8907_cells[] = {
+static const struct mfd_cell max8907_cells[] = {
 	{ .name = "max8907-regulator", },
 	{ .name = "max8907-rtc", },
 };
diff --git a/drivers/mfd/max8925-core.c b/drivers/mfd/max8925-core.c
index f0cc40296d8c..f3faf0c45ddd 100644
--- a/drivers/mfd/max8925-core.c
+++ b/drivers/mfd/max8925-core.c
@@ -45,7 +45,7 @@ static struct resource touch_resources[] = {
 	},
 };
 
-static struct mfd_cell touch_devs[] = {
+static const struct mfd_cell touch_devs[] = {
 	{
 		.name		= "max8925-touch",
 		.num_resources	= 1,
@@ -63,7 +63,7 @@ static struct resource power_supply_resources[] = {
 	},
 };
 
-static struct mfd_cell power_devs[] = {
+static const struct mfd_cell power_devs[] = {
 	{
 		.name		= "max8925-power",
 		.num_resources	= 1,
@@ -81,7 +81,7 @@ static struct resource rtc_resources[] = {
 	},
 };
 
-static struct mfd_cell rtc_devs[] = {
+static const struct mfd_cell rtc_devs[] = {
 	{
 		.name		= "max8925-rtc",
 		.num_resources	= 1,
@@ -104,7 +104,7 @@ static struct resource onkey_resources[] = {
 	},
 };
 
-static struct mfd_cell onkey_devs[] = {
+static const struct mfd_cell onkey_devs[] = {
 	{
 		.name		= "max8925-onkey",
 		.num_resources	= 2,
diff --git a/drivers/mfd/max8997.c b/drivers/mfd/max8997.c
index 791aea3e96ce..1b80e51c2e73 100644
--- a/drivers/mfd/max8997.c
+++ b/drivers/mfd/max8997.c
@@ -40,7 +40,7 @@
 #define I2C_ADDR_RTC	(0x0C >> 1)
 #define I2C_ADDR_HAPTIC	(0x90 >> 1)
 
-static struct mfd_cell max8997_devs[] = {
+static const struct mfd_cell max8997_devs[] = {
 	{ .name = "max8997-pmic", },
 	{ .name = "max8997-rtc", },
 	{ .name = "max8997-battery", },
diff --git a/drivers/mfd/max8998.c b/drivers/mfd/max8998.c
index fe6332dcabee..f47eaa70eae0 100644
--- a/drivers/mfd/max8998.c
+++ b/drivers/mfd/max8998.c
@@ -37,7 +37,7 @@
 
 #define RTC_I2C_ADDR		(0x0c >> 1)
 
-static struct mfd_cell max8998_devs[] = {
+static const struct mfd_cell max8998_devs[] = {
 	{
 		.name = "max8998-pmic",
 	}, {
@@ -47,7 +47,7 @@ static struct mfd_cell max8998_devs[] = {
 	},
 };
 
-static struct mfd_cell lp3974_devs[] = {
+static const struct mfd_cell lp3974_devs[] = {
 	{
 		.name = "lp3974-pmic",
 	}, {
-- 
1.7.9.5

