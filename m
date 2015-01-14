Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339AbbANHbz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:31:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58301 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932326AbbANHbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:31:53 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vitaliy Filippov <vitalif@yourcmc.ru>,
        Laszlo KREKACS <laszlo.krekacs.list@gmail.com>,
        Vladimir Perepechin <vovochka13@gmail.com>,
        Aaron Lu <aaron.lu@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.18 124/150] ACPI / video: Add some Samsung models to disable_native_backlight list
Date: Tue, 13 Jan 2015 23:23:15 -0800
Message-Id: <20150114072101.455194899@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Lu <aaron.lu@intel.com>

commit 7d0b93499f4879ddbc75d594f4ea216ba964f78e upstream.

Several Samsung laptop models (SAMSUNG 870Z5E/880Z5E/680Z5E and
SAMSUNG 370R4E/370R4V/370R5E/3570RE/370R5V) do not have a working
native backlight control interface so restore their acpi_videoX
interface.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=84221
Link: https://bugzilla.kernel.org/show_bug.cgi?id=84651
For SAMSUNG 870Z5E/880Z5E/680Z5E:
Reported-and-tested-by: Brent Saner <brent.saner@gmail.com>
Reported-by: Vitaliy Filippov <vitalif@yourcmc.ru>
Reported-by: Laszlo KREKACS <laszlo.krekacs.list@gmail.com>
For SAMSUNG 370R4E/370R4V/370R5E/3570RE/370R5V:
Reported-by: Vladimir Perepechin <vovochka13@gmail.com>
Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/video.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -505,6 +505,23 @@ static struct dmi_system_id video_dmi_ta
 		DMI_MATCH(DMI_PRODUCT_NAME, "HP ENVY 15 Notebook PC"),
 		},
 	},
+
+	{
+	 .callback = video_disable_native_backlight,
+	 .ident = "SAMSUNG 870Z5E/880Z5E/680Z5E",
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "870Z5E/880Z5E/680Z5E"),
+		},
+	},
+	{
+	 .callback = video_disable_native_backlight,
+	 .ident = "SAMSUNG 370R4E/370R4V/370R5E/3570RE/370R5V",
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "370R4E/370R4V/370R5E/3570RE/370R5V"),
+		},
+	},
 	{}
 };
 


