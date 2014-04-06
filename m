Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066AbaDFXlR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 19:41:17 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59437 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754668AbaDFXjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 19:39:06 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
        "Hans de Goede" <hdegoede@redhat.com>
Date: Mon, 07 Apr 2014 00:35:48 +0100
Message-ID: <lsq.1396827348.948238718@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 02/18] Input: synaptics - add manual min/max quirk for
 ThinkPad X240
In-Reply-To: <lsq.1396827347.462803115@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.2.102
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.57-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 8a0435d958fb36d93b8df610124a0e91e5675c82 upstream.

This extends Benjamin Tissoires manual min/max quirk table with support for
the ThinkPad X240.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/input/mouse/synaptics.c | 8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -1386,6 +1386,14 @@ static const struct dmi_system_id min_ma
 		.driver_data = (int []){1024, 5052, 2258, 4832},
 	},
 	{
+		/* Lenovo ThinkPad X240 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad X240"),
+		},
+		.driver_data = (int []){1232, 5710, 1156, 4696},
+	},
+	{
 		/* Lenovo ThinkPad T440s */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),

