Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759383AbaEMJCn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:02:43 -0400
Received: from mail-bn1bon0139.outbound.protection.outlook.com ([157.56.111.139]:11808
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752503AbaEMJCl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:02:41 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Ley Foon Tan <lftan@altera.com>, <lftan.linux@gmail.com>,
        <cltang@codesourcery.com>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 01/25] asm-generic: Change time_t and clock_t to 64 bit
Date: Tue, 13 May 2014 17:02:29 +0800
Message-ID: <1399971749-4004-1-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399971456-3941-1-git-send-email-lftan@altera.com>
References: <1399971456-3941-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.232;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(189002)(199002)(4396001)(87286001)(50986999)(83072002)(89996001)(85852003)(76176999)(33646001)(46102001)(50226001)(102836001)(76482001)(77156001)(81342001)(80022001)(2009001)(86362001)(575784001)(50466002)(19580395003)(79102001)(62966002)(47776003)(83322001)(92726001)(92566001)(19580405001)(36756003)(48376002)(31966008)(74502001)(87936001)(84676001)(44976005)(6806004)(74662001)(20776003)(81542001)(77982001)(16796002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1BFFO11HUB029;H:SJ-ITEXEDGE02.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-OriginatorOrg: altera.onmicrosoft.com
X-Forefront-PRVS: 0210479ED8
Authentication-Results: spf=softfail (sender IP is 66.35.236.232)
 smtp.mailfrom=lftan@altera.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use 64 bit time_t and clock_t as default. 32 bit users can provide
an override to define these as "long" if needed.

Signed-off-by: Ley Foon Tan <lftan@altera.com>
---
 include/uapi/asm-generic/posix_types.h | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/uapi/asm-generic/posix_types.h b/include/uapi/asm-generic/posix_types.h
index fe74fcc..3f0e613 100644
--- a/include/uapi/asm-generic/posix_types.h
+++ b/include/uapi/asm-generic/posix_types.h
@@ -81,12 +81,22 @@ typedef struct {
 #endif
 
 /*
+ * Use 64 bit time_t and clock_t as default. 32 bit users can provide an override to
+ * define these as "long" if needed.
+ */
+#ifndef __kernel_time_t
+typedef long long	__kernel_time_t;
+#endif
+
+#ifndef __kernel_clock_t
+typedef long long	__kernel_clock_t;
+#endif
+
+/*
  * anything below here should be completely generic
  */
 typedef __kernel_long_t	__kernel_off_t;
 typedef long long	__kernel_loff_t;
-typedef __kernel_long_t	__kernel_time_t;
-typedef __kernel_long_t	__kernel_clock_t;
 typedef int		__kernel_timer_t;
 typedef int		__kernel_clockid_t;
 typedef char *		__kernel_caddr_t;
-- 
1.8.2.1

