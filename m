Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460AbaEPMxf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 08:53:35 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49556 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753456AbaEPMsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 08:48:21 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Benjamin Tissoires" <benjamin.tissoires@redhat.com>,
        "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
        "Hans de Goede" <hdegoede@redhat.com>
Date: Fri, 16 May 2014 13:47:21 +0100
Message-ID: <lsq.1400244441.862243972@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 18/34] Input: synaptics - add min/max quirk for
 ThinkPad T431s, L440, L540, S1 Yoga and X1
In-Reply-To: <lsq.1400244440.390103756@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:3db0:c181:6526:5597
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.59-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/input/mouse/synaptics.c | 42 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -1394,6 +1394,14 @@ static const struct dmi_system_id min_ma
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
@@ -1402,6 +1410,14 @@ static const struct dmi_system_id min_ma
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
@@ -1409,6 +1425,32 @@ static const struct dmi_system_id min_ma
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

