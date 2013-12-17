Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab3LQJYf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 04:24:35 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:32797 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab3LQJYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 04:24:32 -0500
Date: Tue, 17 Dec 2013 14:54:21 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Robert Moore <robert.moore@intel.com>, Lv Zheng <lv.zheng@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        devel@acpica.org, josh@joshtriplett.org
Subject: [PATCH 06/11] drivers: acpi: Add appropriate ifdef conditions in
 exdump.c
Message-ID: <150a5858e78dc6eabfa11b5d52ce97998b807225.1387271324.git.rashika.kheria@gmail.com>
References: <c676af6619fc5a84208740bfc7edcf56bb78ed4e.1387271324.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c676af6619fc5a84208740bfc7edcf56bb78ed4e.1387271324.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enclose functions acpi_ex_dump_namespace_node() and
acpi_ex_dump_object_descriptor() in appropriate ifdef condition of
ACPI_FUTURE_USAGE in file acpica/exdump.c.

This eliminates the following warnings in exdump.c:
drivers/acpi/acpica/exdump.c:809:6: warning: no previous prototype for ‘acpi_ex_dump_namespace_node’ [-Wmissing-prototypes]
drivers/acpi/acpica/exdump.c:995:1: warning: no previous prototype for ‘acpi_ex_dump_object_descriptor’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/acpi/acpica/exdump.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/acpi/acpica/exdump.c b/drivers/acpi/acpica/exdump.c
index 4d046fa..3cd2817 100644
--- a/drivers/acpi/acpica/exdump.c
+++ b/drivers/acpi/acpica/exdump.c
@@ -54,6 +54,7 @@ ACPI_MODULE_NAME("exdump")
  * The following routines are used for debug output only
  */
 #if defined(ACPI_DEBUG_OUTPUT) || defined(ACPI_DEBUGGER)
+#ifdef  ACPI_FUTURE_USAGE
 /* Local prototypes */
 static void acpi_ex_out_string(char *title, char *value);
 
@@ -68,6 +69,7 @@ static void acpi_ex_dump_reference_obj(union acpi_operand_object *obj_desc);
 static void
 acpi_ex_dump_package_obj(union acpi_operand_object *obj_desc,
 			 u32 level, u32 index);
+#endif
 
 /*******************************************************************************
  *
@@ -210,6 +212,7 @@ static struct acpi_exdump_info acpi_ex_dump_bank_field[5] = {
 	{ACPI_EXD_POINTER, ACPI_EXD_OFFSET(bank_field.bank_obj), "Bank Object"}
 };
 
+#ifdef  ACPI_FUTURE_USAGE
 static struct acpi_exdump_info acpi_ex_dump_index_field[5] = {
 	{ACPI_EXD_INIT, ACPI_EXD_TABLE_SIZE(acpi_ex_dump_bank_field), NULL},
 	{ACPI_EXD_FIELD, 0, NULL},
@@ -218,6 +221,7 @@ static struct acpi_exdump_info acpi_ex_dump_index_field[5] = {
 	 "Index Object"},
 	{ACPI_EXD_POINTER, ACPI_EXD_OFFSET(index_field.data_obj), "Data Object"}
 };
+#endif
 
 static struct acpi_exdump_info acpi_ex_dump_reference[8] = {
 	{ACPI_EXD_INIT, ACPI_EXD_TABLE_SIZE(acpi_ex_dump_reference), NULL},
@@ -287,6 +291,7 @@ static struct acpi_exdump_info acpi_ex_dump_node[5] = {
 
 /* Dispatch table, indexed by object type */
 
+#ifdef  ACPI_FUTURE_USAGE
 static struct acpi_exdump_info *acpi_ex_dump_info[] = {
 	NULL,
 	acpi_ex_dump_integer,
@@ -444,6 +449,7 @@ acpi_ex_dump_object(union acpi_operand_object *obj_desc,
 		count--;
 	}
 }
+#endif
 
 /*******************************************************************************
  *
@@ -785,6 +791,7 @@ acpi_ex_dump_operands(union acpi_operand_object **operands,
  *
  ******************************************************************************/
 
+#ifdef  ACPI_FUTURE_USAGE
 static void acpi_ex_out_string(char *title, char *value)
 {
 	acpi_os_printf("%20s : %s\n", title, value);
@@ -1042,5 +1049,6 @@ acpi_ex_dump_object_descriptor(union acpi_operand_object *obj_desc, u32 flags)
 	acpi_ex_dump_object(obj_desc, acpi_ex_dump_info[obj_desc->common.type]);
 	return_VOID;
 }
+#endif
 
 #endif
-- 
1.7.9.5

