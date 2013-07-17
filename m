Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932544Ab3GQWu7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 18:50:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56309 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757779Ab3GQWuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:50:54 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 122/145] ACPI / power: add missing newline to debug messages
Date: Wed, 17 Jul 2013 15:47:34 -0700
Message-Id: <1374101277-7915-123-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit 10a0b6176b9f8b026ce07acd8f755297653c443c upstream.

There are few places in power.c where debug messages have no newline
at the end.  Reading such debug messages from dmesg is not fun, so
fix this by adding the missing newlines.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/acpi/power.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
index 6e7b9d5..45eac3d 100644
--- a/drivers/acpi/power.c
+++ b/drivers/acpi/power.c
@@ -256,7 +256,7 @@ static int acpi_power_on(acpi_handle handle)
 
 	if (resource->ref_count++) {
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
-				  "Power resource [%s] already on",
+				  "Power resource [%s] already on\n",
 				  resource->name));
 	} else {
 		result = __acpi_power_on(resource);
@@ -298,7 +298,7 @@ static int acpi_power_off(acpi_handle handle)
 
 	if (!resource->ref_count) {
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
-				  "Power resource [%s] already off",
+				  "Power resource [%s] already off\n",
 				  resource->name));
 		goto unlock;
 	}
-- 
1.8.1.2

