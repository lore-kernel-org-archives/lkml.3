Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbaF2J3A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 05:29:00 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:17249 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383AbaF2J26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 05:28:58 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgkCAHjbr1OERCABjGdsb2JhbABZr0UBAQaDbY8Dh0WBCBYPAQEBJzyEMVKBUYhCwAyFexeFZIkjHYQtBYpBp18
X-IPAS-Result: AgkCAHjbr1OERCABjGdsb2JhbABZr0UBAQaDbY8Dh0WBCBYPAQEBJzyEMVKBUYhCwAyFexeFZIkjHYQtBYpBp18
X-IronPort-AV: E=Sophos;i="5.01,569,1400014800"; 
   d="scan'208";a="113580671"
From: Nadav Amit <namit@cs.technion.ac.il>
To: pbonzini@redhat.com
Cc: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH] KVM: x86: Fix lapic.c debug prints
Date: Sun, 29 Jun 2014 12:28:51 +0300
Message-Id: <1404034131-2392-1-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In two cases lapic.c does not use the apic_debug macro correctly. This patch
fixes them.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
 arch/x86/kvm/lapic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 0069118..3855103 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1451,7 +1451,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu)
 	vcpu->arch.apic_arb_prio = 0;
 	vcpu->arch.apic_attention = 0;
 
-	apic_debug(KERN_INFO "%s: vcpu=%p, id=%d, base_msr="
+	apic_debug("%s: vcpu=%p, id=%d, base_msr="
 		   "0x%016" PRIx64 ", base_address=0x%0lx.\n", __func__,
 		   vcpu, kvm_apic_id(apic),
 		   vcpu->arch.apic_base, apic->base_address);
@@ -1895,7 +1895,7 @@ void kvm_apic_accept_events(struct kvm_vcpu *vcpu)
 		/* evaluate pending_events before reading the vector */
 		smp_rmb();
 		sipi_vector = apic->sipi_vector;
-		pr_debug("vcpu %d received sipi with vector # %x\n",
+		apic_debug("vcpu %d received sipi with vector # %x\n",
 			 vcpu->vcpu_id, sipi_vector);
 		kvm_vcpu_deliver_sipi_vector(vcpu, sipi_vector);
 		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
-- 
1.9.1

