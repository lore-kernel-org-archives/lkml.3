Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943AbaG3TX7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 15:23:59 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35652 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755499AbaG3TX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 15:23:57 -0400
From: Mark Brown <broonie@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
Cc: Geoff Levand <geoff@infradead.org>, Marc Zyngier <marc.zyngier@arm.com>,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org, Mark Brown <broonie@linaro.org>
Date: Wed, 30 Jul 2014 20:23:14 +0100
Message-Id: <1406748194-21094-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 2.0.1
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] irq: gic-v3: Tag all low level accessors __maybey_unused
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

This is only really needed for gic_write_sgi1r in the !SMP case since it
is only referenced in the SMP initialisation code but it seems better to
have these functions all next to each other and declared consistently.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/irqchip/irq-gic-v3.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index 41b98ba7ffd1..f1ba38f11f7a 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -104,7 +104,7 @@ static void gic_redist_wait_for_rwp(void)
 }
 
 /* Low level accessors */
-static u64 gic_read_iar(void)
+static u64 __maybe_unused gic_read_iar(void)
 {
 	u64 irqstat;
 
@@ -112,24 +112,24 @@ static u64 gic_read_iar(void)
 	return irqstat;
 }
 
-static void gic_write_pmr(u64 val)
+static void __maybe_unused gic_write_pmr(u64 val)
 {
 	asm volatile("msr_s " __stringify(ICC_PMR_EL1) ", %0" : : "r" (val));
 }
 
-static void gic_write_ctlr(u64 val)
+static void __maybe_unused gic_write_ctlr(u64 val)
 {
 	asm volatile("msr_s " __stringify(ICC_CTLR_EL1) ", %0" : : "r" (val));
 	isb();
 }
 
-static void gic_write_grpen1(u64 val)
+static void __maybe_unused gic_write_grpen1(u64 val)
 {
 	asm volatile("msr_s " __stringify(ICC_GRPEN1_EL1) ", %0" : : "r" (val));
 	isb();
 }
 
-static void gic_write_sgi1r(u64 val)
+static void __maybe_unused gic_write_sgi1r(u64 val)
 {
 	asm volatile("msr_s " __stringify(ICC_SGI1R_EL1) ", %0" : : "r" (val));
 }
-- 
2.0.1

