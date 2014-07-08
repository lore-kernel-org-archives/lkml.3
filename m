Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837AbaGHTIr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:08:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54047 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755655AbaGHTIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:38 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
        "Hans de Goede" <hdegoede@redhat.com>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.73188831@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 005/125] Input: synaptics - add min/max quirk for the
 ThinkPad W540
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 0b5fe736fe923f1f5e05413878d5990e92ffbdf5 upstream.

https://bugzilla.redhat.com/show_bug.cgi?id=1096436

Tested-and-reported-by: ajayr@bigfoot.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/input/mouse/synaptics.c | 8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -1442,6 +1442,14 @@ static const struct dmi_system_id min_ma
 		.driver_data = (int []){1024, 5112, 2024, 4832},
 	},
 	{
+		/* Lenovo ThinkPad W540 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad W540"),
+		},
+		.driver_data = (int []){1024, 5112, 2024, 4832},
+	},
+	{
 		/* Lenovo Yoga S1 */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),

