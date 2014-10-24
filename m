Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048AbaJXIca (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 04:32:30 -0400
Received: from mail-bn1on0092.outbound.protection.outlook.com ([157.56.110.92]:38624
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932608AbaJXIZw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 04:25:52 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, Ley Foon Tan <lftan@altera.com>,
        <lftan.linux@gmail.com>, <cltang@codesourcery.com>
Subject: [PATCH v5 16/29] nios2: ELF definitions
Date: Fri, 24 Oct 2014 16:24:18 +0800
Message-ID: <1414139071-3818-17-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1414139071-3818-1-git-send-email-lftan@altera.com>
References: <1414139071-3818-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(189002)(199003)(15975445006)(102836001)(84676001)(31966008)(62966002)(19580395003)(104166001)(87286001)(76482002)(89996001)(87936001)(88136002)(120916001)(99396003)(77156001)(36756003)(15202345003)(20776003)(21056001)(50986999)(48376002)(47776003)(93916002)(86362001)(92726001)(2201001)(92566001)(64706001)(50466002)(80022003)(106466001)(229853001)(85852003)(76176999)(33646002)(95666004)(77096002)(44976005)(19580405001)(68736004)(6806004)(107046002)(46102003)(85306004)(105596002)(97736003)(42186005)(4396001)(50226001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB1022;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB1022;
X-Forefront-PRVS: 0374433C81
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=lftan@altera.com; 
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds definitions for the ELF format

Signed-off-by: Ley Foon Tan <lftan@altera.com>
---
 arch/nios2/include/asm/elf.h      | 101 ++++++++++++++++++++++++++++++++++++++
 arch/nios2/include/uapi/asm/elf.h |  67 +++++++++++++++++++++++++
 2 files changed, 168 insertions(+)
 create mode 100644 arch/nios2/include/asm/elf.h
 create mode 100644 arch/nios2/include/uapi/asm/elf.h

diff --git a/arch/nios2/include/asm/elf.h b/arch/nios2/include/asm/elf.h
new file mode 100644
index 0000000..b7d655d
--- /dev/null
+++ b/arch/nios2/include/asm/elf.h
@@ -0,0 +1,101 @@
+/*
+ * Copyright (C) 2011 Tobias Klauser <tklauser@distanz.ch>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ */
+
+#ifndef _ASM_NIOS2_ELF_H
+#define _ASM_NIOS2_ELF_H
+
+#include <uapi/asm/elf.h>
+
+/*
+ * This is used to ensure we don't load something for the wrong architecture.
+ */
+#define elf_check_arch(x) ((x)->e_machine == EM_ALTERA_NIOS2)
+
+#define ELF_PLAT_INIT(_r, load_addr)
+
+#define CORE_DUMP_USE_REGSET
+#define ELF_EXEC_PAGESIZE	4096
+
+/* This is the location that an ET_DYN program is loaded if exec'ed.  Typical
+   use of this is to invoke "./ld.so someprog" to test out a new version of
+   the loader.  We need to make sure that it is out of the way of the program
+   that it will "exec", and that there is sufficient room for the brk.  */
+
+#define ELF_ET_DYN_BASE		0xD0000000UL
+
+/* regs is struct pt_regs, pr_reg is elf_gregset_t (which is
+   now struct_user_regs, they are different) */
+
+#define ARCH_HAS_SETUP_ADDITIONAL_PAGES	1
+struct linux_binprm;
+extern int arch_setup_additional_pages(struct linux_binprm *bprm,
+	int uses_interp);
+#define ELF_CORE_COPY_REGS(pr_reg, regs)				\
+{ do {									\
+	/* Bleech. */							\
+	pr_reg[0]  = regs->r8;						\
+	pr_reg[1]  = regs->r9;						\
+	pr_reg[2]  = regs->r10;						\
+	pr_reg[3]  = regs->r11;						\
+	pr_reg[4]  = regs->r12;						\
+	pr_reg[5]  = regs->r13;						\
+	pr_reg[6]  = regs->r14;						\
+	pr_reg[7]  = regs->r15;						\
+	pr_reg[8]  = regs->r1;						\
+	pr_reg[9]  = regs->r2;						\
+	pr_reg[10] = regs->r3;						\
+	pr_reg[11] = regs->r4;						\
+	pr_reg[12] = regs->r5;						\
+	pr_reg[13] = regs->r6;						\
+	pr_reg[14] = regs->r7;						\
+	pr_reg[15] = regs->orig_r2;					\
+	pr_reg[16] = regs->ra;						\
+	pr_reg[17] = regs->fp;						\
+	pr_reg[18] = regs->sp;						\
+	pr_reg[19] = regs->gp;						\
+	pr_reg[20] = regs->estatus;					\
+	pr_reg[21] = regs->ea;						\
+	pr_reg[22] = regs->orig_r7;					\
+	{								\
+		struct switch_stack *sw = ((struct switch_stack *)regs) - 1; \
+		pr_reg[23] = sw->r16;					\
+		pr_reg[24] = sw->r17;					\
+		pr_reg[25] = sw->r18;					\
+		pr_reg[26] = sw->r19;					\
+		pr_reg[27] = sw->r20;					\
+		pr_reg[28] = sw->r21;					\
+		pr_reg[29] = sw->r22;					\
+		pr_reg[30] = sw->r23;					\
+		pr_reg[31] = sw->fp;					\
+		pr_reg[32] = sw->gp;					\
+		pr_reg[33] = sw->ra;					\
+	}								\
+} while (0); }
+
+/* This yields a mask that user programs can use to figure out what
+   instruction set this cpu supports.  */
+
+#define ELF_HWCAP	(0)
+
+/* This yields a string that ld.so will use to load implementation
+   specific libraries for optimization.  This is more specific in
+   intent than poking at uname or /proc/cpuinfo.  */
+
+#define ELF_PLATFORM  (NULL)
+
+#endif /* _ASM_NIOS2_ELF_H */
diff --git a/arch/nios2/include/uapi/asm/elf.h b/arch/nios2/include/uapi/asm/elf.h
new file mode 100644
index 0000000..a5b91ae
--- /dev/null
+++ b/arch/nios2/include/uapi/asm/elf.h
@@ -0,0 +1,67 @@
+/*
+ * Copyright (C) 2011 Tobias Klauser <tklauser@distanz.ch>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ */
+
+
+#ifndef _UAPI_ASM_NIOS2_ELF_H
+#define _UAPI_ASM_NIOS2_ELF_H
+
+#include <linux/ptrace.h>
+
+/* Relocation types */
+#define R_NIOS2_NONE		0
+#define R_NIOS2_S16		1
+#define R_NIOS2_U16		2
+#define R_NIOS2_PCREL16		3
+#define R_NIOS2_CALL26		4
+#define R_NIOS2_IMM5		5
+#define R_NIOS2_CACHE_OPX	6
+#define R_NIOS2_IMM6		7
+#define R_NIOS2_IMM8		8
+#define R_NIOS2_HI16		9
+#define R_NIOS2_LO16		10
+#define R_NIOS2_HIADJ16		11
+#define R_NIOS2_BFD_RELOC_32	12
+#define R_NIOS2_BFD_RELOC_16	13
+#define R_NIOS2_BFD_RELOC_8	14
+#define R_NIOS2_GPREL		15
+#define R_NIOS2_GNU_VTINHERIT	16
+#define R_NIOS2_GNU_VTENTRY	17
+#define R_NIOS2_UJMP		18
+#define R_NIOS2_CJMP		19
+#define R_NIOS2_CALLR		20
+#define R_NIOS2_ALIGN		21
+/* Keep this the last entry.  */
+#define R_NIOS2_NUM		22
+
+typedef unsigned long elf_greg_t;
+
+#define ELF_NGREG	\
+	((sizeof(struct pt_regs) + sizeof(struct switch_stack)) /	\
+		sizeof(elf_greg_t))
+typedef elf_greg_t elf_gregset_t[ELF_NGREG];
+
+typedef unsigned long elf_fpregset_t;
+
+/*
+ * These are used to set parameters in the core dumps.
+ */
+#define ELF_CLASS	ELFCLASS32
+#define ELF_DATA	ELFDATA2LSB
+#define ELF_ARCH	EM_ALTERA_NIOS2
+
+#endif /* _UAPI_ASM_NIOS2_ELF_H */
-- 
1.8.2.1

