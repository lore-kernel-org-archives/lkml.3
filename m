Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719AbaE1Krz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 06:47:55 -0400
Received: from mail-bl2lp0211.outbound.protection.outlook.com ([207.46.163.211]:7808
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752510AbaE1Krx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 06:47:53 -0400
From: Liu Ying <Ying.Liu@freescale.com>
To: <linux-pwm@vger.kernel.org>
CC: <thierry.reding@gmail.com>, <s.hauer@pengutronix.de>,
        <shawn.guo@freescale.com>, <LW@KARO-electronics.de>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] pwm: i.MX: Fix the macro MX3_PWMCR_PRESCALER(x) definition
Date: Wed, 28 May 2014 18:50:11 +0800
Message-ID: <1401274213-8954-1-git-send-email-Ying.Liu@freescale.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(97736001)(77096999)(50986999)(99396002)(84676001)(85852003)(87286001)(87936001)(31966008)(104166001)(4396001)(74662001)(50226001)(19580395003)(68736004)(88136002)(44976005)(62966002)(102836001)(83322001)(92726001)(80022001)(23676002)(36756003)(21056001)(26826002)(93916002)(81542001)(20776003)(86362001)(50466002)(6806004)(83072002)(575784001)(74502001)(89996001)(64706001)(79102001)(46102001)(104016001)(92566001)(77156001)(77982001)(81342001)(76482001)(19580405001)(47776003);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB343;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 0225B0D5BC
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Ying.Liu@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds missing parentheses around the argument
of the macro MX3_PWMCR_PRESCALER(x) to avoid any potential
macro expansion issue.

Reported-by: Lothar Waßmann <LW@KARO-electronics.de>
Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Shawn Guo <shawn.guo@freescale.com>
Cc: Lothar Waßmann <LW@KARO-electronics.de>
Cc: linux-pwm@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
---
 drivers/pwm/pwm-imx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pwm/pwm-imx.c b/drivers/pwm/pwm-imx.c
index cc47733..9835e0b 100644
--- a/drivers/pwm/pwm-imx.c
+++ b/drivers/pwm/pwm-imx.c
@@ -32,7 +32,7 @@
 #define MX3_PWMCR                 0x00    /* PWM Control Register */
 #define MX3_PWMSAR                0x0C    /* PWM Sample Register */
 #define MX3_PWMPR                 0x10    /* PWM Period Register */
-#define MX3_PWMCR_PRESCALER(x)    (((x - 1) & 0xFFF) << 4)
+#define MX3_PWMCR_PRESCALER(x)    ((((x) - 1) & 0xFFF) << 4)
 #define MX3_PWMCR_DOZEEN                (1 << 24)
 #define MX3_PWMCR_WAITEN                (1 << 23)
 #define MX3_PWMCR_DBGEN			(1 << 22)
-- 
1.7.9.5

