Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587AbaCQEPQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 00:15:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:45621 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbaCQEPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 00:15:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,667,1389772800"; 
   d="scan'208";a="473864650"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [RFC PATCH 2/2] ACPI: Default disable auto-serialization.
Date: Mon, 17 Mar 2014 12:14:58 +0800
Message-Id: <fdc47fb7d89d984a164531b316e8b56f73ed05c9.1395028738.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1395028738.git.lv.zheng@intel.com>
References: <14866.1394813101@turing-police.cc.vt.edu> <cover.1395028738.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This feature enabled by the following commit is still under development.

  Commit: cd52379678785b02d7a357988cfba214fdaf92f4
  Subject: ACPICA: Add global option to disable method auto-serialization.
  This change adds an option to disable the auto-serialization of
  methods that create named objects.

This patch disables it by default temporarily according to the bug reports.

References: http://www.spinics.net/lists/linux-acpi/msg49496.html
Reported-by: Valdis Kletnieks <validis.kletnieks@vt.edu>
Reported-by: Sabrina Dubroka <sd@queasysnail.net>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 Documentation/kernel-parameters.txt |    8 ++++----
 drivers/acpi/acpica/acglobal.h      |    2 +-
 drivers/acpi/osl.c                  |   12 ++++++------
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 91f0be8..a159537 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -229,13 +229,13 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			use by PCI
 			Format: <irq>,<irq>...
 
-	acpi_no_auto_serialize	[HW,ACPI]
-			Disable auto-serialization of AML methods
+	acpi_auto_serialize	[HW,ACPI]
+			Enable auto-serialization of AML methods
 			AML control methods that contain the opcodes to create
 			named objects will be marked as "Serialized" by the
 			auto-serialization feature.
-			This feature is enabled by default.
-			This option allows to turn off the feature.
+			This feature is disabled by default.
+			This option allows to turn on the feature.
 
 	acpi_no_auto_ssdt	[HW,ACPI] Disable automatic loading of SSDT
 
diff --git a/drivers/acpi/acpica/acglobal.h b/drivers/acpi/acpica/acglobal.h
index 49bbc71..ea0f838 100644
--- a/drivers/acpi/acpica/acglobal.h
+++ b/drivers/acpi/acpica/acglobal.h
@@ -99,7 +99,7 @@ ACPI_INIT_GLOBAL(u8, acpi_gbl_enable_interpreter_slack, FALSE);
  * that create named objects are marked Serialized in order to prevent
  * possible run-time problems if they are entered by more than one thread.
  */
-ACPI_INIT_GLOBAL(u8, acpi_gbl_auto_serialize_methods, TRUE);
+ACPI_INIT_GLOBAL(u8, acpi_gbl_auto_serialize_methods, FALSE);
 
 /*
  * Create the predefined _OSI method in the namespace? Default is TRUE
diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index d40d6dc..928f0c2 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -1538,20 +1538,20 @@ static int __init osi_setup(char *str)
 __setup("acpi_osi=", osi_setup);
 
 /*
- * Disable the auto-serialization of named objects creation methods.
+ * Enable the auto-serialization of named objects creation methods.
  *
- * This feature is enabled by default.  It marks the AML control methods
+ * This feature is disabled by default.  It marks the AML control methods
  * that contain the opcodes to create named objects as "Serialized".
  */
-static int __init acpi_no_auto_serialize_setup(char *str)
+static int __init acpi_auto_serialize_setup(char *str)
 {
-	acpi_gbl_auto_serialize_methods = FALSE;
-	pr_info("ACPI: auto-serialization disabled\n");
+	acpi_gbl_auto_serialize_methods = TRUE;
+	pr_info("ACPI: auto-serialization enabled\n");
 
 	return 1;
 }
 
-__setup("acpi_no_auto_serialize", acpi_no_auto_serialize_setup);
+__setup("acpi_auto_serialize", acpi_auto_serialize_setup);
 
 /* Check of resource interference between native drivers and ACPI
  * OperationRegions (SystemIO and System Memory only).
-- 
1.7.10

