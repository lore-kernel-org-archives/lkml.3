Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347AbaLCHuc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 02:50:32 -0500
Received: from mga11.intel.com ([192.55.52.93]:60624 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752256AbaLCHu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 02:50:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,506,1413270000"; 
   d="scan'208";a="631852414"
From: Feng Wu <feng.wu@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        gleb@kernel.org, pbonzini@redhat.com, dwmw2@infradead.org,
        joro@8bytes.org, alex.williamson@redhat.com, jiang.liu@linux.intel.com
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, Feng Wu <feng.wu@intel.com>
Subject: [v2 16/25] KVM: make kvm_set_msi_irq() public
Date: Wed,  3 Dec 2014 15:39:45 +0800
Message-Id: <1417592394-24343-17-git-send-email-feng.wu@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1417592394-24343-1-git-send-email-feng.wu@intel.com>
References: <1417592394-24343-1-git-send-email-feng.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make kvm_set_msi_irq() public, we can use this function outside.

Signed-off-by: Feng Wu <feng.wu@intel.com>
---
 include/linux/kvm_host.h |    2 ++
 virt/kvm/irq_comm.c      |    2 +-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index cfa85ac..5cd4420 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -785,6 +785,8 @@ void kvm_unregister_irq_ack_notifier(struct kvm *kvm,
 				   struct kvm_irq_ack_notifier *kian);
 int kvm_request_irq_source_id(struct kvm *kvm);
 void kvm_free_irq_source_id(struct kvm *kvm, int irq_source_id);
+void kvm_set_msi_irq(struct kvm_kernel_irq_routing_entry *e,
+		     struct kvm_lapic_irq *irq);
 
 #ifdef CONFIG_KVM_DEVICE_ASSIGNMENT
 int kvm_iommu_map_pages(struct kvm *kvm, struct kvm_memory_slot *slot);
diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
index f3c5d69..231671a 100644
--- a/virt/kvm/irq_comm.c
+++ b/virt/kvm/irq_comm.c
@@ -106,7 +106,7 @@ int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
 	return r;
 }
 
-static inline void kvm_set_msi_irq(struct kvm_kernel_irq_routing_entry *e,
+void kvm_set_msi_irq(struct kvm_kernel_irq_routing_entry *e,
 				   struct kvm_lapic_irq *irq)
 {
 	trace_kvm_msi_set_irq(e->msi.address_lo, e->msi.data);
-- 
1.7.1

