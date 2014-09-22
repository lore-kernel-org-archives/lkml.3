Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931AbaIVFwa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 01:52:30 -0400
Received: from mail-bn1on0130.outbound.protection.outlook.com ([157.56.110.130]:64955
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751380AbaIVFw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 01:52:29 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <mturquette@linaro.org>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH] clk: use uninitialized_var instead setting 'flags' to 0 directly.
Date: Mon, 22 Sep 2014 13:52:11 +0800
Message-ID: <1411365131-22094-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 2.1.0.27.g96db324
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(69596002)(105606002)(81156004)(50466002)(229853001)(50986999)(76482002)(107046002)(2351001)(97736003)(106466001)(47776003)(95666004)(92726001)(68736004)(99396002)(26826002)(92566001)(104166001)(83072002)(31966008)(81542003)(83322001)(86362001)(36756003)(85852003)(77156001)(89996001)(20776003)(110136001)(6806004)(88136002)(77982003)(80022003)(19580405001)(62966002)(44976005)(85306004)(79102003)(64706001)(21056001)(46102003)(19580395003)(104016003)(4396001)(84676001)(93916002)(87936001)(50226001)(81342003)(48376002)(87286001)(74502003)(120916001)(102836001)(74662003)(90102001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0615;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0615;
X-Forefront-PRVS: 034215E98F
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0647;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Setting 'flags' to zero will be certainly a misleading way to avoid
warning of 'flags' may be used uninitialized. uninitialized_var is
a correct way because the warning is a false possitive.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 drivers/clk/clk-gate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/clk-gate.c b/drivers/clk/clk-gate.c
index 4a58c55..51fd87f 100644
--- a/drivers/clk/clk-gate.c
+++ b/drivers/clk/clk-gate.c
@@ -45,7 +45,7 @@ static void clk_gate_endisable(struct clk_hw *hw, int enable)
 {
 	struct clk_gate *gate = to_clk_gate(hw);
 	int set = gate->flags & CLK_GATE_SET_TO_DISABLE ? 1 : 0;
-	unsigned long flags = 0;
+	unsigned long uninitialized_var(flags);
 	u32 reg;
 
 	set ^= enable;
-- 
2.1.0.27.g96db324

