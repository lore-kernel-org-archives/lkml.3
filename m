Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532AbaKYKkV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:40:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57965 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbaKYKkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:40:12 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hans de Goede <hdegoede@redhat.com>, Darren Hart <dvhart@linux.intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 002/254] acer-wmi: Add acpi_backlight=video quirk for the Acer KAV80
Date: Tue, 25 Nov 2014 10:35:52 +0000
Message-Id: <1416912004-5928-3-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 183fd8fcd7f8afb7ac5ec68f83194872f9fecc84 upstream.

The acpi-video backlight interface on the Acer KAV80 is broken, and worse
it causes the entire machine to slow down significantly after a suspend/resume.

Blacklist it, and use the acer-wmi backlight interface instead. Note that
the KAV80 is somewhat unique in that it is the only Acer model where we
fall back to acer-wmi after blacklisting, rather then using the native
(e.g. intel) backlight driver. This is done because there is no native
backlight interface on this model.

BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1128309
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Darren Hart <dvhart@linux.intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/platform/x86/acer-wmi.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index bbf78b2d6d93..5eeddc00f210 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -578,6 +578,17 @@ static const struct dmi_system_id video_vendor_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5741"),
 		},
 	},
+	{
+		/*
+		 * Note no video_set_backlight_video_vendor, we must use the
+		 * acer interface, as there is no native backlight interface.
+		 */
+		.ident = "Acer KAV80",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "KAV80"),
+		},
+	},
 	{}
 };
 
-- 
2.1.0

