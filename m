Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467AbbALSda (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:33:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58499 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755348AbbALSbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:31:10 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mohammed Habibulla <moch@chromium.org>, Benson Leung <bleung@chromium.org>,
        Olof Johansson <olof@lixom.net>, Scot Doyle <lkml14@scotdoyle.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 210/216] platform/chrome: chromeos_laptop - Add Dell Chromebook 11 touch
Date: Mon, 12 Jan 2015 18:29:48 +0000
Message-Id: <1421087394-2712-98-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mohammed Habibulla <moch@chromium.org>

commit 0e1e5e590a457063c94d55c219b349bcf0d1f93a upstream.

Add support for Dell Chromebook 11's touch device, which is the same
as falco/peppy on the same bus using the LynxPoint-LP I2C via the
i2c-designware-pci driver.

Based on these patches from the chromeos-3.8 kernel:
https://chromium-review.googlesource.com/#/c/65320/
https://chromium-review.googlesource.com/#/c/174664/

Signed-off-by: Mohammed Habibulla <moch@chromium.org>
Signed-off-by: Benson Leung <bleung@chromium.org>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Olof Johansson <olof@lixom.net>
Cc: Scot Doyle <lkml14@scotdoyle.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/platform/chrome/chromeos_laptop.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/platform/chrome/chromeos_laptop.c b/drivers/platform/chrome/chromeos_laptop.c
index 02e014b8927c..e0a671075b28 100644
--- a/drivers/platform/chrome/chromeos_laptop.c
+++ b/drivers/platform/chrome/chromeos_laptop.c
@@ -387,6 +387,13 @@ static struct chromeos_laptop hp_chromebook_14 = {
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
@@ -453,6 +460,14 @@ static struct dmi_system_id chromeos_laptop_dmi_table[] __initdata = {
 		_CBDD(chromebook_pixel),
 	},
 	{
+		.ident = "Wolf",
+		.matches = {
+			DMI_MATCH(DMI_BIOS_VENDOR, "coreboot"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Wolf"),
+		},
+		_CBDD(dell_chromebook_11),
+	},
+	{
 		.ident = "HP Chromebook 14",
 		.matches = {
 			DMI_MATCH(DMI_BIOS_VENDOR, "coreboot"),
-- 
2.1.4

