Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943AbaDWCzo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 22:55:44 -0400
Received: from mail-bn1blp0183.outbound.protection.outlook.com ([207.46.163.183]:48478
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752874AbaDWCzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 22:55:43 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <daniel.lezcano@linaro.org>, <tglx@linutronix.de>,
        <linux-kernel@vger.kernel.org>
CC: Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv2 1/2] clocksource: fix type confusion for clocksource_mmio_readX_Y
Date: Wed, 23 Apr 2014 10:11:59 +0800
Message-ID: <1398219120-23029-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.246;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(428001)(199002)(189002)(92726001)(87286001)(79102001)(36756003)(2201001)(92566001)(85852003)(74662001)(74502001)(20776003)(77982001)(31966008)(86362001)(50986999)(83072002)(47776003)(575784001)(81342001)(93916002)(81542001)(19580395003)(88136002)(80976001)(87936001)(46102001)(62966002)(50226001)(50466002)(80022001)(83322001)(19580405001)(6806004)(4396001)(77156001)(44976005)(76482001)(48376002)(99396002)(77096999)(89996001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB505;H:az84smr01.freescale.net;FPR:FC15377A.6CEE5D2C.BEFDAB74.802A1C29.2018B;MLV:sfv;PTR:gate-az5.freescale.com;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Forefront-PRVS: 01901B3451
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The types' definations are:
   o  cycle_t       -> u64
   o  readl_relaxed -> u32
   o  readw_relaxed -> u16

So let clocksource_mmio_readX_Ys return a cast to cycle_t, though
this maybe look reduntant sometimes, it make sense and they will be
more readable and less confusion...

This patch clarifies the functions type and fix it.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/clocksource/mmio.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/clocksource/mmio.c b/drivers/clocksource/mmio.c
index c0e2512..19a6b3f 100644
--- a/drivers/clocksource/mmio.c
+++ b/drivers/clocksource/mmio.c
@@ -22,22 +22,22 @@ static inline struct clocksource_mmio *to_mmio_clksrc(struct clocksource *c)
 
 cycle_t clocksource_mmio_readl_up(struct clocksource *c)
 {
-	return readl_relaxed(to_mmio_clksrc(c)->reg);
+	return (cycle_t)readl_relaxed(to_mmio_clksrc(c)->reg);
 }
 
 cycle_t clocksource_mmio_readl_down(struct clocksource *c)
 {
-	return ~readl_relaxed(to_mmio_clksrc(c)->reg);
+	return ~(cycle_t)readl_relaxed(to_mmio_clksrc(c)->reg);
 }
 
 cycle_t clocksource_mmio_readw_up(struct clocksource *c)
 {
-	return readw_relaxed(to_mmio_clksrc(c)->reg);
+	return (cycle_t)readw_relaxed(to_mmio_clksrc(c)->reg);
 }
 
 cycle_t clocksource_mmio_readw_down(struct clocksource *c)
 {
-	return ~(unsigned)readw_relaxed(to_mmio_clksrc(c)->reg);
+	return ~(cycle_t)readw_relaxed(to_mmio_clksrc(c)->reg);
 }
 
 /**
-- 
1.8.4

