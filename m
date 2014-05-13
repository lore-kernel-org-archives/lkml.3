Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932590AbaEMJF1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:05:27 -0400
Received: from mail-bn1on0130.outbound.protection.outlook.com ([157.56.110.130]:21331
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759079AbaEMJFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:05:23 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Ley Foon Tan <lftan@altera.com>, <lftan.linux@gmail.com>,
        <cltang@codesourcery.com>, James Hogan <james.hogan@imgtec.com>,
        <linux-metag@vger.kernel.org>
Subject: [PATCH 12/25] metag: Add 32 bit time_t and clock_t
Date: Tue, 13 May 2014 17:04:45 +0800
Message-ID: <1399971885-4413-1-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399971456-3941-1-git-send-email-lftan@altera.com>
References: <1399971456-3941-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.232;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(199002)(189002)(2009001)(77982001)(85852003)(79102001)(16796002)(47776003)(36756003)(76482001)(575784001)(86362001)(20776003)(50466002)(92566001)(89996001)(102836001)(76176999)(84676001)(83072002)(48376002)(87936001)(87286001)(50986999)(44976005)(6806004)(46102001)(77156001)(83322001)(19580405001)(31966008)(19580395003)(74662001)(62966002)(4396001)(74502001)(50226001)(92726001)(81342001)(33646001)(80022001)(81542001);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2FFO11HUB018;H:SJ-ITEXEDGE02.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
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
 arch/metag/include/asm/Kbuild             |  1 -
 arch/metag/include/uapi/asm/Kbuild        |  1 +
 arch/metag/include/uapi/asm/posix_types.h | 17 +++++++++++++++++
 3 files changed, 18 insertions(+), 1 deletion(-)
 create mode 100644 arch/metag/include/uapi/asm/posix_types.h

diff --git a/arch/metag/include/asm/Kbuild b/arch/metag/include/asm/Kbuild
index c29ead8..5a97e0d6 100644
--- a/arch/metag/include/asm/Kbuild
+++ b/arch/metag/include/asm/Kbuild
@@ -31,7 +31,6 @@ generic-y += param.h
 generic-y += pci.h
 generic-y += percpu.h
 generic-y += poll.h
-generic-y += posix_types.h
 generic-y += preempt.h
 generic-y += scatterlist.h
 generic-y += sections.h
diff --git a/arch/metag/include/uapi/asm/Kbuild b/arch/metag/include/uapi/asm/Kbuild
index 84e09fe..1542689 100644
--- a/arch/metag/include/uapi/asm/Kbuild
+++ b/arch/metag/include/uapi/asm/Kbuild
@@ -3,6 +3,7 @@ include include/uapi/asm-generic/Kbuild.asm
 
 header-y += byteorder.h
 header-y += ech.h
+header-y += posix_types.h
 header-y += ptrace.h
 header-y += resource.h
 header-y += sigcontext.h
diff --git a/arch/metag/include/uapi/asm/posix_types.h b/arch/metag/include/uapi/asm/posix_types.h
new file mode 100644
index 0000000..d643b22
--- /dev/null
+++ b/arch/metag/include/uapi/asm/posix_types.h
@@ -0,0 +1,17 @@
+#ifndef __ARCH_METAG_POSIX_TYPES_H
+#define __ARCH_METAG_POSIX_TYPES_H
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

