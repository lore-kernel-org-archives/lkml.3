Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbaHSDV7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 23:21:59 -0400
Received: from mail-bn1blp0184.outbound.protection.outlook.com ([207.46.163.184]:1805
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752025AbaHSDV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 23:21:58 -0400
From: Peng Fan <van.freenix@gmail.com>
To: Russell King <linux@arm.linux.org.uk>, Rob Herring <robh@kernel.org>,
        Laura Abbott <lauraa@codeaurora.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>,
        Stephen Boyd <sboyd@codeaurora.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] arm: Do not overwrite __machine_arch_type
Date: Tue, 19 Aug 2014 11:21:31 +0800
Message-ID: <1408418491-29330-1-git-send-email-van.freenix@gmail.com>
X-Mailer: git-send-email 1.8.4
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130528921142770950;(91ab9b29-cfa4-454e-5278-08d120cd25b8);()
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009006)(979002)(6009001)(199003)(189002)(4396001)(87572001)(50986999)(21056001)(89996001)(50226001)(81442001)(79102001)(55446002)(62966002)(77982001)(81342001)(97736001)(61266001)(73972005)(104166001)(99396002)(82202001)(105596002)(83072002)(84676001)(88136002)(92726001)(104016003)(81542001)(77156001)(85306004)(85852003)(102836001)(107046002)(47776003)(26826002)(20776003)(92566001)(44976005)(36756003)(53416004)(46102001)(106466001)(87936001)(6806004)(50466002)(48376002)(86362001)(68736004)(229853001)(80022001)(93916002)(73392001)(87286001)(31966008)(74502001)(74662001)(95666004)(33646002)(19580395003)(19580405001)(64706001)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB360;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0308EE423E
Authentication-Results: spf=softfail (sender IP is 192.88.168.50)
 smtp.mailfrom=van.freenix@gmail.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If using DT_MACHINE_START when enabled CONFIG_OF, the nr of mdesc is ~0.
The value of __machine_arch_type is passsed from bootloader using reigster
r1, and assigned in head-common.S. Remove this line to avoid overwrite it.

Signed-off-by: Peng Fan <van.freenix@gmail.com>
---
 arch/arm/kernel/devtree.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm/kernel/devtree.c b/arch/arm/kernel/devtree.c
index 11c54de..3a04486 100644
--- a/arch/arm/kernel/devtree.c
+++ b/arch/arm/kernel/devtree.c
@@ -243,8 +243,5 @@ const struct machine_desc * __init setup_machine_fdt(unsigned int dt_phys)
 
 	early_init_dt_scan_nodes();
 
-	/* Change machine number to match the mdesc we're using */
-	__machine_arch_type = mdesc->nr;
-
 	return mdesc;
 }
-- 
1.8.4


