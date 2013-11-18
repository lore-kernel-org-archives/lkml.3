Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464Ab3KRNeP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 08:34:15 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:57685 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016Ab3KRNdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 08:33:10 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH -v2 08/10] mfd: wolfson: Constify struct mfd_cell where possible
Date: Mon, 18 Nov 2013 14:33:04 +0100
Message-Id: <1384781586-4798-8-git-send-email-geert@linux-m68k.org>
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

 drivers/mfd/wm831x-core.c |   14 +++++++-------
 drivers/mfd/wm8994-core.c |    4 ++--
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/mfd/wm831x-core.c b/drivers/mfd/wm831x-core.c
index 5c459f469224..28366a90e1ad 100644
--- a/drivers/mfd/wm831x-core.c
+++ b/drivers/mfd/wm831x-core.c
@@ -1011,7 +1011,7 @@ static struct resource wm831x_wdt_resources[] = {
 	},
 };
 
-static struct mfd_cell wm8310_devs[] = {
+static const struct mfd_cell wm8310_devs[] = {
 	{
 		.name = "wm831x-backup",
 	},
@@ -1165,7 +1165,7 @@ static struct mfd_cell wm8310_devs[] = {
 	},
 };
 
-static struct mfd_cell wm8311_devs[] = {
+static const struct mfd_cell wm8311_devs[] = {
 	{
 		.name = "wm831x-backup",
 	},
@@ -1295,7 +1295,7 @@ static struct mfd_cell wm8311_devs[] = {
 	},
 };
 
-static struct mfd_cell wm8312_devs[] = {
+static const struct mfd_cell wm8312_devs[] = {
 	{
 		.name = "wm831x-backup",
 	},
@@ -1449,7 +1449,7 @@ static struct mfd_cell wm8312_devs[] = {
 	},
 };
 
-static struct mfd_cell wm8320_devs[] = {
+static const struct mfd_cell wm8320_devs[] = {
 	{
 		.name = "wm831x-backup",
 	},
@@ -1578,7 +1578,7 @@ static struct mfd_cell wm8320_devs[] = {
 	},
 };
 
-static struct mfd_cell touch_devs[] = {
+static const struct mfd_cell touch_devs[] = {
 	{
 		.name = "wm831x-touch",
 		.num_resources = ARRAY_SIZE(wm831x_touch_resources),
@@ -1586,7 +1586,7 @@ static struct mfd_cell touch_devs[] = {
 	},
 };
 
-static struct mfd_cell rtc_devs[] = {
+static const struct mfd_cell rtc_devs[] = {
 	{
 		.name = "wm831x-rtc",
 		.num_resources = ARRAY_SIZE(wm831x_rtc_resources),
@@ -1594,7 +1594,7 @@ static struct mfd_cell rtc_devs[] = {
 	},
 };
 
-static struct mfd_cell backlight_devs[] = {
+static const struct mfd_cell backlight_devs[] = {
 	{
 		.name = "wm831x-backlight",
 	},
diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index 030827511667..ba04f1bc70eb 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -33,7 +33,7 @@
 
 #include "wm8994.h"
 
-static struct mfd_cell wm8994_regulator_devs[] = {
+static const struct mfd_cell wm8994_regulator_devs[] = {
 	{
 		.name = "wm8994-ldo",
 		.id = 1,
@@ -62,7 +62,7 @@ static struct resource wm8994_gpio_resources[] = {
 	},
 };
 
-static struct mfd_cell wm8994_devs[] = {
+static const struct mfd_cell wm8994_devs[] = {
 	{
 		.name = "wm8994-codec",
 		.num_resources = ARRAY_SIZE(wm8994_codec_resources),
-- 
1.7.9.5

