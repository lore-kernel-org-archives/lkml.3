Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869Ab3KRNdZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 08:33:25 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:57642 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000Ab3KRNdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 08:33:10 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH -v2 01/10] mfd: dialog: Constify struct mfd_cell where possible
Date: Mon, 18 Nov 2013 14:32:57 +0100
Message-Id: <1384781586-4798-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
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

 drivers/mfd/da9052-core.c |    2 +-
 drivers/mfd/da9055-core.c |    2 +-
 drivers/mfd/da9063-core.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/da9052-core.c b/drivers/mfd/da9052-core.c
index ea28a33576e4..25838f10b35b 100644
--- a/drivers/mfd/da9052-core.c
+++ b/drivers/mfd/da9052-core.c
@@ -427,7 +427,7 @@ int da9052_adc_read_temp(struct da9052 *da9052)
 }
 EXPORT_SYMBOL_GPL(da9052_adc_read_temp);
 
-static struct mfd_cell da9052_subdev_info[] = {
+static const struct mfd_cell da9052_subdev_info[] = {
 	{
 		.name = "da9052-regulator",
 		.id = 1,
diff --git a/drivers/mfd/da9055-core.c b/drivers/mfd/da9055-core.c
index d3670cd3c3c6..caf8dcffd0ad 100644
--- a/drivers/mfd/da9055-core.c
+++ b/drivers/mfd/da9055-core.c
@@ -294,7 +294,7 @@ static struct resource da9055_ld05_6_resource = {
 	.flags = IORESOURCE_IRQ,
 };
 
-static struct mfd_cell da9055_devs[] = {
+static const struct mfd_cell da9055_devs[] = {
 	{
 		.of_compatible = "dialog,da9055-gpio",
 		.name = "da9055-gpio",
diff --git a/drivers/mfd/da9063-core.c b/drivers/mfd/da9063-core.c
index c9cf8d988406..26937cd01071 100644
--- a/drivers/mfd/da9063-core.c
+++ b/drivers/mfd/da9063-core.c
@@ -75,7 +75,7 @@ static struct resource da9063_hwmon_resources[] = {
 };
 
 
-static struct mfd_cell da9063_devs[] = {
+static const struct mfd_cell da9063_devs[] = {
 	{
 		.name		= DA9063_DRVNAME_REGULATORS,
 		.num_resources	= ARRAY_SIZE(da9063_regulators_resources),
-- 
1.7.9.5

