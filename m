Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751AbaENDgb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 23:36:31 -0400
Received: from mail-by2on0147.outbound.protection.outlook.com ([207.46.100.147]:37062
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752983AbaENDgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 23:36:25 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Ley Foon Tan <lftan@altera.com>, <lftan.linux@gmail.com>,
        <cltang@codesourcery.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        <x86@kernel.org>
Subject: [PATCH 24/25] x86: Add 32 bit time_t and clock_t
Date: Wed, 14 May 2014 11:36:16 +0800
Message-ID: <1400038576-6027-1-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399971456-3941-1-git-send-email-lftan@altera.com>
References: <1399971456-3941-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.232;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(189002)(199002)(50466002)(76176999)(83072002)(47776003)(89996001)(84676001)(88136002)(87286001)(50986999)(74662001)(99396002)(48376002)(33646001)(97736001)(44976005)(42186004)(85852003)(93916002)(102836001)(46102001)(19580395003)(19580405001)(16796002)(6806004)(83322001)(77156001)(77982001)(31966008)(81542001)(86362001)(87936001)(20776003)(92726001)(92566001)(76482001)(62966002)(79102001)(36756003)(4396001)(2009001)(80022001)(74502001)(81342001)(50226001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2FFO11HUB015;H:SJ-ITEXEDGE02.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-OriginatorOrg: altera.onmicrosoft.com
X-Forefront-PRVS: 0211965D06
Authentication-Results: spf=softfail (sender IP is 66.35.236.232)
 smtp.mailfrom=lftan@altera.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Override time_t and clock_t in include/uapi/asm-generic.

Signed-off-by: Ley Foon Tan <lftan@altera.com>
---
 arch/x86/include/uapi/asm/posix_types_32.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/include/uapi/asm/posix_types_32.h b/arch/x86/include/uapi/asm/posix_types_32.h
index 8e52505..b6b7e3b 100644
--- a/arch/x86/include/uapi/asm/posix_types_32.h
+++ b/arch/x86/include/uapi/asm/posix_types_32.h
@@ -20,6 +20,12 @@ typedef unsigned short	__kernel_gid_t;
 typedef unsigned short	__kernel_old_dev_t;
 #define __kernel_old_dev_t __kernel_old_dev_t
 
+typedef long	__kernel_time_t;
+#define __kernel_time_t __kernel_time_t
+
+typedef long	__kernel_clock_t;
+#define __kernel_clock_t __kernel_clock_t
+
 #include <asm-generic/posix_types.h>
 
 #endif /* _ASM_X86_POSIX_TYPES_32_H */
-- 
1.8.2.1

