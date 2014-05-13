Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932555AbaEMJEx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:04:53 -0400
Received: from mail-by2on0120.outbound.protection.outlook.com ([207.46.100.120]:55757
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759791AbaEMJEt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:04:49 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Ley Foon Tan <lftan@altera.com>, <lftan.linux@gmail.com>,
        <cltang@codesourcery.com>, Geert Uytterhoeven <geert@linux-m68k.org>,
        <linux-m68k@vger.kernel.org>
Subject: [PATCH 11/25] m68k: Add 32 bit time_t and clock_t
Date: Tue, 13 May 2014 17:03:50 +0800
Message-ID: <1399971830-4375-1-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399971456-3941-1-git-send-email-lftan@altera.com>
References: <1399971456-3941-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.232;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(199002)(189002)(47776003)(77156001)(76482001)(33646001)(77982001)(62966002)(83322001)(36756003)(92566001)(20776003)(92726001)(79102001)(85852003)(74662001)(16796002)(81342001)(19580405001)(83072002)(80022001)(87286001)(31966008)(19580395003)(2009001)(50466002)(81542001)(46102001)(89996001)(87936001)(76176999)(50986999)(6806004)(48376002)(74502001)(84676001)(50226001)(44976005)(102836001)(86362001)(4396001);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2FFO11HUB054;H:SJ-ITEXEDGE02.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
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
 arch/m68k/include/uapi/asm/posix_types.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/m68k/include/uapi/asm/posix_types.h b/arch/m68k/include/uapi/asm/posix_types.h
index cf4dbf7..01e39fe 100644
--- a/arch/m68k/include/uapi/asm/posix_types.h
+++ b/arch/m68k/include/uapi/asm/posix_types.h
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
 
 #endif
-- 
1.8.2.1

