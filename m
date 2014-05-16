Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765AbaEPNdU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:33:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54085 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915AbaEPNdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:33:17 -0400
Date: Fri, 16 May 2014 06:32:23 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-499c2b75e9c695b57faaf6a63fde391ff9e523a3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, grant.likely@linaro.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tony.luck@intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de,
        tony.luck@intel.com
In-Reply-To: <20140507154334.991589924@linutronix.de>
References: <20140507154334.991589924@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] x86: hpet: Use irq_alloc/free_hwirq()
Git-Commit-ID: 499c2b75e9c695b57faaf6a63fde391ff9e523a3
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

Commit-ID:  499c2b75e9c695b57faaf6a63fde391ff9e523a3
Gitweb:     http://git.kernel.org/tip/499c2b75e9c695b57faaf6a63fde391ff9e523a3
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 7 May 2014 15:44:07 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 16 May 2014 14:05:18 +0200

x86: hpet: Use irq_alloc/free_hwirq()

Use the new interfaces. No functional change.

This does not replace the requirement to move x86 to irq domains, but
it limits the mess to some degree.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Grant Likely <grant.likely@linaro.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org
Link: http://lkml.kernel.org/r/20140507154334.991589924@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/hpet.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 4177bfb..5f5a147 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -479,7 +479,7 @@ static int hpet_msi_next_event(unsigned long delta,
 static int hpet_setup_msi_irq(unsigned int irq)
 {
 	if (x86_msi.setup_hpet_msi(irq, hpet_blockid)) {
-		destroy_irq(irq);
+		irq_free_hwirq(irq);
 		return -EINVAL;
 	}
 	return 0;
@@ -487,9 +487,8 @@ static int hpet_setup_msi_irq(unsigned int irq)
 
 static int hpet_assign_irq(struct hpet_dev *dev)
 {
-	unsigned int irq;
+	unsigned int irq = irq_alloc_hwirq(-1);
 
-	irq = create_irq_nr(0, -1);
 	if (!irq)
 		return -EINVAL;
 
