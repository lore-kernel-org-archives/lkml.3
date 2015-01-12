Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbbALSbM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:31:12 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58491 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754307AbbALSbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:31:09 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Benson Leung <bleung@chromium.org>, Olof Johansson <olof@lixom.net>,
        Scot Doyle <lkml14@scotdoyle.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 209/216] platform/chrome: chromeos_laptop - Add HP Chromebook 14
Date: Mon, 12 Jan 2015 18:29:47 +0000
Message-Id: <1421087394-2712-97-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benson Leung <bleung@chromium.org>

commit 5ea9567f6126846f5dcfa8515d7ef2c238133c0d upstream.

Add support for the trackpad on HP Chromebook 14.

Signed-off-by: Benson Leung <bleung@chromium.org>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Olof Johansson <olof@lixom.net>
Cc: Scot Doyle <lkml14@scotdoyle.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/platform/chrome/chromeos_laptop.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/platform/chrome/chromeos_laptop.c b/drivers/platform/chrome/chromeos_laptop.c
index a241e5fa6c83..02e014b8927c 100644
--- a/drivers/platform/chrome/chromeos_laptop.c
+++ b/drivers/platform/chrome/chromeos_laptop.c
@@ -380,6 +380,13 @@ static struct chromeos_laptop chromebook_pixel = {
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
@@ -446,6 +453,14 @@ static struct dmi_system_id chromeos_laptop_dmi_table[] __initdata = {
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
2.1.4

