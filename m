Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595AbaDRM2r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 08:28:47 -0400
Received: from mail-bn1lp0145.outbound.protection.outlook.com ([207.46.163.145]:22034
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752462AbaDRM2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 08:28:40 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC: Ley Foon Tan <lftan@altera.com>, <lftan.linux@gmail.com>,
        <cltang@codesourcery.com>
Subject: [PATCH 23/28] nios2: Nios2 registers
Date: Fri, 18 Apr 2014 20:27:06 +0800
Message-ID: <1397824031-4892-20-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397824031-4892-1-git-send-email-lftan@altera.com>
References: <1397824031-4892-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.232;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(458001)(189002)(199002)(84676001)(99396002)(36756003)(77982001)(85852003)(77156001)(97736001)(47776003)(20776003)(80976001)(2009001)(87936001)(92566001)(19580395003)(80022001)(19580405001)(89996001)(50986999)(44976005)(88136002)(83072002)(83322001)(6806004)(76176999)(87286001)(2201001)(92726001)(86362001)(93916002)(50466002)(50226001)(4396001)(48376002)(81542001)(74662001)(31966008)(16796002)(74502001)(46102001)(81342001)(76482001)(42186004)(62966002);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2FFO11HUB057;H:SJ-ITEXEDGE02.altera.priv.altera.com;FPR:DC84FDE7.2CD89DC9.4EF1996B.D4FCFA41.20332;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-OriginatorOrg: altera.onmicrosoft.com
X-Forefront-PRVS: 018577E36E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This file contains constants for the instruction macros, cpu registers, fields and bits.

Signed-off-by: Ley Foon Tan <lftan@altera.com>
---
 arch/nios2/include/asm/registers.h | 65 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)
 create mode 100644 arch/nios2/include/asm/registers.h

diff --git a/arch/nios2/include/asm/registers.h b/arch/nios2/include/asm/registers.h
new file mode 100644
index 0000000..0e6ffef08b20e072480ca3780e2626eb3f1de2bd
--- /dev/null
+++ b/arch/nios2/include/asm/registers.h
@@ -0,0 +1,65 @@
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
+#ifndef _ASM_NIOS2_REGISTERS_H
+#define _ASM_NIOS2_REGISTERS_H
+
+/* control register numbers */
+#define CTL_STATUS	0
+#define CTL_ESTATUS	1
+#define CTL_BSTATUS	2
+#define CTL_IENABLE	3
+#define CTL_IPENDING	4
+#define CTL_CPUID	5
+#define CTL_RSV1	6
+#define CTL_EXCEPTION	7
+#define CTL_PTEADDR	8
+#define CTL_TLBACC	9
+#define CTL_TLBMISC	10
+#define CTL_RSV2	11
+#define CTL_BADADDR	12
+#define CTL_CONFIG	13
+#define CTL_MPUBASE	14
+#define CTL_MPUACC	15
+
+/* access control registers using GCC builtins */
+#define RDCTL(r)	__builtin_rdctl(r)
+#define WRCTL(r, v)	__builtin_wrctl(r, v)
+
+/* status register bits */
+#define STATUS_PIE	(1 << 0)	/* processor interrupt enable */
+#define STATUS_U	(1 << 1)	/* user mode */
+#define STATUS_EH	(1 << 2)	/* Exception mode */
+
+/* estatus register bits */
+#define ESTATUS_EPIE	(1 << 0)	/* processor interrupt enable */
+#define ESTATUS_EU	(1 << 1)	/* user mode */
+#define ESTATUS_EH	(1 << 2)	/* Exception mode */
+
+/* tlbmisc register bits */
+#define TLBMISC_PID_SHIFT	4
+#define TLBMISC_PID_MASK	((1UL << cpuinfo.tlb_pid_num_bits) - 1)
+#define TLBMISC_WAY_MASK	0xf
+#define TLBMISC_WAY_SHIFT	20
+
+#define TLBMISC_PID	(TLBMISC_PID_MASK << TLBMISC_PID_SHIFT)	/* TLB PID */
+#define TLBMISC_WE	(1 << 18)	/* TLB write enable */
+#define TLBMISC_RD	(1 << 19)	/* TLB read */
+#define TLBMISC_WAY	(TLBMISC_WAY_MASK << TLBMISC_WAY_SHIFT) /* TLB way */
+
+#endif /* _ASM_NIOS2_REGISTERS_H */
-- 
1.8.3.2

