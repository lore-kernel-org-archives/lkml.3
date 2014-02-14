Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252AbaBNMeZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 07:34:25 -0500
Received: from mga09.intel.com ([134.134.136.24]:20854 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751926AbaBNMeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 07:34:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,844,1384329600"; 
   d="scan'208";a="455473323"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-acpi@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>,
        Aaron Lu <aaron.lu@intel.com>, linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH] Revert "ACPI / video: Add HP EliteBook Revolve 810 to the blacklist"
Date: Fri, 14 Feb 2014 14:34:07 +0200
Message-Id: <1392381247-28109-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit e18ac62fa4b3f16234bab0d5a6627c57dbae9e7e.

The referenced commit added HP EliteBook Revolve 810 to the ACPI video
detected blacklist so that only the native Intel backlight interface was
exported.

However, this turned to be wrong solution after all. The ACPI video
interface works and as long as we only use that there are no problems. So
we can revert this commit and stick to use the backlight interface provided
by the ACPI video driver.

(Using Intel native interface will not work after resume since the ACPI
video driver will restore it's state which takes control over the native
one. That's a separate thing and should be addressed in the ACPI video
driver, I suppose.)

References: https://bugzilla.kernel.org/show_bug.cgi?id=70231
Cc: Aaron Lu <aaron.lu@intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
Rafael, 

This turned out to be misunderstanding from my side. I should have
investigated this further before submitting the original patch. Sorry about
that.

Aaron,

Thanks for the investigation and pointing me to the right direction (e.g to
use acpi_video0 over the native one).

 drivers/acpi/video_detect.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index a697b77b8865..f0447d3daf2c 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -170,14 +170,6 @@ static struct dmi_system_id video_detect_dmi_table[] = {
 	},
 	{
 	.callback = video_detect_force_vendor,
-	.ident = "HP EliteBook Revolve 810",
-	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "HP EliteBook Revolve 810 G1"),
-		},
-	},
-	{
-	.callback = video_detect_force_vendor,
 	.ident = "Lenovo Yoga 13",
 	.matches = {
 		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-- 
1.8.5.2

