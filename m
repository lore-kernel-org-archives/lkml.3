Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932612AbaEMJF7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:05:59 -0400
Received: from mail-by2on0135.outbound.protection.outlook.com ([207.46.100.135]:59113
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932593AbaEMJF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:05:56 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Ley Foon Tan <lftan@altera.com>, <lftan.linux@gmail.com>,
        <cltang@codesourcery.com>, Ralf Baechle <ralf@linux-mips.org>,
        <linux-mips@linux-mips.org>
Subject: [PATCH 14/25] mips: Add 32 bit time_t and clock_t
Date: Tue, 13 May 2014 17:05:29 +0800
Message-ID: <1399971929-4487-1-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399971456-3941-1-git-send-email-lftan@altera.com>
References: <1399971456-3941-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.232;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(199002)(189002)(36756003)(79102001)(76482001)(92566001)(33646001)(92726001)(47776003)(20776003)(86362001)(77982001)(84676001)(48376002)(50466002)(50986999)(89996001)(76176999)(102836001)(77156001)(2009001)(87936001)(87286001)(83072002)(85852003)(16796002)(31966008)(74662001)(74502001)(46102001)(19580405001)(6806004)(44976005)(19580395003)(83322001)(81342001)(81542001)(62966002)(4396001)(50226001)(80022001);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2FFO11HUB055;H:SJ-ITEXEDGE02.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
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
 arch/mips/include/uapi/asm/posix_types.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/mips/include/uapi/asm/posix_types.h b/arch/mips/include/uapi/asm/posix_types.h
index fa03ec3..e9ca921 100644
--- a/arch/mips/include/uapi/asm/posix_types.h
+++ b/arch/mips/include/uapi/asm/posix_types.h
@@ -25,6 +25,12 @@ typedef struct {
 	long	val[2];
 } __kernel_fsid_t;
 #define __kernel_fsid_t __kernel_fsid_t
+
+typedef long	__kernel_time_t;
+#define __kernel_time_t __kernel_time_t
+
+typedef long	__kernel_clock_t;
+#define __kernel_clock_t __kernel_clock_t
 #endif
 
 #include <asm-generic/posix_types.h>
-- 
1.8.2.1

