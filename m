Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934171AbaLBT5x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:57:53 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46500 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754369AbaLBTU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:20:26 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 016/121] acer-wmi: Add Aspire 5741 to video_vendor_dmi_table
Date: Tue,  2 Dec 2014 11:18:15 -0800
Message-Id: <1417548000-1794-17-git-send-email-kamal@canonical.com>
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

commit 9404cd95507de0a61f2a000fbd76748a9cae33b4 upstream.

The Aspire 5741 has broken acpi-video backlight control, so add it to the
quirk table.

References: https://bugzilla.redhat.com/show_bug.cgi?id=1012674
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Lee, Chun-Yi <jlee@suse.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/platform/x86/acer-wmi.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index c9076bd..3990c79 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -572,6 +572,14 @@ static const struct dmi_system_id video_vendor_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5750"),
 		},
 	},
+	{
+		.callback = video_set_backlight_video_vendor,
+		.ident = "Acer Aspire 5741",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5741"),
+		},
+	},
 	{}
 };
 
-- 
1.9.1

