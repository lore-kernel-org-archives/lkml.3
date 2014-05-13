Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760250AbaEMJa1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:30:27 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:33225 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760159AbaEMJ3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:29:04 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 180/182] Input: synaptics - add min/max quirk for ThinkPad T431s, L440, L540, S1 Yoga and X1
Date: Tue, 13 May 2014 11:28:52 +0200
Message-Id: <56cc256c13ce02caf24d80b9f472dc3a51532676.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/input/mouse/synaptics.c | 42 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index d8d49d10f9bb..5048210e798c 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -1515,6 +1515,14 @@ static const struct dmi_system_id min_max_dmi_table[] __initconst = {
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
@@ -1523,6 +1531,14 @@ static const struct dmi_system_id min_max_dmi_table[] __initconst = {
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
@@ -1530,6 +1546,32 @@ static const struct dmi_system_id min_max_dmi_table[] __initconst = {
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
1.9.3

