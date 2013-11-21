Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060Ab3KURCF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 12:02:05 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:64854 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754676Ab3KURBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 12:01:20 -0500
Message-Id: <20131121170116.730958413@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 21 Nov 2013 11:59:50 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>, Wolfram Sang <wsa@the-dreams.de>,
        Anatolij Gustschin <agust@denx.de>
Subject: [PATCH RT 2/7] Kind of revert "powerpc: 52xx: provide a default in
 mpc52xx_irqhost_map()"
References: <20131121165948.354971355@goodmis.org>
Content-Disposition: inline; filename=0002-Kind-of-revert-powerpc-52xx-provide-a-default-in-mpc.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.13-rt25-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <wsa@the-dreams.de>

This more or less reverts commit 6391f697d4892a6f233501beea553e13f7745a23.
Instead of adding an unneeded 'default', mark the variable to prevent
the false positive 'uninitialized var'. The other change (fixing the
printout) needs revert, too. We want to know WHICH critical irq failed,
not which level it had.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Cc: stable-rt@vger.kernel.org
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Anatolij Gustschin <agust@denx.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/powerpc/platforms/52xx/mpc52xx_pic.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/platforms/52xx/mpc52xx_pic.c b/arch/powerpc/platforms/52xx/mpc52xx_pic.c
index b69221b..2898b73 100644
--- a/arch/powerpc/platforms/52xx/mpc52xx_pic.c
+++ b/arch/powerpc/platforms/52xx/mpc52xx_pic.c
@@ -340,7 +340,7 @@ static int mpc52xx_irqhost_map(struct irq_domain *h, unsigned int virq,
 {
 	int l1irq;
 	int l2irq;
-	struct irq_chip *irqchip;
+	struct irq_chip *uninitialized_var(irqchip);
 	void *hndlr;
 	int type;
 	u32 reg;
@@ -373,9 +373,8 @@ static int mpc52xx_irqhost_map(struct irq_domain *h, unsigned int virq,
 	case MPC52xx_IRQ_L1_PERP: irqchip = &mpc52xx_periph_irqchip; break;
 	case MPC52xx_IRQ_L1_SDMA: irqchip = &mpc52xx_sdma_irqchip; break;
 	case MPC52xx_IRQ_L1_CRIT:
-	default:
 		pr_warn("%s: Critical IRQ #%d is unsupported! Nopping it.\n",
-			__func__, l1irq);
+			__func__, l2irq);
 		irq_set_chip(virq, &no_irq_chip);
 		return 0;
 	}
-- 
1.8.4.rc3


