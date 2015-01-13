Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbbAMRfs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 12:35:48 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:36007 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbbAMRfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 12:35:46 -0500
X-Greylist: delayed 97417 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Jan 2015 12:35:45 EST
From: Eric Auger <eric.auger@linaro.org>
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org,
        marc.zyngier@arm.com, andre.przywara@arm.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, alex.williamson@redhat.com, agraf@suse.de,
        joel.schopp@amd.com, kim.phillips@freescale.com, paulus@samba.org,
        gleb@kernel.org, pbonzini@redhat.com, borntraeger@de.ibm.com,
        cornelia.huck@de.ibm.com
Cc: linux-kernel@vger.kernel.org, patches@linaro.org, will.deacon@arm.com,
        a.motakis@virtualopensystems.com, a.rigo@virtualopensystems.com,
        john.liuli@huawei.com, ming.lei@canonical.com, feng.wu@intel.com,
        b.reynal@virtualopensystems.com
Subject: [PATCH v6 2/4] KVM: introduce kvm_arch_intc_initialized
Date: Tue, 13 Jan 2015 18:33:38 +0100
Message-Id: <1421170420-30617-3-git-send-email-eric.auger@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421170420-30617-1-git-send-email-eric.auger@linaro.org>
References: <1421170420-30617-1-git-send-email-eric.auger@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce __KVM_HAVE_ARCH_INTC_INITIALIZED define and
associated kvm_arch_intc_initialized function. This latter
allows to test whether the virtual interrupt controller is initialized
and ready to accept virtual IRQ injection. On some architectures,
the virtual interrupt controller is dynamically instantiated, justifying
that kind of check.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

v5 -> v6:
- rename function name and macro
- add kvm_arch_intc_initialized declaration in case the archi defines
  the macro
---
 include/linux/kvm_host.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 26f1060..702036a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -706,6 +706,20 @@ static inline wait_queue_head_t *kvm_arch_vcpu_wq(struct kvm_vcpu *vcpu)
 #endif
 }
 
+#ifdef __KVM_HAVE_ARCH_INTC_INITIALIZED
+/*
+ * returns trues if the virtual interrupt controller is initialized and
+ * ready to accept virtual IRQ. On some architectures the virtual interrupt
+ * controller is dynamically instantiated and this is not always true.
+ */
+bool kvm_arch_intc_initialized(struct kvm *kvm);
+#else
+static inline bool kvm_arch_intc_initialized(struct kvm *kvm)
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

