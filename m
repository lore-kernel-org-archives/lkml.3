Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbaIEG0x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 02:26:53 -0400
Received: from mail-bn1bon0137.outbound.protection.outlook.com ([157.56.111.137]:58000
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752283AbaIEG0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 02:26:48 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <daniel.lezcano@linaro.org>, <tglx@linutronix.de>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv2 3/4] Clocksource: Flextimer: Set cpumask to cpu_possible_mask
Date: Fri, 5 Sep 2014 13:02:19 +0800
Message-ID: <1409893340-30027-4-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1409893340-30027-1-git-send-email-Li.Xiubo@freescale.com>
References: <1409893340-30027-1-git-send-email-Li.Xiubo@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019016)(6009001)(189002)(199003)(105606002)(104166001)(26826002)(95666004)(81542001)(46102001)(81342001)(229853001)(64706001)(47776003)(50986999)(74502001)(76176999)(68736004)(74662001)(87286001)(80022001)(20776003)(104016003)(102836001)(36756003)(48376002)(83322001)(97736001)(84676001)(107046002)(44976005)(19580405001)(99396002)(50226001)(6806004)(92726001)(4396001)(85852003)(106466001)(83072002)(93916002)(575784001)(86362001)(89996001)(77982001)(92566001)(62966002)(79102001)(50466002)(31966008)(77156001)(85306004)(88136002)(76482001)(19580395003)(90102001)(21056001)(87936001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB0622;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0325F6C77B
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Flextimer is not tied to CPU0, make it usable on any CPU.
For Vybrid there is only one CPU, while for LS1+ there are more
than one.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 drivers/clocksource/fsl_ftm_timer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clocksource/fsl_ftm_timer.c b/drivers/clocksource/fsl_ftm_timer.c
index ccb8c32..c0ce603 100644
--- a/drivers/clocksource/fsl_ftm_timer.c
+++ b/drivers/clocksource/fsl_ftm_timer.c
@@ -214,7 +214,7 @@ static int __init ftm_clockevent_init(unsigned long freq, int irq)
 		return err;
 	}
 
-	ftm_clockevent.cpumask = cpumask_of(0);
+	ftm_clockevent.cpumask = cpu_all_mask;
 	ftm_clockevent.irq = irq;
 
 	clockevents_config_and_register(&ftm_clockevent,
-- 
2.1.0.27.g96db324

