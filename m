Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870Ab3FPWI6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 18:08:58 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46313 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755557Ab3FPWIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 18:08:48 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Ash Willis" <ashwillis.kernel@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Ash Willis" <ashwillis@programmer.net>
Date: Sun, 16 Jun 2013 23:01:38 +0100
Message-ID: <lsq.1371420098.982096375@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [48/83] ACPI / video: ignore BIOS initial backlight value for HP
 Pavilion g6
In-Reply-To: <lsq.1371420097.958132574@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.47-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ash Willis <ashwillis.kernel@gmail.com>

commit 780a6ec640a3fed671fc2c40e4dd30c03eca3ac3 upstream.

This patch addresses kernel bug 56661. BIOS reports an incorrect
backlight value, causing the driver to switch off the backlight
completely during startup. This patch ignores the incorrect value from
BIOS.

References: https://bugzilla.kernel.org/show_bug.cgi?id=56661
Signed-off-by: Ash Willis <ashwillis@programmer.net>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/acpi/video.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -457,6 +457,14 @@ static struct dmi_system_id video_dmi_ta
 	},
 	{
 	 .callback = video_ignore_initial_backlight,
+	 .ident = "HP Pavilion g6 Notebook PC",
+	 .matches = {
+		 DMI_MATCH(DMI_BOARD_VENDOR, "Hewlett-Packard"),
+		 DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion g6 Notebook PC"),
+		},
+	},
+	{
+	 .callback = video_ignore_initial_backlight,
 	 .ident = "HP 1000 Notebook PC",
 	 .matches = {
 		DMI_MATCH(DMI_BOARD_VENDOR, "Hewlett-Packard"),

