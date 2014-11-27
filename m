Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735AbaK0G01 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 01:26:27 -0500
Received: from mga03.intel.com ([134.134.136.65]:43662 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752521AbaK0G0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 01:26:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,467,1413270000"; 
   d="scan'208";a="614826549"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Bob Moore <robert.moore@intel.com>
Subject: [PATCH 3/6] ACPICA: Disassembler: Add support for C-style operators and expressions.
Date: Thu, 27 Nov 2014 14:26:12 +0800
Message-Id: <343281650b3ac8b7354b5293418297012cb74904.1416899966.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1416899966.git.lv.zheng@intel.com>
References: <cover.1416899966.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Moore <robert.moore@intel.com>

Now emit ASL+ code which includes C-style operators.
Optionally, legacy text ASL operators can still be emitted.

This patch only affects compiler/disassembler support which is not in the
Linux kernel.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 drivers/acpi/acpica/acglobal.h |    1 +
 drivers/acpi/acpica/aclocal.h  |    2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/acpi/acpica/acglobal.h b/drivers/acpi/acpica/acglobal.h
index ebf02cc..7f60582 100644
--- a/drivers/acpi/acpica/acglobal.h
+++ b/drivers/acpi/acpica/acglobal.h
@@ -305,6 +305,7 @@ ACPI_INIT_GLOBAL(u8, acpi_gbl_db_output_flags, ACPI_DB_CONSOLE_OUTPUT);
 
 ACPI_INIT_GLOBAL(u8, acpi_gbl_no_resource_disassembly, FALSE);
 ACPI_INIT_GLOBAL(u8, acpi_gbl_ignore_noop_operator, FALSE);
+ACPI_INIT_GLOBAL(u8, acpi_gbl_cstyle_disassembly, TRUE);
 
 ACPI_GLOBAL(u8, acpi_gbl_db_opt_disasm);
 ACPI_GLOBAL(u8, acpi_gbl_db_opt_verbose);
diff --git a/drivers/acpi/acpica/aclocal.h b/drivers/acpi/acpica/aclocal.h
index c00e7e4..1c218d9 100644
--- a/drivers/acpi/acpica/aclocal.h
+++ b/drivers/acpi/acpica/aclocal.h
@@ -722,6 +722,7 @@ union acpi_parse_value {
 	ACPI_DISASM_ONLY_MEMBERS (\
 	u8                              disasm_flags;   /* Used during AML disassembly */\
 	u8                              disasm_opcode;  /* Subtype used for disassembly */\
+	char                            *operator_symbol;/* Used for C-style operator name strings */\
 	char                            aml_op_name[16])	/* Op name (debug only) */
 
 /* Flags for disasm_flags field above */
@@ -827,6 +828,7 @@ struct acpi_parse_state {
 #define ACPI_PARSEOP_EMPTY_TERMLIST     0x04
 #define ACPI_PARSEOP_PREDEF_CHECKED     0x08
 #define ACPI_PARSEOP_SPECIAL            0x10
+#define ACPI_PARSEOP_COMPOUND           0x20
 
 /*****************************************************************************
  *
-- 
1.7.10

