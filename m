Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966AbaGGERL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 00:17:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:49231 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752824AbaGGERG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 00:17:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,616,1400050800"; 
   d="scan'208";a="558140146"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH v2 1/7] ACPICA: Linux: Add stub support for Linux specific variables and functions.
Date: Mon,  7 Jul 2014 12:17:02 +0800
Message-Id: <7e45b9fcad00a32dfa7c9ef66d7e53097c96158e.1404706298.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1404706298.git.lv.zheng@intel.com>
References: <cover.1387336613.git.lv.zheng@intel.com> <cover.1404706298.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are global variables and functions not upstreamed to the ACPICA code
base.  Such symbols still can be referenced by external users as they are
listed in the acpixf.h.  This patch uses ACPI_GLOBAL and
ACPI_EXTERNAL_RETURN_STATUS mechanism to add stub support for such symbols.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 drivers/acpi/bus.c    |    3 ---
 include/acpi/acpixf.h |   28 +++++++++++++++++-----------
 2 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index c5bc8cf..8581f5b 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -477,9 +477,6 @@ static int __init acpi_bus_init_irq(void)
 	return 0;
 }
 
-u8 acpi_gbl_permanent_mmap;
-
-
 void __init acpi_early_init(void)
 {
 	acpi_status status;
diff --git a/include/acpi/acpixf.h b/include/acpi/acpixf.h
index 35b525c..bdbb145 100644
--- a/include/acpi/acpixf.h
+++ b/include/acpi/acpixf.h
@@ -53,8 +53,6 @@
 #include <acpi/actbl.h>
 #include <acpi/acbuffer.h>
 
-extern u8 acpi_gbl_permanent_mmap;
-
 /*****************************************************************************
  *
  * Macros used for ACPICA globals and configuration
@@ -865,17 +863,25 @@ ACPI_DBG_DEPENDENT_RETURN_VOID(ACPI_PRINTF_LIKE(6)
 /*
  * Divergences
  */
-acpi_status acpi_get_id(acpi_handle object, acpi_owner_id * out_type);
+ACPI_GLOBAL(u8, acpi_gbl_permanent_mmap);
+
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			    acpi_get_id(acpi_handle object,
+					acpi_owner_id * out_type))
 
-acpi_status acpi_unload_table_id(acpi_owner_id id);
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status acpi_unload_table_id(acpi_owner_id id))
 
-acpi_status
-acpi_get_table_with_size(acpi_string signature,
-	       u32 instance, struct acpi_table_header **out_table,
-	       acpi_size *tbl_size);
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			    acpi_get_table_with_size(acpi_string signature,
+						     u32 instance,
+						     struct acpi_table_header
+						     **out_table,
+						     acpi_size *tbl_size))
 
-acpi_status
-acpi_get_data_full(acpi_handle object, acpi_object_handler handler, void **data,
-		   void (*callback)(void *));
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			    acpi_get_data_full(acpi_handle object,
+					       acpi_object_handler handler,
+					       void **data,
+					       void (*callback)(void *)))
 
 #endif				/* __ACXFACE_H__ */
-- 
1.7.10

