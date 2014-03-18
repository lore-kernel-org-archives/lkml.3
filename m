Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246AbaCRVlF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 17:41:05 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:51744 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756975AbaCRVlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 17:41:01 -0400
From: Sebastian Capella <sebastian.capella@linaro.org>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linaro-kernel@lists.linaro.org, linux-arm-kernel@lists.infradead.org
Cc: Sebastian Capella <sebastian.capella@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Will Deacon <will.deacon@arm.com>, Robin Holt <holt@sgi.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Konstantin Khlebnikov <k.khlebnikov@samsung.com>,
        Steven Capper <steve.capper@linaro.org>,
        Stephen Warren <swarren@nvidia.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH v9 1/2] ARM: avoid tracers in soft_restart
Date: Tue, 18 Mar 2014 14:40:57 -0700
Message-Id: <1395178858-27343-2-git-send-email-sebastian.capella@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1395178858-27343-1-git-send-email-sebastian.capella@linaro.org>
References: <1395178858-27343-1-git-send-email-sebastian.capella@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use of tracers in local_irq_disable is causes abort loops when called
with irqs disabled using a temporary stack.  Replace local_irq_disable
with raw_local_irq_disable instead to avoid tracers.

Signed-off-by: Sebastian Capella <sebastian.capella@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Robin Holt <holt@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Cc: Steven Capper <steve.capper@linaro.org>
Cc: Stephen Warren <swarren@nvidia.com>
Cc: Tejun Heo <tj@kernel.org>
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

