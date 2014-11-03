Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863AbaKCK56 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 05:57:58 -0500
Received: from mail-by2on0089.outbound.protection.outlook.com ([207.46.100.89]:30894
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751278AbaKCKzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 05:55:03 -0500
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, Ley Foon Tan <lftan@altera.com>,
        <lftan.linux@gmail.com>, <cltang@codesourcery.com>
Subject: [PATCH v6 24/29] nios2: Nios2 registers
Date: Mon, 3 Nov 2014 18:52:20 +0800
Message-ID: <1415011945-3297-25-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1415011945-3297-1-git-send-email-lftan@altera.com>
References: <1415011945-3297-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(189002)(199003)(86362001)(76176999)(47776003)(50986999)(4396001)(19580395003)(84676001)(92566001)(2201001)(92726001)(42186005)(20776003)(64706001)(120916001)(62966003)(50466002)(99396003)(93916002)(15975445006)(50226001)(104166001)(89996001)(88136002)(33646002)(48376002)(46102003)(97736003)(44976005)(68736004)(87936001)(36756003)(31966008)(87286001)(105596002)(15202345003)(6806004)(19580405001)(107046002)(102836001)(229853001)(106466001)(21056001)(77156002)(77096003)(95666004);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB596;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB596;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0384275935
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=lftan@altera.com; 
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This file contains constants for the instruction macros, cpu registers,
fields and bits.

Signed-off-by: Ley Foon Tan <lftan@altera.com>
---
 arch/nios2/include/asm/registers.h | 71 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 71 insertions(+)
 create mode 100644 arch/nios2/include/asm/registers.h

diff --git a/arch/nios2/include/asm/registers.h b/arch/nios2/include/asm/registers.h
new file mode 100644
index 0000000..615bce1
--- /dev/null
+++ b/arch/nios2/include/asm/registers.h
@@ -0,0 +1,71 @@
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
+#ifndef __ASSEMBLY__
+#include <asm/cpuinfo.h>
+#endif
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
+#ifndef __ASSEMBLY__
+#define TLBMISC_PID_MASK	((1UL << cpuinfo.tlb_pid_num_bits) - 1)
+#endif
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
1.8.2.1

