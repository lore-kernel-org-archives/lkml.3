Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751714AbaCaWhF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 18:37:05 -0400
Received: from mail-bn1on0145.outbound.protection.outlook.com ([157.56.110.145]:21279
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750987AbaCaWhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 18:37:01 -0400
From: <tthayer@altera.com>
To: <dinguyen@altera.com>, <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <rob@landley.net>, <linux@arm.linux.org.uk>
CC: Thor Thayer <tthayer@altera.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 2/2] arm: socfpga: Add support for Altera SoC SDRAM controller
Date: Mon, 31 Mar 2014 17:07:07 -0500
Message-ID: <1396303627-29198-3-git-send-email-tthayer@altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1396303627-29198-1-git-send-email-tthayer@altera.com>
References: <1396303627-29198-1-git-send-email-tthayer@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: =?us-ascii?Q?CIP:66.35.236.232;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(1001?=
 =?us-ascii?Q?9001)(6009001)(458001)(189002)(199002)(87266001)(83072002)(8?=
 =?us-ascii?Q?7286001)(84676001)(89996001)(50226001)(33646001)(4396001)(49?=
 =?us-ascii?Q?866001)(95666003)(47976001)(83322001)(81816001)(6806004)(477?=
 =?us-ascii?Q?36001)(74366001)(44976005)(85852003)(19580405001)(69226001)(?=
 =?us-ascii?Q?85306002)(50986001)(81542001)(90146001)(88136002)(97336001)(?=
 =?us-ascii?Q?56816005)(87936001)(51856001)(46102001)(16796002)(97186001)(?=
 =?us-ascii?Q?98676001)(31966008)(74662001)(48376002)(19580395003)(8134200?=
 =?us-ascii?Q?1)(47446002)(56776001)(54316002)(74502001)(76482001)(9431600?=
 =?us-ascii?Q?2)(79102001)(50466002)(59766001)(74706001)(77982001)(2077600?=
 =?us-ascii?Q?3)(94946001)(47776003)(93516002)(63696002)(93916002)(7715600?=
 =?us-ascii?Q?1)(80976001)(62966002)(92726001)(76786001)(36756003)(9541600?=
 =?us-ascii?Q?1)(93136001)(76796001)(97736001)(2009001)(77096001)(80022001?=
 =?us-ascii?Q?)(2201001)(86362001)(42186004)(74876001)(92566001)(86152002)?=
 =?us-ascii?Q?(81686001)(53806001)(65816001);DIR:OUT;SFP:1102;SCL:1;SRVR:B?=
 =?us-ascii?Q?L2FFO11HUB062;H:SJ-ITEXEDGE02.altera.priv.altera.com;FPR:F3C?=
 =?us-ascii?Q?DC76A.A0D3A42A.F6F31F47.5BE0CAF9.2023F;MLV:sfv;PTR:InfoDomai?=
 =?us-ascii?Q?nNonexistent;MX:1;A:1;LANG:en;?=
X-OriginatorOrg: altera.onmicrosoft.com
X-Forefront-PRVS: 0167DB5752
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thor Thayer <tthayer@altera.com>

Addition of the Altera SDRAM controller registers to the
Altera SoC project. These registers are shared by future
drivers such as ECC and the FPGA bridge.

Signed-off-by: Thor Thayer <tthayer@altera.com>
To: Rob Herring <rob.herring@calxeda.com>
To: Pawel Moll <pawel.moll@arm.com>
To: Mark Rutland <mark.rutland@arm.com>
To: Ian Campbell <ijc+devicetree@hellion.org.uk>
To: Kumar Gala <galak@codeaurora.org>
To: Rob Landley <rob@landley.net>
To: Russell King <linux@arm.linux.org.uk>
To: Dinh Nguyen <dinguyen@altera.com>
Cc: devicetree@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
---
 arch/arm/mach-socfpga/socfpga.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/mach-socfpga/socfpga.c b/arch/arm/mach-socfpga/socfpga.c
index 21d6026..d514e8a 100644
--- a/arch/arm/mach-socfpga/socfpga.c
+++ b/arch/arm/mach-socfpga/socfpga.c
@@ -32,6 +32,7 @@
 void __iomem *socfpga_scu_base_addr = ((void __iomem *)(SOCFPGA_SCU_VIRT_BASE));
 void __iomem *sys_manager_base_addr;
 void __iomem *rst_manager_base_addr;
+void __iomem *sdr_ctl_base_addr;
 void __iomem *clk_mgr_base_addr;
 unsigned long cpu1start_addr;
 
@@ -150,6 +151,15 @@ void __init socfpga_sysmgr_init(void)
 
 	np = of_find_compatible_node(NULL, NULL, "altr,clk-mgr");
 	clk_mgr_base_addr = of_iomap(np, 0);
+
+	np = of_find_compatible_node(NULL, NULL, "altr,sdr-ctl");
+	if (!np) {
+		pr_err("SOCFPGA: Unable to find sdr-ctl\n");
+		return;
+	}
+
+	sdr_ctl_base_addr = of_iomap(np, 0);
+	WARN_ON(!sdr_ctl_base_addr);
 }
 
 static void __init socfpga_init_irq(void)
-- 
1.7.9.5

