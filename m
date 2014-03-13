Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338AbaCMQBt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 12:01:49 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:40841 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbaCMP6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 11:58:03 -0400
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: kvmarm@lists.cs.columbia.edu
Cc: tech@virtualopensystems.com, n.nikolaev@virtualopensystems.com,
        agraf@suse.de, christoffer.dall@linaro.org, marc.zyngier@arm.com,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org (open list:KERNEL VIRTUAL MA...),
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC PATCH 2/4] KVM: irqfd should depend on CONFIG_HAVE_KVM_IRQ_ROUTING
Date: Thu, 13 Mar 2014 16:57:27 +0100
Message-Id: <1394726249-1547-3-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1394726249-1547-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1394726249-1547-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With an ARM VGIC we have an IRQ chip in the kernel (using the hardware
support), but the irqfd feature is still not available due to a dependency
on IRQ routing. The prototypes of kvm_irqfd and kvm_irqfd_release should
be conditionally compiled depending on HAVE_KVM_IRQ_ROUTING instead of
HAVE_KVM_IRQCHIP.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
Signed-off-by: Nikolay Nikolaev <n.nikolaev@virtualopensystems.com>
---
 include/linux/kvm_host.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index b8e9a43..8728159 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -936,7 +936,7 @@ static inline void kvm_free_irq_routing(struct kvm *kvm) {}
 void kvm_eventfd_init(struct kvm *kvm);
 int kvm_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args);
 
-#ifdef CONFIG_HAVE_KVM_IRQCHIP
+#ifdef CONFIG_HAVE_KVM_IRQ_ROUTING
 int kvm_irqfd(struct kvm *kvm, struct kvm_irqfd *args);
 void kvm_irqfd_release(struct kvm *kvm);
 void kvm_irq_routing_update(struct kvm *, struct kvm_irq_routing_table *);
-- 
1.8.3.2

