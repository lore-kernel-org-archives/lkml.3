Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757907AbaGAJWf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 05:22:35 -0400
Received: from mail-bn1lp0141.outbound.protection.outlook.com ([207.46.163.141]:59890
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757758AbaGAJWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 05:22:20 -0400
From: Jingchang Lu <jingchang.lu@freescale.com>
To: <mturquette@linaro.org>
CC: <linux-kernel@vger.kernel.org>, Jingchang Lu <jingchang.lu@freescale.com>
Subject: [PATCH] clk: ppc-corenet: Fix Section mismatch warning
Date: Tue, 1 Jul 2014 16:37:11 +0800
Message-ID: <1404203831-20880-1-git-send-email-jingchang.lu@freescale.com>
X-Mailer: git-send-email 1.8.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(36756003)(86362001)(102836001)(93916002)(81156004)(64706001)(84676001)(81342001)(104166001)(92726001)(31966008)(105606002)(50466002)(26826002)(74662001)(92566001)(47776003)(229853001)(107046002)(104016002)(80022001)(20776003)(74502001)(68736004)(106466001)(87936001)(2351001)(87286001)(77156001)(69596002)(44976005)(77982001)(79102001)(83322001)(33646001)(85306003)(76482001)(85852003)(99396002)(83072002)(97736001)(50986999)(50226001)(19580405001)(89996001)(4396001)(88136002)(6806004)(21056001)(81542001)(48376002)(19580395003)(95666004)(62966002)(46102001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB473;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02596AB7DA
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=jingchang.lu@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: drivers/built-in.o(.data+0x10258):
Section mismatch in reference from the variable ppc_corenet_clk_driver
to the (unknown reference) .init.rodata:(unknown)
The variable ppc_corenet_clk_driver references
the (unknown reference) __initconst (unknown)
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console

Signed-off-by: Jingchang Lu <jingchang.lu@freescale.com>
---
 drivers/clk/clk-ppc-corenet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/clk-ppc-corenet.c b/drivers/clk/clk-ppc-corenet.c
index 8b284be..8e58edf 100644
--- a/drivers/clk/clk-ppc-corenet.c
+++ b/drivers/clk/clk-ppc-corenet.c
@@ -291,7 +291,7 @@ static const struct of_device_id ppc_clk_ids[] __initconst = {
 	{}
 };
 
-static struct platform_driver ppc_corenet_clk_driver = {
+static struct platform_driver ppc_corenet_clk_driver __initdata = {
 	.driver = {
 		.name = "ppc_corenet_clock",
 		.owner = THIS_MODULE,
-- 
1.8.0

