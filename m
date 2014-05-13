Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759810AbaEMJGa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:06:30 -0400
Received: from mail-by2on0133.outbound.protection.outlook.com ([207.46.100.133]:33810
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752759AbaEMJG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:06:27 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Ley Foon Tan <lftan@altera.com>, <lftan.linux@gmail.com>,
        <cltang@codesourcery.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        "Heiko Carstens" <heiko.carstens@de.ibm.com>, <linux390@de.ibm.com>
Subject: [PATCH 19/25] s390: Add 32 bit time_t and clock_t
Date: Tue, 13 May 2014 17:06:17 +0800
Message-ID: <1399971977-4670-1-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399971456-3941-1-git-send-email-lftan@altera.com>
References: <1399971456-3941-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.232;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(199002)(189002)(85852003)(89996001)(84676001)(77156001)(83072002)(76176999)(48376002)(36756003)(6806004)(79102001)(76482001)(19580395003)(77982001)(87286001)(87936001)(47776003)(20776003)(44976005)(19580405001)(83322001)(4396001)(50226001)(33646001)(81542001)(50466002)(2009001)(81342001)(92566001)(92726001)(46102001)(86362001)(50986999)(80022001)(62966002)(74502001)(16796002)(74662001)(31966008)(102836001);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2FFO11HUB023;H:SJ-ITEXEDGE02.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
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
 arch/s390/include/uapi/asm/posix_types.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/s390/include/uapi/asm/posix_types.h b/arch/s390/include/uapi/asm/posix_types.h
index bf2a2ad..95729a3 100644
--- a/arch/s390/include/uapi/asm/posix_types.h
+++ b/arch/s390/include/uapi/asm/posix_types.h
@@ -28,6 +28,12 @@ typedef unsigned short  __kernel_uid_t;
 typedef unsigned short  __kernel_gid_t;
 typedef int             __kernel_ptrdiff_t;
 
+typedef long	__kernel_time_t;
+#define __kernel_time_t __kernel_time_t
+
+typedef long	__kernel_clock_t;
+#define __kernel_clock_t __kernel_clock_t
+
 #else /* __s390x__ */
 
 typedef unsigned int    __kernel_ino_t;
-- 
1.8.2.1

