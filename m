Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003Ab3KGDTB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 22:19:01 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:64986 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752591Ab3KGDS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 22:18:57 -0500
From: Jisheng Zhang <jszhang@marvell.com>
To: <rob.herring@calxeda.com>, <linux@arm.linux.org.uk>,
        <kernel@pengutronix.de>, <baohua@kernel.org>, <dinguyen@altera.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Jisheng Zhang <jszhang@marvell.com>
Subject: [PATCH V2 1/4] arm: highbank: make use of common scu_a9_get_base() interface
Date: Thu, 7 Nov 2013 11:16:41 +0800
Message-ID: <1383794204-4714-2-git-send-email-jszhang@marvell.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1383794204-4714-1-git-send-email-jszhang@marvell.com>
References: <1383794204-4714-1-git-send-email-jszhang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-11-07_01:2013-11-06,2013-11-07,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1311060262
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make use of common scu_a9_get_base() and delete the comment since the
interface is self commented.

Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
---
 arch/arm/mach-highbank/highbank.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-highbank/highbank.c b/arch/arm/mach-highbank/highbank.c
index 8e63ccd..7df007b 100644
--- a/arch/arm/mach-highbank/highbank.c
+++ b/arch/arm/mach-highbank/highbank.c
@@ -29,6 +29,7 @@
 #include <asm/cacheflush.h>
 #include <asm/cputype.h>
 #include <asm/smp_plat.h>
+#include <asm/smp_scu.h>
 #include <asm/hardware/cache-l2x0.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
@@ -43,8 +44,7 @@ static void __init highbank_scu_map_io(void)
 {
 	unsigned long base;
 
-	/* Get SCU base */
-	asm("mrc p15, 4, %0, c15, c0, 0" : "=r" (base));
+	base = scu_a9_get_base();
 
 	scu_base_addr = ioremap(base, SZ_4K);
 }
-- 
1.8.4.2

