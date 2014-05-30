Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635AbaE3COf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 22:14:35 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:60111 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932298AbaE3COc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 22:14:32 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        matthew.garrett@nebula.com, mika.westerberg@linux.intel.com
Subject: [PATCH 5/10] ACPI / scan: introduce platform_id device PNP type flag
Date: Fri, 30 May 2014 04:26:18 +0200
Message-ID: <1831678.FWIeOcOJpB@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <35042328.kk6ZUUdfyN@vostro.rjw.lan>
References: <1400781753-2682-1-git-send-email-rui.zhang@intel.com> <35042328.kk6ZUUdfyN@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Only certain types of ACPI device objects can be enumerated as
platform devices, so in order to distinguish them from the others
introduce a new ACPI device PNP type flag, platform_id, and set it
for devices with a valid _HID to start with.

This change is based on a Zhang Rui's prototype.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

---
drivers/acpi/scan.c     | 9 ++++++++-
 drivers/acpi/scan.c     |    4 +++-
 include/acpi/acpi_bus.h |    3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -1797,8 +1797,10 @@ static void acpi_set_pnp_ids(acpi_handle
 			return;
 		}
 
-		if (info->valid & ACPI_VALID_HID)
+		if (info->valid & ACPI_VALID_HID) {
 			acpi_add_id(pnp, info->hardware_id.string);
+			pnp->type.platform_id = 1;
+		}
 		if (info->valid & ACPI_VALID_CID) {
 			cid_list = &info->compatible_id_list;
 			for (i = 0; i < cid_list->count; i++)
Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -233,7 +233,8 @@ struct acpi_hardware_id {
 struct acpi_pnp_type {
 	u32 hardware_id:1;
 	u32 bus_address:1;
-	u32 reserved:30;
+	u32 platform_id:1;
+	u32 reserved:29;
 };
 
 struct acpi_device_pnp {

