Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934183AbaLBT63 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:58:29 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46498 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754362AbaLBTU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:20:26 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hans de Goede <hdegoede@redhat.com>, Darren Hart <dvhart@linux.intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 017/121] acer-wmi: Add acpi_backlight=video quirk for the Acer KAV80
Date: Tue,  2 Dec 2014 11:18:16 -0800
Message-Id: <1417548000-1794-18-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/platform/x86/acer-wmi.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index 3990c79..b942a1b 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -580,6 +580,17 @@ static const struct dmi_system_id video_vendor_dmi_table[] = {
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
1.9.1

