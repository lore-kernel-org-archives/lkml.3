Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267Ab3KTOcJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 09:32:09 -0500
Received: from mga11.intel.com ([192.55.52.93]:50950 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860Ab3KTOcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 09:32:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,737,1378882800"; 
   d="scan'208";a="436668189"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        David Cohen <david.a.cohen@intel.com>,
        "linux-gpio @ vger . kernel . org" <linux-gpio@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>,
        Len Brown <lenb@kernel.org>,
        "linux-kernel @ vger . kernel . org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 1/3] sfi: fix compiler warnings
Date: Wed, 20 Nov 2013 16:31:34 +0200
Message-Id: <1384957896-3477-2-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1384957896-3477-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1384957896-3477-1-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the following compiler warnings when build is done by make W=1.

drivers/sfi/sfi_acpi.c:154:5: warning: no previous prototype for ‘sfi_acpi_table_parse’ [-Wmissing-prototypes]

drivers/sfi/sfi_core.c:164:26: warning: no previous prototype for ‘sfi_map_table’ [-Wmissing-prototypes]
drivers/sfi/sfi_core.c:192:6: warning: no previous prototype for ‘sfi_unmap_table’ [-Wmissing-prototypes]

Indentation fixes are also included.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/sfi/sfi_acpi.c   | 8 ++++----
 drivers/sfi/sfi_core.c   | 4 ++--
 include/linux/sfi_acpi.h | 2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/sfi/sfi_acpi.c b/drivers/sfi/sfi_acpi.c
index f5b4ca5..728a2e2 100644
--- a/drivers/sfi/sfi_acpi.c
+++ b/drivers/sfi/sfi_acpi.c
@@ -63,6 +63,7 @@
 #include <acpi/acpi.h>
 
 #include <linux/sfi.h>
+#include <linux/sfi_acpi.h>
 #include "sfi_core.h"
 
 /*
@@ -152,7 +153,7 @@ static void sfi_acpi_put_table(struct acpi_table_header *table)
  * Find specified table in XSDT, run handler on it and return its return value
  */
 int sfi_acpi_table_parse(char *signature, char *oem_id, char *oem_table_id,
-			int(*handler)(struct acpi_table_header *))
+			 int(*handler)(struct acpi_table_header *))
 {
 	struct acpi_table_header *table = NULL;
 	struct sfi_table_key key;
@@ -175,8 +176,8 @@ int sfi_acpi_table_parse(char *signature, char *oem_id, char *oem_table_id,
 }
 
 static ssize_t sfi_acpi_table_show(struct file *filp, struct kobject *kobj,
-			       struct bin_attribute *bin_attr, char *buf,
-			       loff_t offset, size_t count)
+				   struct bin_attribute *bin_attr, char *buf,
+				   loff_t offset, size_t count)
 {
 	struct sfi_table_attr *tbl_attr =
 	    container_of(bin_attr, struct sfi_table_attr, attr);
@@ -199,7 +200,6 @@ static ssize_t sfi_acpi_table_show(struct file *filp, struct kobject *kobj,
 	return cnt;
 }
 
-
 void __init sfi_acpi_sysfs_init(void)
 {
 	u32 tbl_cnt, i;
diff --git a/drivers/sfi/sfi_core.c b/drivers/sfi/sfi_core.c
index 1e824fb..296db7a 100644
--- a/drivers/sfi/sfi_core.c
+++ b/drivers/sfi/sfi_core.c
@@ -161,7 +161,7 @@ static int sfi_verify_table(struct sfi_table_header *table)
  * Check for common case that we can re-use mapping to SYST,
  * which requires syst_pa, syst_va to be initialized.
  */
-struct sfi_table_header *sfi_map_table(u64 pa)
+static struct sfi_table_header *sfi_map_table(u64 pa)
 {
 	struct sfi_table_header *th;
 	u32 length;
@@ -189,7 +189,7 @@ struct sfi_table_header *sfi_map_table(u64 pa)
  * Undoes effect of sfi_map_table() by unmapping table
  * if it did not completely fit on same page as SYST.
  */
-void sfi_unmap_table(struct sfi_table_header *th)
+static void sfi_unmap_table(struct sfi_table_header *th)
 {
 	if (!TABLE_ON_PAGE(syst_va, th, th->len))
 		sfi_unmap_memory(th, TABLE_ON_PAGE(th, th, th->len) ?
diff --git a/include/linux/sfi_acpi.h b/include/linux/sfi_acpi.h
index 631af63..1a88ef6 100644
--- a/include/linux/sfi_acpi.h
+++ b/include/linux/sfi_acpi.h
@@ -60,7 +60,7 @@
 #define _LINUX_SFI_ACPI_H
 
 #ifdef CONFIG_SFI
-#include <acpi/acpi.h>		/* struct acpi_table_header */
+#include <linux/acpi.h>		/* struct acpi_table_header */
 
 extern int sfi_acpi_table_parse(char *signature, char *oem_id,
 				char *oem_table_id,
-- 
1.8.4.3

