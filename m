Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759879AbaEMJLC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:11:02 -0400
Received: from mail-bn1bon0136.outbound.protection.outlook.com ([157.56.111.136]:21706
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759857AbaEMJK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:10:57 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Ley Foon Tan <lftan@altera.com>, <lftan.linux@gmail.com>,
        <cltang@codesourcery.com>, Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>, <linux-cris-kernel@axis.com>
Subject: [PATCH 07/25] cris: Add 32 bit time_t and clock_t
Date: Tue, 13 May 2014 17:10:46 +0800
Message-ID: <1399972246-5031-1-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399971456-3941-1-git-send-email-lftan@altera.com>
References: <1399971456-3941-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.232;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(199002)(189002)(33646001)(46102001)(79102001)(44976005)(19580405001)(31966008)(20776003)(50226001)(6806004)(19580395003)(47776003)(4396001)(102836001)(16796002)(76482001)(74662001)(83322001)(81542001)(81342001)(86362001)(77156001)(50986999)(2009001)(85852003)(89996001)(62966002)(83072002)(77982001)(92726001)(50466002)(80022001)(74502001)(36756003)(92566001)(87936001)(87286001)(76176999)(84676001)(48376002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1AFFO11HUB018;H:SJ-ITEXEDGE02.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
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
 arch/cris/include/uapi/asm/posix_types.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/cris/include/uapi/asm/posix_types.h b/arch/cris/include/uapi/asm/posix_types.h
index 0f22e6a..334499a 100644
--- a/arch/cris/include/uapi/asm/posix_types.h
+++ b/arch/cris/include/uapi/asm/posix_types.h
@@ -25,6 +25,12 @@ typedef unsigned short	__kernel_gid_t;
 typedef unsigned short	__kernel_old_dev_t;
 #define __kernel_old_dev_t __kernel_old_dev_t
 
+typedef long	__kernel_time_t;
+#define __kernel_time_t __kernel_time_t
+
+typedef long	__kernel_clock_t;
+#define __kernel_clock_t __kernel_clock_t
+
 #include <asm-generic/posix_types.h>
 
 #endif /* __ARCH_CRIS_POSIX_TYPES_H */
-- 
1.8.2.1

