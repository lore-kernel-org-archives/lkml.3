Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960AbbAARM4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 12:12:56 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:42944 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbbAARMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 12:12:54 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Robert Moore <robert.moore@intel.com>, Lv Zheng <lv.zheng@intel.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        devel@acpica.org, linux-kernel@vger.kernel.org
Subject: [PATCH] acpi: acpica: utmisc.c:  Remove unused function
Date: Thu,  1 Jan 2015 18:15:54 +0100
Message-Id: <1420132554-32049-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function acpi_ut_is_aml_table() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/acpi/acpica/acutils.h |    2 --
 drivers/acpi/acpica/utmisc.c  |   28 ----------------------------
 2 files changed, 30 deletions(-)

diff --git a/drivers/acpi/acpica/acutils.h b/drivers/acpi/acpica/acutils.h
index 486d342..ec5da45 100644
--- a/drivers/acpi/acpica/acutils.h
+++ b/drivers/acpi/acpica/acutils.h
@@ -570,8 +570,6 @@ const struct acpi_exception_info *acpi_ut_validate_exception(acpi_status
 
 u8 acpi_ut_is_pci_root_bridge(char *id);
 
-u8 acpi_ut_is_aml_table(struct acpi_table_header *table);
-
 acpi_status
 acpi_ut_walk_package_tree(union acpi_operand_object *source_object,
 			  void *target_object,
diff --git a/drivers/acpi/acpica/utmisc.c b/drivers/acpi/acpica/utmisc.c
index 2e2bb14..a9440af 100644
--- a/drivers/acpi/acpica/utmisc.c
+++ b/drivers/acpi/acpica/utmisc.c
@@ -77,34 +77,6 @@ u8 acpi_ut_is_pci_root_bridge(char *id)
 
 /*******************************************************************************
  *
- * FUNCTION:    acpi_ut_is_aml_table
- *
- * PARAMETERS:  table               - An ACPI table
- *
- * RETURN:      TRUE if table contains executable AML; FALSE otherwise
- *
- * DESCRIPTION: Check ACPI Signature for a table that contains AML code.
- *              Currently, these are DSDT,SSDT,PSDT. All other table types are
- *              data tables that do not contain AML code.
- *
- ******************************************************************************/
-
-u8 acpi_ut_is_aml_table(struct acpi_table_header *table)
-{
-
-	/* These are the only tables that contain executable AML */
-
-	if (ACPI_COMPARE_NAME(table->signature, ACPI_SIG_DSDT) ||
-	    ACPI_COMPARE_NAME(table->signature, ACPI_SIG_PSDT) ||
-	    ACPI_COMPARE_NAME(table->signature, ACPI_SIG_SSDT)) {
-		return (TRUE);
-	}
-
-	return (FALSE);
-}
-
-/*******************************************************************************
- *
  * FUNCTION:    acpi_ut_dword_byte_swap
  *
  * PARAMETERS:  value           - Value to be converted
-- 
1.7.10.4

