Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324AbaBCK7V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 05:59:21 -0500
Received: from mga01.intel.com ([192.55.52.88]:7361 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784AbaBCK7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 05:59:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,771,1384329600"; 
   d="scan'208";a="475062426"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-acpi@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>,
        Aaron Lu <aaron.lu@intel.com>, linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH] ACPI / video: Add HP EliteBook Revolve 810 to the blacklist
Date: Mon,  3 Feb 2014 12:59:16 +0200
Message-Id: <1391425156-27821-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On HP EliteBook Revolve 810 the ACPI backlight device doesn't work as
expected. For example when resuming from system sleep, it seems to lose
backlight settings.

Forcing Intel driver fixes the problem so add this machine the ACPI
video detect blacklist.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/acpi/video_detect.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index f0447d3daf2c..a697b77b8865 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -170,6 +170,14 @@ static struct dmi_system_id video_detect_dmi_table[] = {
 	},
 	{
 	.callback = video_detect_force_vendor,
+	.ident = "HP EliteBook Revolve 810",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "HP EliteBook Revolve 810 G1"),
+		},
+	},
+	{
+	.callback = video_detect_force_vendor,
 	.ident = "Lenovo Yoga 13",
 	.matches = {
 		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-- 
1.8.3.1

