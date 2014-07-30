Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009AbaG3EVo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 00:21:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:39279 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754932AbaG3EVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 00:21:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,762,1400050800"; 
   d="scan'208";a="580994474"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        "David E. Box" <david.e.box@linux.intel.com>,
        Bob Moore <robert.moore@intel.com>
Subject: [PATCH 10/17] ACPICA: ACPI 5.1: Support for the _DSD predefined name.
Date: Wed, 30 Jul 2014 12:21:26 +0800
Message-Id: <927b2d866fb5911f081a6aa8c294c79764204dcf.1406689494.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1406689493.git.lv.zheng@intel.com>
References: <cover.1406689493.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "David E. Box" <david.e.box@linux.intel.com>

Adds full support for _DSD. David Box.

Signed-off-by: David E. Box <david.e.box@linux.intel.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 drivers/acpi/acpica/acpredef.h |   13 ++++++++++++-
 include/acpi/acnames.h         |    1 +
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/acpica/acpredef.h b/drivers/acpi/acpica/acpredef.h
index bd08817..c5bfadf 100644
--- a/drivers/acpi/acpica/acpredef.h
+++ b/drivers/acpi/acpica/acpredef.h
@@ -105,6 +105,11 @@
  *      count = 0 (optional)
  *      (Used for _DLM)
  *
+ * ACPI_PTYPE2_UUID_PAIR: Each subpackage is preceded by a UUID Buffer. The UUID
+ *      defines the format of the package. Zero-length parent package is
+ *      allowed.
+ *      (Used for _DSD)
+ *
  *****************************************************************************/
 
 enum acpi_return_package_types {
@@ -117,7 +122,8 @@ enum acpi_return_package_types {
 	ACPI_PTYPE2_FIXED = 7,
 	ACPI_PTYPE2_MIN = 8,
 	ACPI_PTYPE2_REV_FIXED = 9,
-	ACPI_PTYPE2_FIX_VAR = 10
+	ACPI_PTYPE2_FIX_VAR = 10,
+	ACPI_PTYPE2_UUID_PAIR = 11
 };
 
 /* Support macros for users of the predefined info table */
@@ -436,6 +442,11 @@ const union acpi_predefined_info acpi_gbl_predefined_methods[] = {
 	{{"_DOS", METHOD_1ARGS(ACPI_TYPE_INTEGER),
 	  METHOD_NO_RETURN_VALUE}},
 
+	{{"_DSD", METHOD_0ARGS,
+	  METHOD_RETURNS(ACPI_RTYPE_PACKAGE)}},	/* Variable-length (Pkgs) each: 1 Buf, 1 Pkg */
+	PACKAGE_INFO(ACPI_PTYPE2_UUID_PAIR, ACPI_RTYPE_BUFFER, 1,
+		     ACPI_RTYPE_PACKAGE, 1, 0),
+
 	{{"_DSM",
 	  METHOD_4ARGS(ACPI_TYPE_BUFFER, ACPI_TYPE_INTEGER, ACPI_TYPE_INTEGER,
 		       ACPI_TYPE_PACKAGE),
diff --git a/include/acpi/acnames.h b/include/acpi/acnames.h
index 3dd6e83..c728113 100644
--- a/include/acpi/acnames.h
+++ b/include/acpi/acnames.h
@@ -55,6 +55,7 @@
 #define METHOD_NAME__HID        "_HID"
 #define METHOD_NAME__INI        "_INI"
 #define METHOD_NAME__PLD        "_PLD"
+#define METHOD_NAME__DSD        "_DSD"
 #define METHOD_NAME__PRS        "_PRS"
 #define METHOD_NAME__PRT        "_PRT"
 #define METHOD_NAME__PRW        "_PRW"
-- 
1.7.10

