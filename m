Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360AbaEPNgl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:36:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54277 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757296AbaEPNgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:36:39 -0400
Date: Fri, 16 May 2014 06:35:47 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-e8784e4f9a578344023ae4e08a509b7c5eab5eb0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, grant.likely@linaro.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tony.luck@intel.com,
        fenghua.yu@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        tony.luck@intel.com, fenghua.yu@intel.com, tglx@linutronix.de
In-Reply-To: <20140507154338.700598389@linutronix.de>
References: <20140507154338.700598389@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Make create/destroy_irq() ia64 private
Git-Commit-ID: e8784e4f9a578344023ae4e08a509b7c5eab5eb0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e8784e4f9a578344023ae4e08a509b7c5eab5eb0
Gitweb:     http://git.kernel.org/tip/e8784e4f9a578344023ae4e08a509b7c5eab5eb0
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 7 May 2014 15:44:17 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 16 May 2014 14:05:21 +0200

genirq: Make create/destroy_irq() ia64 private

No more users outside of itanic. Confine it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Grant Likely <grant.likely@linaro.org>
Tested-by: Tony Luck <tony.luck@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/20140507154338.700598389@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/ia64/include/asm/irq.h | 3 +++
 include/linux/irq.h         | 4 ----
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/ia64/include/asm/irq.h b/arch/ia64/include/asm/irq.h
index 91b920fd..820667c 100644
--- a/arch/ia64/include/asm/irq.h
+++ b/arch/ia64/include/asm/irq.h
@@ -31,4 +31,7 @@ bool is_affinity_mask_valid(const struct cpumask *cpumask);
 
 #define is_affinity_mask_valid is_affinity_mask_valid
 
+int create_irq(void);
+void destroy_irq(unsigned int irq);
+
 #endif /* _ASM_IA64_IRQ_H */
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 7549ed5..ac96342 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -525,10 +525,6 @@ static inline void irq_set_percpu_devid_flags(unsigned int irq)
 			     IRQ_NOPROBE | IRQ_PER_CPU_DEVID);
 }
 
-/* Handle dynamic irq creation and destruction */
-extern int create_irq(void);
-extern void destroy_irq(unsigned int irq);
-
 /*
  * Dynamic irq helper functions. Obsolete. Use irq_alloc_desc* and
  * irq_free_desc instead.
