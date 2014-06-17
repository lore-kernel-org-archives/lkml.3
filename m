Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966013AbaFQVri (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:47:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53891 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965975AbaFQVrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:47:32 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 097/212] ACPI / blacklist: Add dmi_enable_osi_linux quirk for Asus EEE PC 1015PX
Date: Tue, 17 Jun 2014 14:43:11 -0700
Message-Id: <1403041506-13646-98-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit f6e6e1b9fee88c90586787b71dc49bb3ce62bb89 upstream.

Without this this EEE PC exports a non working WMI interface, with this it
exports a working "good old" eeepc_laptop interface, fixing brightness control
not working as well as rfkill being stuck in a permanent wireless blocked
state.

This is not an ideal way to fix this, but various attempts to fix this
otherwise have failed, see:

References: https://bugzilla.redhat.com/show_bug.cgi?id=1067181
Reported-and-tested-by: lou.cardone@gmail.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/acpi/blacklist.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/acpi/blacklist.c b/drivers/acpi/blacklist.c
index 3591dd7..dc3bc3d 100644
--- a/drivers/acpi/blacklist.c
+++ b/drivers/acpi/blacklist.c
@@ -391,6 +391,19 @@ static struct dmi_system_id acpi_osi_dmi_table[] __initdata = {
 		     DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad T500"),
 		},
 	},
+	/*
+	 * Without this this EEEpc exports a non working WMI interface, with
+	 * this it exports a working "good old" eeepc_laptop interface, fixing
+	 * both brightness control, and rfkill not working.
+	 */
+	{
+	.callback = dmi_enable_osi_linux,
+	.ident = "Asus EEE PC 1015PX",
+	.matches = {
+		     DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer INC."),
+		     DMI_MATCH(DMI_PRODUCT_NAME, "1015PX"),
+		},
+	},
 	{}
 };
 
-- 
1.9.1

