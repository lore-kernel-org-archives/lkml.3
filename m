Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759938AbaEMJO6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:14:58 -0400
Received: from mail-by2lp0236.outbound.protection.outlook.com ([207.46.163.236]:23792
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759667AbaEMJDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:03:04 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Ley Foon Tan <lftan@altera.com>, <lftan.linux@gmail.com>,
        <cltang@codesourcery.com>, Steven Miao <realmz6@gmail.com>,
        <adi-buildroot-devel@lists.sourceforge.net>
Subject: [PATCH 05/25] blackfin: Add 32 bit time_t and clock_t
Date: Tue, 13 May 2014 17:02:55 +0800
Message-ID: <1399971775-4153-1-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399971456-3941-1-git-send-email-lftan@altera.com>
References: <1399971456-3941-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.232;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(199002)(189002)(16796002)(47776003)(92566001)(81542001)(87286001)(85852003)(83072002)(36756003)(89996001)(86362001)(74502001)(74662001)(92726001)(50466002)(79102001)(31966008)(102836001)(62966002)(77156001)(48376002)(20776003)(81342001)(44976005)(33646001)(80022001)(6806004)(19580395003)(19580405001)(50226001)(46102001)(83322001)(87936001)(2009001)(77982001)(84676001)(50986999)(4396001)(76176999)(76482001);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2FFO11HUB007;H:SJ-ITEXEDGE02.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
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
 arch/blackfin/include/uapi/asm/posix_types.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/blackfin/include/uapi/asm/posix_types.h b/arch/blackfin/include/uapi/asm/posix_types.h
index 9608ef6..e005638 100644
--- a/arch/blackfin/include/uapi/asm/posix_types.h
+++ b/arch/blackfin/include/uapi/asm/posix_types.h
@@ -25,6 +25,12 @@ typedef unsigned short __kernel_old_gid_t;
 typedef unsigned short __kernel_old_dev_t;
 #define __kernel_old_dev_t __kernel_old_dev_t
 
+typedef long __kernel_time_t;
+#define __kernel_time_t __kernel_time_t
+
+typedef long __kernel_clock_t;
+#define __kernel_clock_t __kernel_clock_t
+
 #include <asm-generic/posix_types.h>
 
 #endif /* _UAPI__ARCH_BFIN_POSIX_TYPES_H */
-- 
1.8.2.1

