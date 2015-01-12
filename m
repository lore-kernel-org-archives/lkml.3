Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373AbbALSce (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:32:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58514 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755279AbbALSbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:31:12 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Gene Chen <gene.chen@intel.com>, Benson Leung <bleung@chromium.org>,
        Olof Johansson <olof@lixom.net>, Scot Doyle <lkml14@scotdoyle.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 211/216] platform/chrome: chromeos_laptop - Add Toshiba CB35 Touch
Date: Mon, 12 Jan 2015 18:29:49 +0000
Message-Id: <1421087394-2712-99-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gene Chen <gene.chen@intel.com>

commit 963cb6fa0f5f115986e970b9d97440e4906524fa upstream.

Add support for Leon touch devices, which is the same as
falco/peppy/wolf on the same buses using the LynxPoint-LP I2C
via the i2c-designware-pci driver.

Based on these patches from the chromeos-3.8 kernel:
https://chromium-review.googlesource.com/168351
https://chromium-review.googlesource.com/173445

Signed-off-by: Gene Chen <gene.chen@intel.com>
Signed-off-by: Benson Leung <bleung@chromium.org>
Tested-by: Scot Doyle <lkml14@scotdoyle.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Olof Johansson <olof@lixom.net>
Cc: Scot Doyle <lkml14@scotdoyle.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/platform/chrome/chromeos_laptop.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/platform/chrome/chromeos_laptop.c b/drivers/platform/chrome/chromeos_laptop.c
index e0a671075b28..37fa570a7636 100644
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
2.1.4

