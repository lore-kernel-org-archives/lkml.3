Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626AbaLEJ6J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 04:58:09 -0500
Received: from mail-bl2on0126.outbound.protection.outlook.com ([65.55.169.126]:19968
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752792AbaLEJ6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 04:58:07 -0500
From: Jingchang Lu <jingchang.lu@freescale.com>
To: <shawn.guo@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Jingchang Lu <jingchang.lu@freescale.com>
Subject: [PATCH] arm: ls1021a: setup hrtimer based tick broadcast
Date: Fri, 5 Dec 2014 17:07:29 +0800
Message-ID: <1417770449-3492-1-git-send-email-jingchang.lu@freescale.com>
X-Mailer: git-send-email 1.8.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(89996001)(50466002)(84676001)(48376002)(110136001)(86362001)(31966008)(87936001)(92566001)(19580405001)(6806004)(19580395003)(33646002)(21056001)(99396003)(120916001)(97736003)(104016003)(4396001)(62966003)(77156002)(50226001)(50986999)(46102003)(106466001)(105606002)(68736005)(107046002)(20776003)(77096005)(47776003)(229853001)(36756003)(64706001)(2351001);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB1242;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1242;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(602002);SRVR:CY1PR0301MB1242;
X-Forefront-PRVS: 04163EF38A
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=jingchang.lu@freescale.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1242;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds setup of hrtimer based tick broadcast to utilize
the hrtimer in SMP without other broadcast tick devices.

Signed-off-by: Jingchang Lu <jingchang.lu@freescale.com>
---
 arch/arm/mach-imx/mach-ls1021a.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm/mach-imx/mach-ls1021a.c b/arch/arm/mach-imx/mach-ls1021a.c
index b89c858..4d074cf 100644
--- a/arch/arm/mach-imx/mach-ls1021a.c
+++ b/arch/arm/mach-imx/mach-ls1021a.c
@@ -7,6 +7,10 @@
  * (at your option) any later version.
  */
 
+#include <linux/clockchips.h>
+#include <linux/clk-provider.h>
+#include <linux/clocksource.h>
+
 #include <asm/mach/arch.h>
 
 #include "common.h"
@@ -16,7 +20,15 @@ static const char * const ls1021a_dt_compat[] __initconst = {
 	NULL,
 };
 
+static void __init ls1021a_init_time(void)
+{
+	of_clk_init(NULL);
+	clocksource_of_init();
+	tick_setup_hrtimer_broadcast();
+}
+
 DT_MACHINE_START(LS1021A, "Freescale LS1021A")
 	.smp		= smp_ops(ls1021a_smp_ops),
+	.init_time	= ls1021a_init_time,
 	.dt_compat	= ls1021a_dt_compat,
 MACHINE_END
-- 
1.8.0

