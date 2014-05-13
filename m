Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162AbaEMJDq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:03:46 -0400
Received: from mail-by2on0118.outbound.protection.outlook.com ([207.46.100.118]:4245
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759765AbaEMJDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:03:42 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Ley Foon Tan <lftan@altera.com>, <lftan.linux@gmail.com>,
        <cltang@codesourcery.com>, Richard Kuo <rkuo@codeaurora.org>,
        <linux-hexagon@vger.kernel.org>
Subject: [PATCH 09/25] hexagon: Add 32 bit time_t and clock_t
Date: Tue, 13 May 2014 17:03:29 +0800
Message-ID: <1399971809-4300-1-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399971456-3941-1-git-send-email-lftan@altera.com>
References: <1399971456-3941-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.232;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(199002)(189002)(92566001)(83072002)(84676001)(87286001)(50466002)(74502001)(77156001)(86362001)(2009001)(76482001)(87936001)(77982001)(48376002)(76176999)(36756003)(89996001)(102836001)(20776003)(85852003)(33646001)(92726001)(50986999)(47776003)(6806004)(46102001)(44976005)(31966008)(19580405001)(83322001)(19580395003)(16796002)(81542001)(74662001)(80022001)(4396001)(81342001)(50226001)(79102001)(62966002);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2FFO11HUB044;H:SJ-ITEXEDGE02.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: altera.onmicrosoft.com
X-Forefront-PRVS: 0210479ED8
Authentication-Results: spf=softfail (sender IP is 66.35.236.232)
 smtp.mailfrom=lftan@altera.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Override time_t and clock_t in include/uapi/asm-generic.

Signed-off-by: Ley Foon Tan <lftan@altera.com>
---
 arch/hexagon/include/asm/Kbuild             |  1 -
 arch/hexagon/include/uapi/asm/Kbuild        |  1 +
 arch/hexagon/include/uapi/asm/posix_types.h | 17 +++++++++++++++++
 3 files changed, 18 insertions(+), 1 deletion(-)
 create mode 100644 arch/hexagon/include/uapi/asm/posix_types.h

diff --git a/arch/hexagon/include/asm/Kbuild b/arch/hexagon/include/asm/Kbuild
index 0e69796..fbceaf8 100644
--- a/arch/hexagon/include/asm/Kbuild
+++ b/arch/hexagon/include/asm/Kbuild
@@ -33,7 +33,6 @@ generic-y += msgbuf.h
 generic-y += pci.h
 generic-y += percpu.h
 generic-y += poll.h
-generic-y += posix_types.h
 generic-y += preempt.h
 generic-y += resource.h
 generic-y += rwsem.h
diff --git a/arch/hexagon/include/uapi/asm/Kbuild b/arch/hexagon/include/uapi/asm/Kbuild
index c31706c..336a2d0 100644
--- a/arch/hexagon/include/uapi/asm/Kbuild
+++ b/arch/hexagon/include/uapi/asm/Kbuild
@@ -5,6 +5,7 @@ header-y += bitsperlong.h
 header-y += byteorder.h
 header-y += kvm_para.h
 header-y += param.h
+header-y += posix_types.h
 header-y += ptrace.h
 header-y += registers.h
 header-y += setup.h
diff --git a/arch/hexagon/include/uapi/asm/posix_types.h b/arch/hexagon/include/uapi/asm/posix_types.h
new file mode 100644
index 0000000..01e6b1c
--- /dev/null
+++ b/arch/hexagon/include/uapi/asm/posix_types.h
@@ -0,0 +1,17 @@
+#ifndef __ARCH_HEXAGON_POSIX_TYPES_H
+#define __ARCH_HEXAGON_POSIX_TYPES_H
+
+/*
+ * This file is generally used by user-level software, so you need to
+ * be a little careful about namespace pollution etc. Also, we cannot
+ * assume GCC is being used.
+ */
+typedef long	__kernel_time_t;
+#define __kernel_time_t __kernel_time_t
+
+typedef long	__kernel_clock_t;
+#define __kernel_clock_t __kernel_clock_t
+
+#include <asm-generic/posix_types.h>
+
+#endif
-- 
1.8.2.1

