Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677Ab3JKGru (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 02:47:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:61034 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756157Ab3JKGrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 02:47:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1078,1371106800"; 
   d="scan'208";a="415283483"
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: tony.luck@intel.com, bp@alien8.de
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        "Chen, Gong" <gong.chen@linux.intel.com>
Subject: [PATCH 5/8] ACPI, APEI, CPER: Add UEFI 2.4 support for memory error
Date: Fri, 11 Oct 2013 02:32:43 -0400
Message-Id: <1381473166-29303-6-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com>
References: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In latest UEFI spec(by now it is 2.4) memory error definition
for CPER (UEFI 2.4 Appendix N Common Platform Error Record)
adds some new fields. These fields help people to locate
memory error on actual DIMM location.

Original-author: Tony Luck <tony.luck@intel.com>
Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
---
 drivers/acpi/apei/cper.c | 3 ++-
 include/linux/cper.h     | 7 +++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/apei/cper.c b/drivers/acpi/apei/cper.c
index b2e4134..680230c 100644
--- a/drivers/acpi/apei/cper.c
+++ b/drivers/acpi/apei/cper.c
@@ -8,7 +8,7 @@
  * various tables, such as ERST, BERT and HEST etc.
  *
  * For more information about CPER, please refer to Appendix N of UEFI
- * Specification version 2.3.
+ * Specification version 2.4.
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License version
@@ -191,6 +191,7 @@ static const char *cper_mem_err_type_strs[] = {
 	"memory sparing",
 	"scrub corrected error",
 	"scrub uncorrected error",
+	"Physical Memory Map-out event",
 };
 
 static void cper_print_mem(const char *pfx, const struct cper_sec_mem_err *mem)
diff --git a/include/linux/cper.h b/include/linux/cper.h
index c230494..bd01c9a 100644
--- a/include/linux/cper.h
+++ b/include/linux/cper.h
@@ -232,6 +232,9 @@ enum {
 #define CPER_MEM_VALID_RESPONDER_ID		0x1000
 #define CPER_MEM_VALID_TARGET_ID		0x2000
 #define CPER_MEM_VALID_ERROR_TYPE		0x4000
+#define CPER_MEM_VALID_RANK_NUMBER		0x8000
+#define CPER_MEM_VALID_CARD_HANDLE		0x10000
+#define CPER_MEM_VALID_MODULE_HANDLE		0x20000
 
 #define CPER_PCIE_VALID_PORT_TYPE		0x0001
 #define CPER_PCIE_VALID_VERSION			0x0002
@@ -347,6 +350,10 @@ struct cper_sec_mem_err {
 	__u64	responder_id;
 	__u64	target_id;
 	__u8	error_type;
+	__u8	reserved;
+	__u16	rank;
+	__u16	mem_array_handle;
+	__u16	mem_dev_handle;
 };
 
 struct cper_sec_pcie {
-- 
1.8.4.rc3

