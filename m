Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933065Ab3APQLH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:11:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36915 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933046Ab3APQLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:11:04 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 209/222] ACPI / scan: Do not use dummy HID for system bus ACPI nodes
Date: Wed, 16 Jan 2013 13:56:49 -0200
Message-Id: <1358351822-7675-210-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

commit 4f5f64cf0cc916220aaa055992e31195470cfe37 upstream.

At one point acpi_device_set_id() checks if acpi_device_hid(device)
returns NULL, but that never happens, so system bus devices with an
empty list of PNP IDs are given the dummy HID ("device") instead of
the "system bus HID" ("LNXSYBUS").  Fix the code to use the right
check.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/acpi/scan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 803c4ec..fcae116 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -1162,7 +1162,7 @@ static void acpi_device_set_id(struct acpi_device *device)
 			acpi_add_id(device, ACPI_DOCK_HID);
 		else if (!acpi_ibm_smbus_match(device))
 			acpi_add_id(device, ACPI_SMBUS_IBM_HID);
-		else if (!acpi_device_hid(device) &&
+		else if (list_empty(&device->pnp.ids) &&
 			 ACPI_IS_ROOT_DEVICE(device->parent)) {
 			acpi_add_id(device, ACPI_BUS_HID); /* \_SB, LNXSYBUS */
 			strcpy(device->pnp.device_name, ACPI_BUS_DEVICE_NAME);
-- 
1.7.9.5

