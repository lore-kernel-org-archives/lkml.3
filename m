Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247Ab3GEJND (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 05:13:03 -0400
Received: from mga14.intel.com ([143.182.124.37]:34382 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753718Ab3GEJNB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 05:13:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1000,1363158000"; 
   d="scan'208";a="360867218"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH] ACPI / power: add missing newline to debug messages
Date: Fri,  5 Jul 2013 12:15:56 +0300
Message-Id: <1373015756-29635-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are few places in power.c where debug messages have no newline at the
end. Reading such debug messages from dmesg is not fun so fix this by
adding the missing newlines.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/acpi/power.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
index 288bb27..5c28c89 100644
--- a/drivers/acpi/power.c
+++ b/drivers/acpi/power.c
@@ -279,7 +279,7 @@ static int acpi_power_on_unlocked(struct acpi_power_resource *resource)
 
 	if (resource->ref_count++) {
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
-				  "Power resource [%s] already on",
+				  "Power resource [%s] already on\n",
 				  resource->name));
 	} else {
 		result = __acpi_power_on(resource);
@@ -325,7 +325,7 @@ static int acpi_power_off_unlocked(struct acpi_power_resource *resource)
 
 	if (!resource->ref_count) {
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
-				  "Power resource [%s] already off",
+				  "Power resource [%s] already off\n",
 				  resource->name));
 		return 0;
 	}
-- 
1.8.3.2

