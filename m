Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068AbaG3EWI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 00:22:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:39356 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728AbaG3EWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 00:22:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,762,1400050800"; 
   d="scan'208";a="580994593"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>,
        Hanjun Guo <hanjun.guo@linaro.org>, Bob Moore <robert.moore@intel.com>
Subject: [PATCH 14/17] ACPICA/ARM: ACPI 5.1: Update for MADT changes.
Date: Wed, 30 Jul 2014 12:21:50 +0800
Message-Id: <8af3474e252b02a86e882775c675699eea1468bd.1406689494.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1406689493.git.lv.zheng@intel.com>
References: <cover.1406689493.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomasz Nowicki <tomasz.nowicki@linaro.org>

New subtables and changes to other subtables. Tomasz Nowicki.
tomasz.nowicki@linaro.org

Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 include/acpi/actbl1.h |   44 +++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 41 insertions(+), 3 deletions(-)

diff --git a/include/acpi/actbl1.h b/include/acpi/actbl1.h
index 9613e8e..7626bfe 100644
--- a/include/acpi/actbl1.h
+++ b/include/acpi/actbl1.h
@@ -671,7 +671,9 @@ enum acpi_madt_type {
 	ACPI_MADT_TYPE_LOCAL_X2APIC_NMI = 10,
 	ACPI_MADT_TYPE_GENERIC_INTERRUPT = 11,
 	ACPI_MADT_TYPE_GENERIC_DISTRIBUTOR = 12,
-	ACPI_MADT_TYPE_RESERVED = 13	/* 13 and greater are reserved */
+	ACPI_MADT_TYPE_GENERIC_MSI_FRAME = 13,
+	ACPI_MADT_TYPE_GENERIC_REDISTRIBUTOR = 14,
+	ACPI_MADT_TYPE_RESERVED = 15	/* 15 and greater are reserved */
 };
 
 /*
@@ -797,15 +799,26 @@ struct acpi_madt_local_x2apic_nmi {
 struct acpi_madt_generic_interrupt {
 	struct acpi_subtable_header header;
 	u16 reserved;		/* reserved - must be zero */
-	u32 gic_id;
+	u32 cpu_interface_number;
 	u32 uid;
 	u32 flags;
 	u32 parking_version;
 	u32 performance_interrupt;
 	u64 parked_address;
 	u64 base_address;
+	u64 gicv_base_address;
+	u64 gich_base_address;
+	u32 vgic_interrupt;
+	u64 gicr_base_address;
+	u64 arm_mpidr;
 };
 
+/* Masks for Flags field above */
+
+/* ACPI_MADT_ENABLED                    (1)      Processor is usable if set */
+#define ACPI_MADT_PERFORMANCE_IRQ_MODE  (1<<1)	/* 01: Performance Interrupt Mode */
+#define ACPI_MADT_VGIC_IRQ_MODE         (1<<2)	/* 02: VGIC Maintenance Interrupt mode */
+
 /* 12: Generic Distributor (ACPI 5.0) */
 
 struct acpi_madt_generic_distributor {
@@ -817,11 +830,36 @@ struct acpi_madt_generic_distributor {
 	u32 reserved2;		/* reserved - must be zero */
 };
 
+/* 13: Generic MSI Frame (ACPI 5.1) */
+
+struct acpi_madt_generic_msi_frame {
+	struct acpi_subtable_header header;
+	u16 reserved;		/* reserved - must be zero */
+	u32 msi_frame_id;
+	u64 base_address;
+	u32 flags;
+	u16 spi_count;
+	u16 spi_base;
+};
+
+/* Masks for Flags field above */
+
+#define ACPI_MADT_OVERRIDE_SPI_VALUES   (1)
+
+/* 14: Generic Redistributor (ACPI 5.1) */
+
+struct acpi_madt_generic_redistributor {
+	struct acpi_subtable_header header;
+	u16 reserved;		/* reserved - must be zero */
+	u64 base_address;
+	u32 length;
+};
+
 /*
  * Common flags fields for MADT subtables
  */
 
-/* MADT Local APIC flags (lapic_flags) and GIC flags */
+/* MADT Local APIC flags */
 
 #define ACPI_MADT_ENABLED           (1)	/* 00: Processor is usable if set */
 
-- 
1.7.10

