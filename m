Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932633AbaEMJGH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:06:07 -0400
Received: from mail-bn1bbn0106.outbound.protection.outlook.com ([157.56.111.106]:3008
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932593AbaEMJGC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:06:02 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Ley Foon Tan <lftan@altera.com>, <lftan.linux@gmail.com>,
        <cltang@codesourcery.com>, David Howells <dhowells@redhat.com>,
        "Koichi Yasutake" <yasutake.koichi@jp.panasonic.com>,
        <linux-am33-list@redhat.com>
Subject: [PATCH 15/25] mn10300: Add 32 bit time_t and clock_t
Date: Tue, 13 May 2014 17:05:51 +0800
Message-ID: <1399971951-4524-1-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399971456-3941-1-git-send-email-lftan@altera.com>
References: <1399971456-3941-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.232;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(189002)(199002)(6806004)(19580395003)(19580405001)(44976005)(81342001)(74502001)(4396001)(83322001)(46102001)(81542001)(62966002)(48376002)(76482001)(77156001)(79102001)(77982001)(20776003)(87286001)(87936001)(36756003)(50466002)(2009001)(50986999)(47776003)(84676001)(31966008)(16796002)(76176999)(74662001)(50226001)(86362001)(85852003)(80022001)(89996001)(92726001)(92566001)(83072002)(33646001)(102836001);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2FFO11HUB066;H:SJ-ITEXEDGE02.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
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
 arch/mn10300/include/uapi/asm/posix_types.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/mn10300/include/uapi/asm/posix_types.h b/arch/mn10300/include/uapi/asm/posix_types.h
index d31eeea..669ed1b 100644
--- a/arch/mn10300/include/uapi/asm/posix_types.h
+++ b/arch/mn10300/include/uapi/asm/posix_types.h
@@ -40,6 +40,12 @@ typedef int		__kernel_ptrdiff_t;
 typedef unsigned short	__kernel_old_dev_t;
 #define __kernel_old_dev_t __kernel_old_dev_t
 
+typedef long	__kernel_time_t;
+#define __kernel_time_t __kernel_time_t
+
+typedef long	__kernel_clock_t;
+#define __kernel_clock_t __kernel_clock_t
+
 #include <asm-generic/posix_types.h>
 
 #endif /* _ASM_POSIX_TYPES_H */
-- 
1.8.2.1

