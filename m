Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965343AbaFQV1o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:27:44 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:49757 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932940AbaFQV1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:27:43 -0400
From: Benson Leung <bleung@chromium.org>
To: gene.chen@intel.com, moch@chromium.org, mika.westerberg@linux.intel.com,
        lkml14@scotdoyle.com, kirill.shutemov@linux.intel.com, olof@lixom.net,
        linux-kernel@vger.kernel.org
Cc: bleung@chromium.org
Subject: [PATCHv2 4/4] platform/chrome: chromeos_laptop - Add Toshiba CB35 Touch
Date: Tue, 17 Jun 2014 14:02:03 -0700
Message-Id: <1403038923-19444-5-git-send-email-bleung@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
In-Reply-To: <1403038923-19444-1-git-send-email-bleung@chromium.org>
References: <1401835464-15267-1-git-send-email-bleung@chromium.org>
 <1403038923-19444-1-git-send-email-bleung@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gene Chen <gene.chen@intel.com>

Add support for Leon touch devices, which is the same as
falco/peppy/wolf on the same buses using the LynxPoint-LP I2C
via the i2c-designware-pci driver.

Based on these patches from the chromeos-3.8 kernel:
https://chromium-review.googlesource.com/168351
https://chromium-review.googlesource.com/173445

Signed-off-by: Gene Chen <gene.chen@intel.com>
Signed-off-by: Benson Leung <bleung@chromium.org>
Tested-by: Scot Doyle <lkml14@scotdoyle.com>
---
 drivers/platform/chrome/chromeos_laptop.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/platform/chrome/chromeos_laptop.c b/drivers/platform/chrome/chromeos_laptop.c
index e0a6710..37fa570 100644
--- a/drivers/platform/chrome/chromeos_laptop.c
+++ b/drivers/platform/chrome/chromeos_laptop.c
@@ -394,6 +394,13 @@ static struct chromeos_laptop dell_chromebook_11 = {
 	},
 };
 
+static struct chromeos_laptop toshiba_cb35 = {
+	.i2c_peripherals = {
+		/* Touchpad. */
+		{ .add = setup_cyapa_tp, I2C_ADAPTER_DESIGNWARE_0 },
+	},
+};
+
 static struct chromeos_laptop acer_c7_chromebook = {
 	.i2c_peripherals = {
 		/* Touchpad. */
@@ -476,6 +483,14 @@ static struct dmi_system_id chromeos_laptop_dmi_table[] __initdata = {
 		_CBDD(hp_chromebook_14),
 	},
 	{
+		.ident = "Toshiba CB35",
+		.matches = {
+			DMI_MATCH(DMI_BIOS_VENDOR, "coreboot"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Leon"),
+		},
+		_CBDD(toshiba_cb35),
+	},
+	{
 		.ident = "Acer C7 Chromebook",
 		.matches = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Parrot"),
-- 
2.0.0.526.g5318336

