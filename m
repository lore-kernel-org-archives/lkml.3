Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876AbaIBA12 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 20:27:28 -0400
Received: from mga11.intel.com ([192.55.52.93]:1628 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752585AbaIBA1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 20:27:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,446,1406617200"; 
   d="scan'208";a="584793681"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Hanjun Guo <hanjun.guo@linaro.org>, Bob Moore <robert.moore@intel.com>
Subject: [PATCH 2/6] ACPICA: ACPI 5.1/Disassembler: Add GICC affinity subtable to SRAT table.
Date: Tue,  2 Sep 2014 08:27:12 +0800
Message-Id: <4146d3ca95c7360d4808d36f51e2ba9bba99e332.1409617516.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1409617516.git.lv.zheng@intel.com>
References: <cover.1409617516.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hanjun Guo <hanjun.guo@linaro.org>

Update template for SRAT.
Add clock_domain to standard CPU affinity subtable.

Mostly by Hanjun Guo <hanjun.guo@linaro.org>

Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 include/acpi/actbl1.h |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/include/acpi/actbl1.h b/include/acpi/actbl1.h
index 7626bfe..29e7937 100644
--- a/include/acpi/actbl1.h
+++ b/include/acpi/actbl1.h
@@ -952,7 +952,8 @@ enum acpi_srat_type {
 	ACPI_SRAT_TYPE_CPU_AFFINITY = 0,
 	ACPI_SRAT_TYPE_MEMORY_AFFINITY = 1,
 	ACPI_SRAT_TYPE_X2APIC_CPU_AFFINITY = 2,
-	ACPI_SRAT_TYPE_RESERVED = 3	/* 3 and greater are reserved */
+	ACPI_SRAT_TYPE_GICC_AFFINITY = 3,
+	ACPI_SRAT_TYPE_RESERVED = 4	/* 4 and greater are reserved */
 };
 
 /*
@@ -968,7 +969,7 @@ struct acpi_srat_cpu_affinity {
 	u32 flags;
 	u8 local_sapic_eid;
 	u8 proximity_domain_hi[3];
-	u32 reserved;		/* Reserved, must be zero */
+	u32 clock_domain;
 };
 
 /* Flags */
@@ -1010,6 +1011,20 @@ struct acpi_srat_x2apic_cpu_affinity {
 
 #define ACPI_SRAT_CPU_ENABLED       (1)	/* 00: Use affinity structure */
 
+/* 3: GICC Affinity (ACPI 5.1) */
+
+struct acpi_srat_gicc_affinity {
+	struct acpi_subtable_header header;
+	u32 proximity_domain;
+	u32 acpi_processor_uid;
+	u32 flags;
+	u32 clock_domain;
+};
+
+/* Flags for struct acpi_srat_gicc_affinity */
+
+#define ACPI_SRAT_GICC_ENABLED     (1)	/* 00: Use affinity structure */
+
 /* Reset to default packing */
 
 #pragma pack()
-- 
1.7.10

