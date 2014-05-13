Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759753AbaEMJDd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:03:33 -0400
Received: from mail-bn1lp0145.outbound.protection.outlook.com ([207.46.163.145]:40298
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759686AbaEMJDL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:03:11 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Ley Foon Tan <lftan@altera.com>, <lftan.linux@gmail.com>,
        <cltang@codesourcery.com>, Mark Salter <msalter@redhat.com>,
        "Aurelien Jacquiot" <a-jacquiot@ti.com>, <linux-c6x-dev@linux-c6x.org>
Subject: [PATCH 06/25] c6x: Add 32 bit time_t and clock_t
Date: Tue, 13 May 2014 17:03:01 +0800
Message-ID: <1399971781-4190-1-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399971456-3941-1-git-send-email-lftan@altera.com>
References: <1399971456-3941-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.232;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(979002)(6009001)(189002)(199002)(6806004)(77156001)(74662001)(2009001)(76482001)(92726001)(44976005)(92566001)(48376002)(42186004)(46102001)(80022001)(47776003)(20776003)(50466002)(93916002)(36756003)(86362001)(81342001)(4396001)(83322001)(77982001)(74502001)(81542001)(88136002)(97736001)(84676001)(62966002)(87936001)(87286001)(50226001)(19580395003)(83072002)(85852003)(19580405001)(99396002)(89996001)(50986999)(33646001)(16796002)(31966008)(76176999)(102836001)(79102001)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2FFO11HUB049;H:SJ-ITEXEDGE02.altera.priv.altera.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
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
 arch/c6x/include/asm/Kbuild             |  1 -
 arch/c6x/include/uapi/asm/Kbuild        |  1 +
 arch/c6x/include/uapi/asm/posix_types.h | 17 +++++++++++++++++
 3 files changed, 18 insertions(+), 1 deletion(-)
 create mode 100644 arch/c6x/include/uapi/asm/posix_types.h

diff --git a/arch/c6x/include/asm/Kbuild b/arch/c6x/include/asm/Kbuild
index 8dbdce8..cf7bd2e 100644
--- a/arch/c6x/include/asm/Kbuild
+++ b/arch/c6x/include/asm/Kbuild
@@ -35,7 +35,6 @@ generic-y += pci.h
 generic-y += percpu.h
 generic-y += pgalloc.h
 generic-y += poll.h
-generic-y += posix_types.h
 generic-y += preempt.h
 generic-y += resource.h
 generic-y += scatterlist.h
diff --git a/arch/c6x/include/uapi/asm/Kbuild b/arch/c6x/include/uapi/asm/Kbuild
index e9bc2b2..7435d6c 100644
--- a/arch/c6x/include/uapi/asm/Kbuild
+++ b/arch/c6x/include/uapi/asm/Kbuild
@@ -5,6 +5,7 @@ generic-y += kvm_para.h
 
 header-y += byteorder.h
 header-y += kvm_para.h
+header-y += posix_types.h
 header-y += ptrace.h
 header-y += setup.h
 header-y += sigcontext.h
diff --git a/arch/c6x/include/uapi/asm/posix_types.h b/arch/c6x/include/uapi/asm/posix_types.h
new file mode 100644
index 0000000..dbad459
--- /dev/null
+++ b/arch/c6x/include/uapi/asm/posix_types.h
@@ -0,0 +1,17 @@
+#ifndef __ARCH_C6X_POSIX_TYPES_H
+#define __ARCH_C6X_POSIX_TYPES_H
+
+/*
+ * This file is generally used by user-level software, so you need to
+ * be a little careful about namespace pollution etc. Also, we cannot
+ * assume GCC is being used.
+ */
+typedef long		__kernel_time_t;
+#define __kernel_time_t __kernel_time_t
+
+typedef long		__kernel_clock_t;
+#define __kernel_clock_t __kernel_clock_t
+
+#include <asm-generic/posix_types.h>
+
+#endif
-- 
1.8.2.1

