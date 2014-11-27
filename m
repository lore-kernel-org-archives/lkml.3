Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443AbaK0G0V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 01:26:21 -0500
Received: from mga01.intel.com ([192.55.52.88]:44816 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714AbaK0G0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 01:26:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,467,1413270000"; 
   d="scan'208";a="638887213"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Bob Moore <robert.moore@intel.com>
Subject: [PATCH 2/6] ACPICA: acpiexec: Add option to specify an object initialization file.
Date: Thu, 27 Nov 2014 14:26:07 +0800
Message-Id: <eb9a4e2bf6bae05bff67af3ff4fdacb7e892376f.1416899966.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1416899966.git.lv.zheng@intel.com>
References: <cover.1416899966.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Moore <robert.moore@intel.com>

This option (-fi) allows the specification of a file that is used
to specify initialization values for individual namespace objects.
Each line in the file is in the format:

<ACPI pathname> <Integer Value>

This patch only affects acpiexec which is not in the Linux kernel.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 drivers/acpi/acpica/utxfinit.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/acpi/acpica/utxfinit.c b/drivers/acpi/acpica/utxfinit.c
index 13380d8..b1fd688 100644
--- a/drivers/acpi/acpica/utxfinit.c
+++ b/drivers/acpi/acpica/utxfinit.c
@@ -53,6 +53,9 @@
 #define _COMPONENT          ACPI_UTILITIES
 ACPI_MODULE_NAME("utxfinit")
 
+/* For acpi_exec only */
+void ae_do_object_overrides(void);
+
 /*******************************************************************************
  *
  * FUNCTION:    acpi_initialize_subsystem
@@ -65,6 +68,7 @@ ACPI_MODULE_NAME("utxfinit")
  *              called, so any early initialization belongs here.
  *
  ******************************************************************************/
+
 acpi_status __init acpi_initialize_subsystem(void)
 {
 	acpi_status status;
@@ -275,6 +279,13 @@ acpi_status __init acpi_initialize_objects(u32 flags)
 			return_ACPI_STATUS(status);
 		}
 	}
+#ifdef ACPI_EXEC_APP
+	/*
+	 * This call implements the "initialization file" option for acpi_exec.
+	 * This is the precise point that we want to perform the overrides.
+	 */
+	ae_do_object_overrides();
+#endif
 
 	/*
 	 * Execute any module-level code that was detected during the table load
-- 
1.7.10

