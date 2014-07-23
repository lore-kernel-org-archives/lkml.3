Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372AbaGWCiE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 22:38:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:55632 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755709AbaGWCiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 22:38:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,714,1400050800"; 
   d="scan'208";a="577336809"
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, tglx@linutronix.de, paulus@samba.org,
        benh@kernel.crashing.org, tony.luck@intel.com, hpa@zytor.com,
        jkosina@suse.cz, rafael.j.wysocki@intel.com, bp@alien8.de,
        linux@arm.linux.org.uk, ralf@linux-mips.org, schwidefsky@de.ibm.com,
        davem@davemloft.net, viro@zeniv.linux.org.uk, fweisbec@gmail.com,
        cl@linux.com, akpm@linux-foundation.org, axboe@kernel.dk,
        JBottomley@parallels.com, neilb@suse.de, christoffer.dall@linaro.org,
        rostedt@goodmis.org, rric@kernel.org, gregkh@linuxfoundation.org,
        mhocko@suse.cz, david@fromorbit.com,
        "Chen, Gong" <gong.chen@linux.intel.com>
Subject: [RFC PATCH v1 55/70] irqchip, irq-armada-370-xp: _FROZEN Cleanup
Date: Tue, 22 Jul 2014 21:59:31 -0400
Message-Id: <1406080786-3938-56-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
References: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove XXX_FROZEN state from irqchip/irq-armada-370-xp.

Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
---
 drivers/irqchip/irq-armada-370-xp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-armada-370-xp.c b/drivers/irqchip/irq-armada-370-xp.c
index 574aba0..1c46257 100644
--- a/drivers/irqchip/irq-armada-370-xp.c
+++ b/drivers/irqchip/irq-armada-370-xp.c
@@ -357,7 +357,7 @@ static void armada_xp_mpic_smp_cpu_init(void)
 static int armada_xp_mpic_secondary_init(struct notifier_block *nfb,
 					 unsigned long action, void *hcpu)
 {
-	if (action == CPU_STARTING || action == CPU_STARTING_FROZEN)
+	if ((action & ~CPU_TASKS_FROZEN) == CPU_STARTING)
 		armada_xp_mpic_smp_cpu_init();
 	return NOTIFY_OK;
 }
-- 
2.0.0.rc2

