Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932966AbaGWCkk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 22:40:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:16204 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932464AbaGWCki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 22:40:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,714,1400050800"; 
   d="scan'208";a="577337857"
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
Subject: [RFC PATCH v1 63/70] virt, kvm, arm, vgic: _FROZEN Cleanup
Date: Tue, 22 Jul 2014 21:59:39 -0400
Message-Id: <1406080786-3938-64-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
References: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove XXX_FROZEN state from kvm/arm/vgic.

Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
---
 virt/kvm/arm/vgic.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 56ff9be..f93b8c5 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -1452,13 +1452,11 @@ static void vgic_init_maintenance_interrupt(void *info)
 static int vgic_cpu_notify(struct notifier_block *self,
 			   unsigned long action, void *cpu)
 {
-	switch (action) {
+	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_STARTING:
-	case CPU_STARTING_FROZEN:
 		vgic_init_maintenance_interrupt(NULL);
 		break;
 	case CPU_DYING:
-	case CPU_DYING_FROZEN:
 		disable_percpu_irq(vgic_maint_irq);
 		break;
 	}
-- 
2.0.0.rc2

