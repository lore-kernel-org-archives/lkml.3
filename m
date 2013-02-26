Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759841Ab3BZEOZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 23:14:25 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:42151 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759712Ab3BZENz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 23:13:55 -0500
X-IronPort-AV: E=Sophos;i="4.84,737,1355068800"; 
   d="scan'208";a="6768934"
From: liguang <lig.fnst@cn.fujitsu.com>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net, namhyung@kernel.org, jolsa@redhat.com,
        penberg@kernel.org, linux-kernel@vger.kernel.org
Cc: liguang <lig.fnst@cn.fujitsu.com>
Subject: [PATCH 3/3] perf: add dwarf regs map for mips
Date: Tue, 26 Feb 2013 12:12:54 +0800
Message-Id: <1361851974-25307-3-git-send-email-lig.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1361851974-25307-1-git-send-email-lig.fnst@cn.fujitsu.com>
References: <1361851974-25307-1-git-send-email-lig.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/26 12:13:04,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/26 12:13:04,
	Serialize complete at 2013/02/26 12:13:04
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
---
 tools/perf/arch/mips/Makefile          |    4 +++
 tools/perf/arch/mips/util/dwarf-regs.c |   33 ++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/arch/mips/Makefile
 create mode 100644 tools/perf/arch/mips/util/dwarf-regs.c

diff --git a/tools/perf/arch/mips/Makefile b/tools/perf/arch/mips/Makefile
new file mode 100644
index 0000000..15130b5
--- /dev/null
+++ b/tools/perf/arch/mips/Makefile
@@ -0,0 +1,4 @@
+ifndef NO_DWARF
+PERF_HAVE_DWARF_REGS := 1
+LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
+endif
diff --git a/tools/perf/arch/mips/util/dwarf-regs.c b/tools/perf/arch/mips/util/dwarf-regs.c
new file mode 100644
index 0000000..4871489
--- /dev/null
+++ b/tools/perf/arch/mips/util/dwarf-regs.c
@@ -0,0 +1,33 @@
+/*
+ * Mapping of DWARF debug register numbers into register names.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include <libio.h>
+#include <dwarf-regs.h>
+
+#define MIPS_MAX_REGS	32
+
+const char *mips_regs_table[MIPS_MAX_REGS] = {
+	"zero", "at", "v0", "v1", "a0", "a1", "a2", "a3",
+	"t0", "t1", "t2", "t3", "t4", "t5", "t6", "t7",
+	"s0", "s1", "s2", "s3", "s4", "s5", "s6", "s7",
+	"t8", "t9", "k0", "k1", "gp", "sp", "fp", "ra",
+};
+
+/**
+ * get_arch_regstr() - lookup register name from it's DWARF register number
+ * @n:	the DWARF register number
+ *
+ * get_arch_regstr() returns the name of the register in struct
+ * regdwarfnum_table from it's DWARF register number. If the register is not
+ * found in the table, this returns NULL;
+ */
+const char *get_arch_regstr(unsigned int n)
+{
+	return (n <= MIPS_MAX_REGS) ? mips_regs_table[n] : NULL;
+}
-- 
1.7.2.5

