Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965930AbaFQQ5K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:57:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50558 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933931AbaFQQSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:18:48 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 032/121] Input: synaptics - add min/max quirk for ThinkPad T431s, L440, L540, S1 Yoga and X1
Date: Tue, 17 Jun 2014 09:16:50 -0700
Message-Id: <1403021899-16708-5-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403021899-16708-2-git-send-email-kamal@canonical.com>
References: <1403021899-16708-2-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.24 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 46a2986ebbe18757c2d8c352f8fb6e0f4f0754e3 upstream.

We expect that all the Haswell series will need such quirks, sigh.

The T431s seems to be T430 hardware in a T440s case, using the T440s touchpad,
with the same min/max issue.

The X1 Carbon 3rd generation name says 2nd while it is a 3rd generation.

The X1 and T431s share a PnPID with the T540p, but the reported ranges are
closer to those of the T440s.

HdG: Squashed 5 quirk patches into one. T431s + L440 + L540 are written by me,
S1 Yoga and X1 are written by Benjamin Tissoires.

Hdg: Standardized S1 Yoga and X1 values, Yoga uses the same touchpad as the
X240, X1 uses the same touchpad as the T440.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/input/mouse/synaptics.c | 42 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 1f683f8..a34e035 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -1489,6 +1489,14 @@ static const struct dmi_system_id min_max_dmi_table[] __initconst = {
 		.driver_data = (int []){1232, 5710, 1156, 4696},
 	},
 	{
+		/* Lenovo ThinkPad T431s */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad T431"),
+		},
+		.driver_data = (int []){1024, 5112, 2024, 4832},
+	},
+	{
 		/* Lenovo ThinkPad T440s */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
@@ -1497,6 +1505,14 @@ static const struct dmi_system_id min_max_dmi_table[] __initconst = {
 		.driver_data = (int []){1024, 5112, 2024, 4832},
 	},
 	{
+		/* Lenovo ThinkPad L440 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad L440"),
+		},
+		.driver_data = (int []){1024, 5112, 2024, 4832},
+	},
+	{
 		/* Lenovo ThinkPad T540p */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
@@ -1504,6 +1520,32 @@ static const struct dmi_system_id min_max_dmi_table[] __initconst = {
 		},
 		.driver_data = (int []){1024, 5056, 2058, 4832},
 	},
+	{
+		/* Lenovo ThinkPad L540 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad L540"),
+		},
+		.driver_data = (int []){1024, 5112, 2024, 4832},
+	},
+	{
+		/* Lenovo Yoga S1 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_VERSION,
+					"ThinkPad S1 Yoga"),
+		},
+		.driver_data = (int []){1232, 5710, 1156, 4696},
+	},
+	{
+		/* Lenovo ThinkPad X1 Carbon Haswell (3rd generation) */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_VERSION,
+					"ThinkPad X1 Carbon 2nd"),
+		},
+		.driver_data = (int []){1024, 5112, 2024, 4832},
+	},
 #endif
 	{ }
 };
-- 
1.9.1

