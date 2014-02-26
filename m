Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255AbaBZTi2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 14:38:28 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:41009 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230AbaBZTiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 14:38:21 -0500
From: Sebastian Capella <sebastian.capella@linaro.org>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linaro-kernel@lists.linaro.org, linux-arm-kernel@lists.infradead.org
Cc: Sebastian Capella <sebastian.capella@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will.deacon@arm.com>, Robin Holt <robin.m.holt@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH v5 1/2] ARM: avoid tracers in soft_restart
Date: Wed, 26 Feb 2014 11:38:09 -0800
Message-Id: <1393443490-18116-2-git-send-email-sebastian.capella@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1393443490-18116-1-git-send-email-sebastian.capella@linaro.org>
References: <1393443490-18116-1-git-send-email-sebastian.capella@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use of tracers in local_irq_disable is causes recursive aborts when
called with irqs disabled and using a temporary stack (hibernation).
Replace local_irq_disable with raw_local_irq_disable instead to
avoid tracers.

Signed-off-by: Sebastian Capella <sebastian.capella@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Robin Holt <robin.m.holt@gmail.com>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
---
 arch/arm/kernel/process.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 92f7b15..f58b723 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -100,7 +100,7 @@ void soft_restart(unsigned long addr)
 	u64 *stack = soft_restart_stack + ARRAY_SIZE(soft_restart_stack);
 
 	/* Disable interrupts first */
-	local_irq_disable();
+	raw_local_irq_disable();
 	local_fiq_disable();
 
 	/* Disable the L2 if we're the last man standing. */
-- 
1.7.9.5

