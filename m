Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228AbbAMSpm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 13:45:42 -0500
Received: from mail-we0-f182.google.com ([74.125.82.182]:56090 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbbAMSpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 13:45:40 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Robert Moore <robert.moore@intel.com>, Lv Zheng <lv.zheng@intel.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        devel@acpica.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ACPICA: tbinstal: Remove unused function
Date: Tue, 13 Jan 2015 19:48:45 +0100
Message-Id: <1421174925-5796-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function acpi_tb_store_table() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/acpi/acpica/actables.h |    5 -----
 drivers/acpi/acpica/tbinstal.c |   37 -------------------------------------
 2 files changed, 42 deletions(-)

diff --git a/drivers/acpi/acpica/actables.h b/drivers/acpi/acpica/actables.h
index 1afe46e..7d65cac 100644
--- a/drivers/acpi/acpica/actables.h
+++ b/drivers/acpi/acpica/actables.h
@@ -119,11 +119,6 @@ acpi_tb_install_standard_table(acpi_physical_address address,
 			       u8 flags,
 			       u8 reload, u8 override, u32 *table_index);
 
-acpi_status
-acpi_tb_store_table(acpi_physical_address address,
-		    struct acpi_table_header *table,
-		    u32 length, u8 flags, u32 *table_index);
-
 void acpi_tb_uninstall_table(struct acpi_table_desc *table_desc);
 
 void acpi_tb_terminate(void);
diff --git a/drivers/acpi/acpica/tbinstal.c b/drivers/acpi/acpica/tbinstal.c
index 755b90c..a998e8c 100644
--- a/drivers/acpi/acpica/tbinstal.c
+++ b/drivers/acpi/acpica/tbinstal.c
@@ -455,43 +455,6 @@ finish_override:
 
 /*******************************************************************************
  *
- * FUNCTION:    acpi_tb_store_table
- *
- * PARAMETERS:  address             - Table address
- *              table               - Table header
- *              length              - Table length
- *              flags               - Install flags
- *              table_index         - Where the table index is returned
- *
- * RETURN:      Status and table index.
- *
- * DESCRIPTION: Add an ACPI table to the global table list
- *
- ******************************************************************************/
-
-acpi_status
-acpi_tb_store_table(acpi_physical_address address,
-		    struct acpi_table_header * table,
-		    u32 length, u8 flags, u32 *table_index)
-{
-	acpi_status status;
-	struct acpi_table_desc *table_desc;
-
-	status = acpi_tb_get_next_root_index(table_index);
-	if (ACPI_FAILURE(status)) {
-		return (status);
-	}
-
-	/* Initialize added table */
-
-	table_desc = &acpi_gbl_root_table_list.tables[*table_index];
-	acpi_tb_init_table_descriptor(table_desc, address, flags, table);
-	table_desc->pointer = table;
-	return (AE_OK);
-}
-
-/*******************************************************************************
- *
  * FUNCTION:    acpi_tb_uninstall_table
  *
  * PARAMETERS:  table_desc          - Table descriptor
-- 
1.7.10.4

