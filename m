Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191AbaG3EV7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 00:21:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:39334 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755145AbaG3EV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 00:21:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,762,1400050800"; 
   d="scan'208";a="551068182"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Hanjun Guo <hanjun.guo@linaro.org>, Bob Moore <robert.moore@intel.com>
Subject: [PATCH 13/17] ACPICA/ARM: ACPI 5.1: Update for FADT changes.
Date: Wed, 30 Jul 2014 12:21:43 +0800
Message-Id: <856d166e85fa39e9110b85aaf2e742d055c7375e.1406689494.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1406689493.git.lv.zheng@intel.com>
References: <cover.1406689493.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graeme Gregory <graeme.gregory@linaro.org>

Adds ARM flags and FADT minor revision. Graeme Gregory.
graeme.gregory@linaro.org

Signed-off-by: Graeme Gregory <graeme.gregory@linaro.org>
Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 include/acpi/actbl.h |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/include/acpi/actbl.h b/include/acpi/actbl.h
index 1cc7ef1..bee19d8 100644
--- a/include/acpi/actbl.h
+++ b/include/acpi/actbl.h
@@ -270,7 +270,8 @@ struct acpi_table_fadt {
 	u32 flags;		/* Miscellaneous flag bits (see below for individual flags) */
 	struct acpi_generic_address reset_register;	/* 64-bit address of the Reset register */
 	u8 reset_value;		/* Value to write to the reset_register port to reset the system */
-	u8 reserved4[3];	/* Reserved, must be zero */
+	u16 arm_boot_flags;	/* ARM-Specific Boot Flags (see below for individual flags) (ACPI 5.1) */
+	u8 minor_revision;	/* FADT Minor Revision (ACPI 5.1) */
 	u64 Xfacs;		/* 64-bit physical address of FACS */
 	u64 Xdsdt;		/* 64-bit physical address of DSDT */
 	struct acpi_generic_address xpm1a_event_block;	/* 64-bit Extended Power Mgt 1a Event Reg Blk address */
@@ -285,7 +286,7 @@ struct acpi_table_fadt {
 	struct acpi_generic_address sleep_status;	/* 64-bit Sleep Status register (ACPI 5.0) */
 };
 
-/* Masks for FADT Boot Architecture Flags (boot_flags) [Vx]=Introduced in this FADT revision */
+/* Masks for FADT IA-PC Boot Architecture Flags (boot_flags) [Vx]=Introduced in this FADT revision */
 
 #define ACPI_FADT_LEGACY_DEVICES    (1)  	/* 00: [V2] System has LPC or ISA bus devices */
 #define ACPI_FADT_8042              (1<<1)	/* 01: [V3] System has an 8042 controller on port 60/64 */
@@ -296,6 +297,11 @@ struct acpi_table_fadt {
 
 #define FADT2_REVISION_ID               3
 
+/* Masks for FADT ARM Boot Architecture Flags (arm_boot_flags) ACPI 5.1 */
+
+#define ACPI_FADT_PSCI_COMPLIANT    (1)	/* 00: [V5+] PSCI 0.2+ is implemented */
+#define ACPI_FADT_PSCI_USE_HVC      (1<<1)	/* 01: [V5+] HVC must be used instead of SMC as the PSCI conduit */
+
 /* Masks for FADT flags */
 
 #define ACPI_FADT_WBINVD            (1)	/* 00: [V1] The WBINVD instruction works properly */
@@ -399,7 +405,7 @@ struct acpi_table_desc {
  *     FADT V5  size: 0x10C
  */
 #define ACPI_FADT_V1_SIZE       (u32) (ACPI_FADT_OFFSET (flags) + 4)
-#define ACPI_FADT_V2_SIZE       (u32) (ACPI_FADT_OFFSET (reserved4[0]) + 3)
+#define ACPI_FADT_V2_SIZE       (u32) (ACPI_FADT_OFFSET (minor_revision) + 1)
 #define ACPI_FADT_V3_SIZE       (u32) (ACPI_FADT_OFFSET (sleep_control))
 #define ACPI_FADT_V5_SIZE       (u32) (sizeof (struct acpi_table_fadt))
 
-- 
1.7.10

