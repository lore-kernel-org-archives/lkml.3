Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760027Ab3GaNhb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 09:37:31 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46972 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759753Ab3GaNZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 09:25:59 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Lan Tianyu" <tianyu.lan@intel.com>
Date: Wed, 31 Jul 2013 15:23:09 +0200
Message-ID: <lsq.1375276989.822158812@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [53/84] ACPI / video: ignore BIOS initial backlight value for
 Fujitsu E753
In-Reply-To: <lsq.1375276989.251749228@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.181
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.50-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Lan Tianyu <tianyu.lan@intel.com>

commit 9657a565a476d517451c10b0bcc106e300785aff upstream.

The BIOS of FUjitsu E753 reports an incorrect initial backlight value
for WIN8 compatible OS, causing backlight to be dark during startup.
This change causes the incorrect initial value from BIOS to be ignored.

References: https://bugzilla.kernel.org/show_bug.cgi?id=60161
Reported-and-tested-by: Jan Hinnerk Stosch <janhinnerk.stosch@gmail.com>
Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/acpi/video.c | 8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -449,6 +449,14 @@ static struct dmi_system_id video_dmi_ta
 	},
 	{
 	 .callback = video_ignore_initial_backlight,
+	 .ident = "Fujitsu E753",
+	 .matches = {
+		DMI_MATCH(DMI_BOARD_VENDOR, "FUJITSU"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "LIFEBOOK E753"),
+		},
+	},
+	{
+	 .callback = video_ignore_initial_backlight,
 	 .ident = "HP Pavilion dm4",
 	 .matches = {
 		DMI_MATCH(DMI_BOARD_VENDOR, "Hewlett-Packard"),

