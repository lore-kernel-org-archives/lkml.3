Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299AbaFCWo5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 18:44:57 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:36145 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754439AbaFCWoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 18:44:37 -0400
From: Benson Leung <bleung@chromium.org>
To: gene.chen@intel.com, moch@chromium.org, mika.westerberg@linux.intel.com,
        kirill.shutemov@linux.intel.com, olof@lixom.net,
        linux-kernel@vger.kernel.org
Cc: bleung@chromium.org
Subject: [PATCH 2/3] platform/chrome: chromeos_laptop - Add Dell Chromebook 11 touch
Date: Tue,  3 Jun 2014 15:44:23 -0700
Message-Id: <1401835464-15267-3-git-send-email-bleung@chromium.org>
X-Mailer: git-send-email 1.9.1.423.g4596e3a
In-Reply-To: <1401835464-15267-1-git-send-email-bleung@chromium.org>
References: <1401835464-15267-1-git-send-email-bleung@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mohammed Habibulla <moch@chromium.org>

Add support for Dell Chromebook 11's touch device, which is the same
as falco/peppy on the same bus using the LynxPoint-LP I2C via the
i2c-designware-pci driver.

Based on these patches from the chromeos-3.8 kernel:
https://chromium-review.googlesource.com/#/c/65320/
https://chromium-review.googlesource.com/#/c/174664/

Signed-off-by: Mohammed Habibulla <moch@chromium.org>
Signed-off-by: Benson Leung <bleung@chromium.org>
---
 drivers/platform/chrome/chromeos_laptop.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/platform/chrome/chromeos_laptop.c b/drivers/platform/chrome/chromeos_laptop.c
index 3e113ce..c4d89ae 100644
--- a/drivers/platform/chrome/chromeos_laptop.c
+++ b/drivers/platform/chrome/chromeos_laptop.c
@@ -398,6 +398,13 @@ static struct chromeos_laptop hp_chromebook_14 = {
 	},
 };
 
+static struct chromeos_laptop dell_chromebook_11 = {
+	.i2c_peripherals = {
+		/* Touchpad. */
+		{ .add = setup_cyapa_tp, I2C_ADAPTER_DESIGNWARE_0 },
+	},
+};
+
 static struct chromeos_laptop acer_c7_chromebook = {
 	.i2c_peripherals = {
 		/* Touchpad. */
@@ -463,6 +470,13 @@ static struct dmi_system_id chromeos_laptop_dmi_table[] __initdata = {
 		},
 		_CBDD(chromebook_pixel),
 	},
+		.ident = "Wolf",
+		.matches = {
+			DMI_MATCH(DMI_BIOS_VENDOR, "coreboot"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Wolf"),
+		},
+		_CBDD(dell_chromebook_11),
+	},
 	{
 		.ident = "HP Chromebook 14",
 		.matches = {
-- 
1.9.1.423.g4596e3a

