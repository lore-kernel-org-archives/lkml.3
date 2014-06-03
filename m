Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062AbaFCWoh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 18:44:37 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:58255 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311AbaFCWof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 18:44:35 -0400
From: Benson Leung <bleung@chromium.org>
To: gene.chen@intel.com, moch@chromium.org, mika.westerberg@linux.intel.com,
        kirill.shutemov@linux.intel.com, olof@lixom.net,
        linux-kernel@vger.kernel.org
Cc: bleung@chromium.org
Subject: [PATCH 1/3] platform/chrome: chromeos_laptop - Add HP Chromebook 14
Date: Tue,  3 Jun 2014 15:44:22 -0700
Message-Id: <1401835464-15267-2-git-send-email-bleung@chromium.org>
X-Mailer: git-send-email 1.9.1.423.g4596e3a
In-Reply-To: <1401835464-15267-1-git-send-email-bleung@chromium.org>
References: <1401835464-15267-1-git-send-email-bleung@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the trackpad on HP Chromebook 14.

Signed-off-by: Benson Leung <bleung@chromium.org>
---
 drivers/platform/chrome/chromeos_laptop.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/platform/chrome/chromeos_laptop.c b/drivers/platform/chrome/chromeos_laptop.c
index 44806c5..3e113ce 100644
--- a/drivers/platform/chrome/chromeos_laptop.c
+++ b/drivers/platform/chrome/chromeos_laptop.c
@@ -391,6 +391,13 @@ static struct chromeos_laptop chromebook_pixel = {
 	},
 };
 
+static struct chromeos_laptop hp_chromebook_14 = {
+	.i2c_peripherals = {
+		/* Touchpad. */
+		{ .add = setup_cyapa_tp, I2C_ADAPTER_DESIGNWARE_0 },
+	},
+};
+
 static struct chromeos_laptop acer_c7_chromebook = {
 	.i2c_peripherals = {
 		/* Touchpad. */
@@ -457,6 +464,14 @@ static struct dmi_system_id chromeos_laptop_dmi_table[] __initdata = {
 		_CBDD(chromebook_pixel),
 	},
 	{
+		.ident = "HP Chromebook 14",
+		.matches = {
+			DMI_MATCH(DMI_BIOS_VENDOR, "coreboot"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Falco"),
+		},
+		_CBDD(hp_chromebook_14),
+	},
+	{
 		.ident = "Acer C7 Chromebook",
 		.matches = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Parrot"),
-- 
1.9.1.423.g4596e3a

