Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973Ab3FPWVI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 18:21:08 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46443 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755760Ab3FPWI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 18:08:58 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Gustavo Maciel Dias Vieira" <gustavo@sagui.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Date: Sun, 16 Jun 2013 23:01:38 +0100
Message-ID: <lsq.1371420098.32845430@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [45/83] ACPI video: ignore BIOS backlight value for HP dm4
In-Reply-To: <lsq.1371420097.958132574@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.47-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Gustavo Maciel Dias Vieira <gustavo@sagui.org>

commit 771d09b3c4c45d4d534a83a68e6331b97fd82e15 upstream.

On a HP Pavilion dm4 laptop the BIOS sets minimum backlight on boot,
completely dimming the screen. Ignore this initial value for this
machine.

Signed-off-by: Gustavo Maciel Dias Vieira <gustavo@sagui.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/acpi/video.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -447,6 +447,14 @@ static struct dmi_system_id video_dmi_ta
 		DMI_MATCH(DMI_PRODUCT_NAME, "HP Folio 13 - 2000 Notebook PC"),
 		},
 	},
+	{
+	 .callback = video_ignore_initial_backlight,
+	 .ident = "HP Pavilion dm4",
+	 .matches = {
+		DMI_MATCH(DMI_BOARD_VENDOR, "Hewlett-Packard"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion dm4 Notebook PC"),
+		},
+	},
 	{}
 };
 

