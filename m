Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445AbaLCQLy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 11:11:54 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:61562 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbaLCQJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 11:09:01 -0500
From: Eric Auger <eric.auger@linaro.org>
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org,
        marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        alex.williamson@redhat.com, agraf@suse.de, joel.schopp@amd.com,
        gleb@kernel.org, pbonzini@redhat.com, borntraeger@de.ibm.com,
        cornelia.huck@de.ibm.com
Cc: linux-kernel@vger.kernel.org, patches@linaro.org,
        a.motakis@virtualopensystems.com
Subject: [PATCH v5 2/5] KVM: introduce kvm_arch_is_virtual_intc_initialized
Date: Wed,  3 Dec 2014 17:07:09 +0100
Message-Id: <1417622832-5460-3-git-send-email-eric.auger@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417622832-5460-1-git-send-email-eric.auger@linaro.org>
References: <1417622832-5460-1-git-send-email-eric.auger@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce __KVM_HAVE_ARCH_VIRTUAL_INTC_INITIALIZED define and
associated kvm_arch_is_virtual_intc_initialized function. This latter
allows to test whether the virtual interrupt controller is initialized
and ready to accept virtual IRQ injection. On some architectures,
the virtual interrupt controller is dynamically instantiated, justifying
that kind of check.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 include/linux/kvm_host.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ea53b04..45fea3c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -696,6 +696,18 @@ static inline wait_queue_head_t *kvm_arch_vcpu_wq(struct kvm_vcpu *vcpu)
 #endif
 }
 
+#ifndef __KVM_HAVE_ARCH_VIRTUAL_INTC_INITIALIZED
+/*
+ * returns trues if the virtual interrupt controller is initialized and
+ * ready to accept virtual IRQ. On some architectures the virtual interrupt
+ * controller is dynamically instantiated and this is not always true.
+ */
+static inline bool kvm_arch_is_virtual_intc_initialized(struct kvm *kvm)
+{
+	return true;
+}
+#endif
+
 int kvm_arch_init_vm(struct kvm *kvm, unsigned long type);
 void kvm_arch_destroy_vm(struct kvm *kvm);
 void kvm_arch_sync_events(struct kvm *kvm);
-- 
1.9.1

