Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372AbaJTTGl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 15:06:41 -0400
Received: from mail-oi0-f74.google.com ([209.85.218.74]:44137 "EHLO
	mail-oi0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500AbaJTTEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 15:04:13 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Ralf Baechle <ralf@linux-mips.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Paul Burton <paul.burton@imgtec.com>,
        Qais Yousef <qais.yousef@imgtec.com>,
        John Crispin <blogic@openwrt.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 10/19] irqchip: mips-gic: Use GIC_SH_WEDGE_{SET,CLR} macros
Date: Mon, 20 Oct 2014 12:03:57 -0700
Message-Id: <1413831846-32100-11-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1413831846-32100-1-git-send-email-abrestic@chromium.org>
References: <1413831846-32100-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the GIC_SH_WEDGE_{SET,CLR} macros provided by mips-gic.h.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 drivers/irqchip/irq-mips-gic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-mips-gic.c b/drivers/irqchip/irq-mips-gic.c
index 188760c..165cf1e 100644
--- a/drivers/irqchip/irq-mips-gic.c
+++ b/drivers/irqchip/irq-mips-gic.c
@@ -206,7 +206,7 @@ static void gic_bind_eic_interrupt(int irq, int set)
 
 void gic_send_ipi(unsigned int intr)
 {
-	gic_write(GIC_REG(SHARED, GIC_SH_WEDGE), 0x80000000 | intr);
+	gic_write(GIC_REG(SHARED, GIC_SH_WEDGE), GIC_SH_WEDGE_SET(intr));
 }
 
 int gic_get_c0_compare_int(void)
@@ -270,7 +270,7 @@ static void gic_ack_irq(struct irq_data *d)
 {
 	unsigned int irq = GIC_HWIRQ_TO_SHARED(d->hwirq);
 
-	gic_write(GIC_REG(SHARED, GIC_SH_WEDGE), irq);
+	gic_write(GIC_REG(SHARED, GIC_SH_WEDGE), GIC_SH_WEDGE_CLR(irq));
 }
 
 static int gic_set_type(struct irq_data *d, unsigned int type)
-- 
2.1.0.rc2.206.gedb03e5

