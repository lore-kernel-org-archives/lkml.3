Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab3JBMlp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 08:41:45 -0400
Received: from 10.mo4.mail-out.ovh.net ([188.165.33.109]:49838 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753882Ab3JBMld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 08:41:33 -0400
X-Greylist: delayed 387 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Oct 2013 08:41:32 EDT
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.4 (mo4.mail-out.ovh.net)
Subject: [PATCH 3/3] ARM: at91/tc/clocksource: remove IRQF_DISABLED
Date: Wed,  2 Oct 2013 14:35:48 +0200
Message-Id: <1380717348-6650-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1380717265-6497-1-git-send-email-b.brezillon@overkiz.com>
References: <1380717265-6497-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 1379790336659322988
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrudegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrudegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the deprecated IRQF_DISABLED flag.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 drivers/clocksource/tcb_clksrc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clocksource/tcb_clksrc.c b/drivers/clocksource/tcb_clksrc.c
index 10a5d9e..00fdd11 100644
--- a/drivers/clocksource/tcb_clksrc.c
+++ b/drivers/clocksource/tcb_clksrc.c
@@ -180,7 +180,7 @@ static irqreturn_t ch2_irq(int irq, void *handle)
 
 static struct irqaction tc_irqaction = {
 	.name		= "tc_clkevt",
-	.flags		= IRQF_TIMER | IRQF_DISABLED,
+	.flags		= IRQF_TIMER,
 	.handler	= ch2_irq,
 };
 
-- 
1.7.9.5

