Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216AbaG3EVM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 00:21:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:39187 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859AbaG3EVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 00:21:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,762,1400050800"; 
   d="scan'208";a="551067865"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Bob Moore <robert.moore@intel.com>
Subject: [PATCH 03/17] ACPICA: Disassembler: Add support for the ToUUID opererator (macro).
Date: Wed, 30 Jul 2014 12:20:39 +0800
Message-Id: <e6e433b1966af86832e4814072661f34d70810bf.1406689494.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1406689493.git.lv.zheng@intel.com>
References: <cover.1406689493.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Moore <robert.moore@intel.com>

This change adds support to disassemble a UUID back to the original
ToUUID operator. It will detect a UUID within a standard AML Buffer.
Also, a description of the UUID is emitted for "known" UUIDs, defined
as UUIDs that are defined in the ACPI specification.

Since this is a change for disassembler which is not shipped in the
Linux kernel, the Linux kernel is not affected.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 drivers/acpi/acpica/aclocal.h |   13 +++++++------
 include/acpi/acconfig.h       |   18 ++++++++++++++++++
 2 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/acpica/aclocal.h b/drivers/acpi/acpica/aclocal.h
index 91f801a..4c9fd7c 100644
--- a/drivers/acpi/acpica/aclocal.h
+++ b/drivers/acpi/acpica/aclocal.h
@@ -730,12 +730,13 @@ union acpi_parse_value {
 #define ACPI_DASM_STRING                0x02	/* Buffer is a ASCII string */
 #define ACPI_DASM_UNICODE               0x03	/* Buffer is a Unicode string */
 #define ACPI_DASM_PLD_METHOD            0x04	/* Buffer is a _PLD method bit-packed buffer */
-#define ACPI_DASM_EISAID                0x05	/* Integer is an EISAID */
-#define ACPI_DASM_MATCHOP               0x06	/* Parent opcode is a Match() operator */
-#define ACPI_DASM_LNOT_PREFIX           0x07	/* Start of a Lnot_equal (etc.) pair of opcodes */
-#define ACPI_DASM_LNOT_SUFFIX           0x08	/* End  of a Lnot_equal (etc.) pair of opcodes */
-#define ACPI_DASM_HID_STRING            0x09	/* String is a _HID or _CID */
-#define ACPI_DASM_IGNORE                0x0A	/* Not used at this time */
+#define ACPI_DASM_UUID                  0x05	/* Buffer is a UUID/GUID */
+#define ACPI_DASM_EISAID                0x06	/* Integer is an EISAID */
+#define ACPI_DASM_MATCHOP               0x07	/* Parent opcode is a Match() operator */
+#define ACPI_DASM_LNOT_PREFIX           0x08	/* Start of a Lnot_equal (etc.) pair of opcodes */
+#define ACPI_DASM_LNOT_SUFFIX           0x09	/* End  of a Lnot_equal (etc.) pair of opcodes */
+#define ACPI_DASM_HID_STRING            0x0A	/* String is a _HID or _CID */
+#define ACPI_DASM_IGNORE                0x0B	/* Not used at this time */
 
 /*
  * Generic operation (for example:  If, While, Store)
diff --git a/include/acpi/acconfig.h b/include/acpi/acconfig.h
index 932a60d..5a0a3e5 100644
--- a/include/acpi/acconfig.h
+++ b/include/acpi/acconfig.h
@@ -219,6 +219,24 @@
 
 /******************************************************************************
  *
+ * Miscellaneous constants
+ *
+ *****************************************************************************/
+
+/* UUID constants */
+
+#define UUID_BUFFER_LENGTH          16	/* Length of UUID in memory */
+#define UUID_STRING_LENGTH          36	/* Total length of a UUID string */
+
+/* Positions for required hyphens (dashes) in UUID strings */
+
+#define UUID_HYPHEN1_OFFSET         8
+#define UUID_HYPHEN2_OFFSET         13
+#define UUID_HYPHEN3_OFFSET         18
+#define UUID_HYPHEN4_OFFSET         23
+
+/******************************************************************************
+ *
  * ACPI AML Debugger
  *
  *****************************************************************************/
-- 
1.7.10

