Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932513AbaEMJD7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:03:59 -0400
Received: from mail-by2on0122.outbound.protection.outlook.com ([207.46.100.122]:47404
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932459AbaEMJDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:03:55 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Ley Foon Tan <lftan@altera.com>, <lftan.linux@gmail.com>,
        <cltang@codesourcery.com>, Hirokazu Takata <takata@linux-m32r.org>,
        <linux-m32r@ml.linux-m32r.org>
Subject: [PATCH 10/25] m32r: Add 32 bit time_t and clock_t
Date: Tue, 13 May 2014 17:03:37 +0800
Message-ID: <1399971817-4337-1-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399971456-3941-1-git-send-email-lftan@altera.com>
References: <1399971456-3941-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.232;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(189002)(199002)(92566001)(84676001)(87286001)(20776003)(83072002)(74502001)(77156001)(85852003)(50466002)(77982001)(2009001)(76482001)(87936001)(76176999)(48376002)(33646001)(89996001)(36756003)(102836001)(50986999)(47776003)(92726001)(6806004)(46102001)(44976005)(31966008)(83322001)(19580405001)(19580395003)(16796002)(81342001)(81542001)(79102001)(74662001)(86362001)(50226001)(80022001)(4396001)(62966002);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2FFO11HUB036;H:SJ-ITEXEDGE02.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
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
 arch/m32r/include/uapi/asm/posix_types.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/m32r/include/uapi/asm/posix_types.h b/arch/m32r/include/uapi/asm/posix_types.h
index 236de26..77cf049 100644
--- a/arch/m32r/include/uapi/asm/posix_types.h
+++ b/arch/m32r/include/uapi/asm/posix_types.h
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
 
 #endif  /* _ASM_M32R_POSIX_TYPES_H */
-- 
1.8.2.1

