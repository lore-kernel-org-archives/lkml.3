Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932690AbaEMJGj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:06:39 -0400
Received: from mail-by2on0136.outbound.protection.outlook.com ([207.46.100.136]:33204
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759816AbaEMJGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:06:34 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Ley Foon Tan <lftan@altera.com>, <lftan.linux@gmail.com>,
        <cltang@codesourcery.com>, Chen Liqin <liqin.linux@gmail.com>,
        Lennox Wu <lennox.wu@gmail.com>
Subject: [PATCH 20/25] score: Add 32 bit time_t and clock_t
Date: Tue, 13 May 2014 17:06:23 +0800
Message-ID: <1399971983-4707-1-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399971456-3941-1-git-send-email-lftan@altera.com>
References: <1399971456-3941-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.232;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(199002)(189002)(92566001)(83072002)(84676001)(87286001)(50466002)(74502001)(77156001)(86362001)(2009001)(76482001)(87936001)(77982001)(48376002)(76176999)(36756003)(89996001)(102836001)(20776003)(85852003)(33646001)(92726001)(50986999)(47776003)(6806004)(46102001)(44976005)(31966008)(19580405001)(83322001)(19580395003)(16796002)(81542001)(74662001)(80022001)(4396001)(81342001)(50226001)(79102001)(62966002);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2FFO11HUB035;H:SJ-ITEXEDGE02.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
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
 arch/score/include/uapi/asm/posix_types.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/score/include/uapi/asm/posix_types.h b/arch/score/include/uapi/asm/posix_types.h
index b88acf8..4c3843a 100644
--- a/arch/score/include/uapi/asm/posix_types.h
+++ b/arch/score/include/uapi/asm/posix_types.h
@@ -1,6 +1,12 @@
 #ifndef _ASM_SCORE_POSIX_TYPES_H
 #define _ASM_SCORE_POSIX_TYPES_H
 
+typedef long	__kernel_time_t;
+#define __kernel_time_t __kernel_time_t
+
+typedef long	__kernel_clock_t;
+#define __kernel_clock_t __kernel_clock_t
+
 #include <asm-generic/posix_types.h>
 
 #endif /* _ASM_SCORE_POSIX_TYPES_H */
-- 
1.8.2.1

