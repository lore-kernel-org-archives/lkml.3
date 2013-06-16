Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038Ab3FPW2L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 18:28:11 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46385 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755646Ab3FPWIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 18:08:50 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Alex Hung" <alex.hung@canonical.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Date: Sun, 16 Jun 2013 23:01:38 +0100
Message-ID: <lsq.1371420098.13376513@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [46/83] ACPI video: ignore BIOS initial backlight value for HP 1000
In-Reply-To: <lsq.1371420097.958132574@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.47-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@canonical.com>

commit 4ef366c583d6180b1c951147869ee5a3038834f2 upstream.

On HP 1000 lapops, BIOS reports minimum backlight on boot and
causes backlight to dim completely. This ignores the initial backlight
values and set to max brightness.

References:: https://bugs.launchpad.net/bugs/1167760
Signed-off-by: Alex Hung <alex.hung@canonical.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/acpi/video.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -455,6 +455,14 @@ static struct dmi_system_id video_dmi_ta
 		DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion dm4 Notebook PC"),
 		},
 	},
+	{
+	 .callback = video_ignore_initial_backlight,
+	 .ident = "HP 1000 Notebook PC",
+	 .matches = {
+		DMI_MATCH(DMI_BOARD_VENDOR, "Hewlett-Packard"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "HP 1000 Notebook PC"),
+		},
+	},
 	{}
 };
 

