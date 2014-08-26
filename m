Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219AbaHZFu0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 01:50:26 -0400
Received: from mail-by2lp0241.outbound.protection.outlook.com ([207.46.163.241]:39527
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757155AbaHZFuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 01:50:24 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <daniel.lezcano@linaro.org>, <tglx@linutronix.de>
CC: <dongsheng.wang@freescale.com>, <linux-kernel@vger.kernel.org>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH 4/5] Clocksource: Flextimer: Fix counter clock prescaler calculation.
Date: Tue, 26 Aug 2014 13:45:50 +0800
Message-ID: <1409031951-39021-5-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.5
In-Reply-To: <1409031951-39021-1-git-send-email-Li.Xiubo@freescale.com>
References: <1409031951-39021-1-git-send-email-Li.Xiubo@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199003)(104166001)(50466002)(76482001)(85306004)(79102001)(48376002)(97736001)(77982001)(31966008)(74502001)(74662001)(62966002)(87936001)(19580395003)(83322001)(69596002)(88136002)(44976005)(89996001)(90102001)(68736004)(6806004)(83072002)(19580405001)(85852003)(4396001)(50226001)(92566001)(92726001)(93916002)(86362001)(95666004)(105606002)(26826002)(81156004)(102836001)(106466001)(36756003)(77156001)(104016003)(87286001)(21056001)(84676001)(229853001)(64706001)(80022001)(99396002)(76176999)(50986999)(107046002)(46102001)(81342001)(20776003)(81542001)(47776003);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR0301MB0624;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03152A99FF
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should minus one after calculating the counter input clock's
prescaler.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
Signed-off-by: Jingchang Lu <jingchang.lu@freescale.com>
---
 drivers/clocksource/fsl_ftm_timer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clocksource/fsl_ftm_timer.c b/drivers/clocksource/fsl_ftm_timer.c
index f70fcf2..974890e 100644
--- a/drivers/clocksource/fsl_ftm_timer.c
+++ b/drivers/clocksource/fsl_ftm_timer.c
@@ -311,7 +311,7 @@ static int __init ftm_calc_closest_round_cyc(unsigned long freq)
 						HZ * (1 << priv->ps++));
 	} while (priv->periodic_cyc > 0xFFFF);
 
-	if (priv->ps > FTM_PS_MAX) {
+	if (--priv->ps > FTM_PS_MAX) {
 		pr_err("ftm: the prescaler is %lu > %d\n",
 				priv->ps, FTM_PS_MAX);
 		return -EINVAL;
-- 
1.8.5

