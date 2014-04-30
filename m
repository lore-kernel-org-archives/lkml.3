Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345AbaD3CHm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 22:07:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:17260 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507AbaD3CHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 22:07:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,955,1389772800"; 
   d="scan'208";a="503429262"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Bob Moore <robert.moore@intel.com>
Subject: [PATCH 26/27] ACPICA: Comment/format update, no functional change.
Date: Wed, 30 Apr 2014 10:06:22 +0800
Message-Id: <5f3379681ca9f8480614044a9c070fc2a66d46c1.1398817613.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1398817612.git.lv.zheng@intel.com>
References: <cover.1398817612.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Moore <robert.moore@intel.com>

Add some additional commenting the the public acpixf.h file.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 include/acpi/acpixf.h |   73 ++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 54 insertions(+), 19 deletions(-)

diff --git a/include/acpi/acpixf.h b/include/acpi/acpixf.h
index 2d074ba..b3b2108 100644
--- a/include/acpi/acpixf.h
+++ b/include/acpi/acpixf.h
@@ -55,11 +55,17 @@
 
 extern u8 acpi_gbl_permanent_mmap;
 
+/*****************************************************************************
+ *
+ * Macros used for ACPICA globals and configuration
+ *
+ ****************************************************************************/
+
 /*
- * Ensure that the globals are actually defined and initialized only once.
+ * Ensure that global variables are defined and initialized only once.
  *
- * The use of these macros allows a single list of globals (here) in order
- * to simplify maintenance of the code.
+ * The use of these macros allows for a single list of globals (here)
+ * in order to simplify maintenance of the code.
  */
 #ifdef DEFINE_ACPI_GLOBALS
 #define ACPI_GLOBAL(type,name) \
@@ -81,8 +87,11 @@ extern u8 acpi_gbl_permanent_mmap;
 #endif
 #endif
 
-/* ACPICA prototypes */
-
+/*
+ * These macros configure the various ACPICA interfaces. They are
+ * useful for generating stub inline functions for features that are
+ * configured out of the current kernel or ACPICA application.
+ */
 #ifndef ACPI_EXTERNAL_RETURN_STATUS
 #define ACPI_EXTERNAL_RETURN_STATUS(prototype) \
 	prototype;
@@ -108,16 +117,14 @@ extern u8 acpi_gbl_permanent_mmap;
 	prototype;
 #endif
 
-/* Public globals, available from outside ACPICA subsystem */
-
 /*****************************************************************************
  *
- * Runtime configuration (static defaults that can be overriden at runtime)
+ * Public globals and runtime configuration options
  *
  ****************************************************************************/
 
 /*
- * Enable "slack" in the AML interpreter?  Default is FALSE, and the
+ * Enable "slack mode" of the AML interpreter?  Default is FALSE, and the
  * interpreter strictly follows the ACPI specification. Setting to TRUE
  * allows the interpreter to ignore certain errors and/or bad AML constructs.
  *
@@ -234,16 +241,34 @@ ACPI_INIT_GLOBAL(u32, acpi_dbg_level, ACPI_DEBUG_DEFAULT);
 ACPI_INIT_GLOBAL(u32, acpi_dbg_layer, 0);
 
 /*
- * Globals that are publically available
+ * Other miscellaneous globals
  */
-ACPI_GLOBAL(u32, acpi_current_gpe_count);
 ACPI_GLOBAL(struct acpi_table_fadt, acpi_gbl_FADT);
+ACPI_GLOBAL(u32, acpi_current_gpe_count);
 ACPI_GLOBAL(u8, acpi_gbl_system_awake_and_running);
 
+/*****************************************************************************
+ *
+ * ACPICA public interface configuration.
+ *
+ * Interfaces that are configured out of the ACPICA build are replaced
+ * by inlined stubs by default.
+ *
+ ****************************************************************************/
+
 /*
- * Hardware-reduced prototypes. All interfaces that use these macros will
- * be configured out of the ACPICA build if the ACPI_REDUCED_HARDWARE flag
+ * Hardware-reduced prototypes (default: Not hardware reduced).
+ *
+ * All ACPICA hardware-related interfaces that use these macros will be
+ * configured out of the ACPICA build if the ACPI_REDUCED_HARDWARE flag
  * is set to TRUE.
+ *
+ * Note: This static build option for reduced hardware is intended to
+ * reduce ACPICA code size if desired or necessary. However, even if this
+ * option is not specified, the runtime behavior of ACPICA is dependent
+ * on the actual FADT reduced hardware flag (HW_REDUCED_ACPI). If set,
+ * the flag will enable similar behavior -- ACPICA will not attempt
+ * to access any ACPI-relate hardware (SCI, GPEs, Fixed Events, etc.)
  */
 #if (!ACPI_REDUCED_HARDWARE)
 #define ACPI_HW_DEPENDENT_RETURN_STATUS(prototype) \
@@ -268,9 +293,11 @@ ACPI_GLOBAL(u8, acpi_gbl_system_awake_and_running);
 #endif				/* !ACPI_REDUCED_HARDWARE */
 
 /*
- * Error-message prototypes. All interfaces that use these macros will
- * be configured out of the ACPICA build if the ACPI_NO_ERROR_MESSAGE flag
- * is defined.
+ * Error message prototypes (default: error messages enabled).
+ *
+ * All interfaces related to error and warning messages
+ * will be configured out of the ACPICA build if the
+ * ACPI_NO_ERROR_MESSAGE flag is defined.
  */
 #ifndef ACPI_NO_ERROR_MESSAGES
 #define ACPI_MSG_DEPENDENT_RETURN_VOID(prototype) \
@@ -283,9 +310,11 @@ ACPI_GLOBAL(u8, acpi_gbl_system_awake_and_running);
 #endif				/* ACPI_NO_ERROR_MESSAGES */
 
 /*
- * Debugging-output prototypes. All interfaces that use these macros will
- * be configured out of the ACPICA build if the ACPI_DEBUG_OUTPUT flag is
- * not defined.
+ * Debugging output prototypes (default: no debug output).
+ *
+ * All interfaces related to debug output messages
+ * will be configured out of the ACPICA build unless the
+ * ACPI_DEBUG_OUTPUT flag is defined.
  */
 #ifdef ACPI_DEBUG_OUTPUT
 #define ACPI_DBG_DEPENDENT_RETURN_VOID(prototype) \
@@ -297,6 +326,12 @@ ACPI_GLOBAL(u8, acpi_gbl_system_awake_and_running);
 
 #endif				/* ACPI_DEBUG_OUTPUT */
 
+/*****************************************************************************
+ *
+ * ACPICA public interface prototypes
+ *
+ ****************************************************************************/
+
 /*
  * Initialization
  */
-- 
1.7.10

