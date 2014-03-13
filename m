Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673AbaCMQTq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 12:19:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:65316 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754542AbaCMQSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 12:18:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,648,1389772800"; 
   d="scan'208";a="471738872"
From: Zhang Rui <rui.zhang@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: bhelgaas@google.com, matthew.garrett@nebula.com,
        rafael.j.wysocki@intel.com, dmitry.torokhov@gmail.com,
        Zhang Rui <rui.zhang@intel.com>
Subject: [RFC PATCH V2 10/13] Revert "ACPI / PNP: skip ACPI device nodes associated with physical nodes already"
Date: Fri, 14 Mar 2014 00:16:50 +0800
Message-Id: <1394727413-3587-11-git-send-email-rui.zhang@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394727413-3587-1-git-send-email-rui.zhang@intel.com>
References: <1394727413-3587-1-git-send-email-rui.zhang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 2905875344f977acd188a2b0f1d163491e91459b.

commit 2905875344f977acd188a2b0f1d163491e91459b was introduced to prevent
PNP device objects from being created for ACPI device nodes already associated
with platform devices.

This is not needed any more because the platform device node won't be created
if a device has already been attached to the PNPACPI scan handler.

Plus, in some cases, we may need both PNP node and platform node for the
same ACPI device object, on purpose, like what I will do in next patch.

Thus reverting this commit.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/pnp/pnpacpi/core.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/pnp/pnpacpi/core.c b/drivers/pnp/pnpacpi/core.c
index 7852628..f7aa435 100644
--- a/drivers/pnp/pnpacpi/core.c
+++ b/drivers/pnp/pnpacpi/core.c
@@ -223,10 +223,6 @@ static int __init pnpacpi_add_device(struct acpi_device *device)
 	struct acpi_hardware_id *id;
 	int error;
 
-	/* Skip devices that are already bound */
-	if (device->physical_node_count)
-		return 0;
-
 	/*
 	 * If a PnPacpi device is not present , the device
 	 * driver should not be loaded.
-- 
1.7.9.5

