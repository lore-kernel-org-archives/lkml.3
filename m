Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933405AbaEFA0d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 20:26:33 -0400
Received: from mail-bn1lp0139.outbound.protection.outlook.com ([207.46.163.139]:54872
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933005AbaEFA0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 20:26:32 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH] ARM: LPAE: Update the comment to support the LPAE
Date: Tue, 6 May 2014 07:40:56 +0800
Message-ID: <1399333256-10471-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.1;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(199002)(189002)(86362001)(62966002)(20776003)(47776003)(81342001)(6806004)(93916002)(64706001)(81542001)(80022001)(77096999)(92566001)(92726001)(85852003)(83072002)(48376002)(87286001)(21056001)(79102001)(88136002)(4396001)(89996001)(87936001)(83322001)(19580405001)(19580395003)(44976005)(31966008)(74502001)(74662001)(76482001)(77982001)(50226001)(77156001)(50466002)(50986999)(46102001)(99396002)(36756003)(2101003);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB503;H:tx30smr01.am.freescale.net;FPR:;PTR:gate-tx3.freescale.com;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Forefront-PRVS: 0203C93D51
Authentication-Results: spf=fail (sender IP is 192.88.168.1)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the LPAE maybe enabled, so we should update the comment
to support it.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 arch/arm/kernel/head.S | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
index 914616e..005af2d 100644
--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -29,10 +29,10 @@
 
 /*
  * swapper_pg_dir is the virtual address of the initial page table.
- * We place the page tables 16K below KERNEL_RAM_VADDR.  Therefore, we must
- * make sure that KERNEL_RAM_VADDR is correctly set.  Currently, we expect
- * the least significant 16 bits to be 0x8000, but we could probably
- * relax this restriction to KERNEL_RAM_VADDR >= PAGE_OFFSET + 0x4000.
+ * We place the page tables PG_DIR_SIZE below KERNEL_RAM_VADDR. Therefore,
+ * we must make sure that KERNEL_RAM_VADDR is correctly set. Currently,
+ * we expect the least significant 16 bits to be 0x8000, but we could probably
+ * relax this restriction to KERNEL_RAM_VADDR >= PAGE_OFFSET + PG_DIR_SIZE.
  */
 #define KERNEL_RAM_VADDR	(PAGE_OFFSET + TEXT_OFFSET)
 #if (KERNEL_RAM_VADDR & 0xffff) != 0x8000
-- 
1.8.4

