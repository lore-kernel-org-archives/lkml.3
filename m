Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711AbaFWUbb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 16:31:31 -0400
Received: from mx02.posteo.de ([89.146.194.165]:39671 "EHLO posteo.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756507AbaFWUb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 16:31:29 -0400
From: Martin Kepplinger <martink@posteo.de>
To: rui.zhang@intel.com
Cc: rjw@rjwysocki.net, lenb@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Martin Kepplinger <martink@posteo.de>
Subject: [PATCH] Fix backlight control for Acer TravelMate B113
Date: Mon, 23 Jun 2014 22:30:46 +0200
Message-Id: <1403555446-16863-1-git-send-email-martink@posteo.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix backlight control for Acer TravelMate B113 Laptop by adding
it to the video_dmi_table.

A workaround before that was to use acpi_osi=Linux or
acpi_backlight=vendor on boot but even then, only the function-
keys worked.

With this change there is no need for boot parameters and DE's
controls work as well.

Signed-off-by: Martin Kepplinger <martink@posteo.de>
Tested-by: Martin Kepplinger <martink@posteo.de>
---
 drivers/acpi/video.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index f8bc5a7..acb0670 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -528,6 +528,14 @@ static struct dmi_system_id video_dmi_table[] __initdata = {
 		},
 	},
 	{
+	 .callback = video_set_use_native_backlight,
+	 .ident = "Acer TravelMate B113",
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate B113"),
+		},
+	},
+	{
 	.callback = video_set_use_native_backlight,
 	.ident = "HP ProBook 4340s",
 	.matches = {
-- 
1.7.10.4

