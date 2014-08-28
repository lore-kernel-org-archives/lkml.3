Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751714AbaH1NOI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 09:14:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107AbaH1NOC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 09:14:02 -0400
From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, kvm-ia64@vger.kernel.org,
        linux-s390@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH 1/2] KVM: static inline empty kvm_arch functions
Date: Thu, 28 Aug 2014 15:13:02 +0200
Message-Id: <1409231583-7048-2-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1409231583-7048-1-git-send-email-rkrcmar@redhat.com>
References: <1409231583-7048-1-git-send-email-rkrcmar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using static inline is going to save few bytes and cycles.
For example on powerpc, the difference is 700 B after stripping.
(5 kB before)

This patch also deals with two overlooked empty functions:
kvm_arch_flush_shadow was not removed from arch/mips/kvm/mips.c
  2df72e9bc KVM: split kvm_arch_flush_shadow
and kvm_arch_sched_in never made it into arch/ia64/kvm/kvm-ia64.c.
  e790d9ef6 KVM: add kvm_arch_sched_in

Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
---
 arch/arm/include/asm/kvm_host.h     |  6 ++++++
 arch/arm/kvm/arm.c                  | 19 ----------------
 arch/arm64/include/asm/kvm_host.h   |  6 ++++++
 arch/ia64/include/asm/kvm_host.h    | 12 +++++++++++
 arch/ia64/kvm/kvm-ia64.c            | 30 --------------------------
 arch/mips/include/asm/kvm_host.h    | 11 ++++++++++
 arch/mips/kvm/mips.c                | 42 ------------------------------------
 arch/powerpc/include/asm/kvm_host.h |  8 +++++++
 arch/powerpc/kvm/powerpc.c          | 29 -------------------------
 arch/s390/include/asm/kvm_host.h    | 14 ++++++++++++
 arch/s390/kvm/kvm-s390.c            | 43 -------------------------------------
 11 files changed, 57 insertions(+), 163 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 6dfb404..84291fe 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -233,4 +233,10 @@ static inline void vgic_arch_setup(const struct vgic_params *vgic)
 int kvm_perf_init(void);
 int kvm_perf_teardown(void);
 
+static inline void kvm_arch_hardware_disable(void *garbage) {}
+static inline void kvm_arch_hardware_unsetup(void) {}
+static inline void kvm_arch_sync_events(struct kvm *kvm) {}
+static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
+static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
+
 #endif /* __ARM_KVM_HOST_H__ */
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 9f788eb..132bb0d 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -97,27 +97,16 @@ int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
 	return kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE;
 }
 
-void kvm_arch_hardware_disable(void *garbage)
-{
-}
-
 int kvm_arch_hardware_setup(void)
 {
 	return 0;
 }
 
-void kvm_arch_hardware_unsetup(void)
-{
-}
-
 void kvm_arch_check_processor_compat(void *rtn)
 {
 	*(int *)rtn = 0;
 }
 
-void kvm_arch_sync_events(struct kvm *kvm)
-{
-}
 
 /**
  * kvm_arch_init_vm - initializes a VM data structure
@@ -284,14 +273,6 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu)
-{
-}
-
-void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
-{
-}
-
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	vcpu->cpu = cpu;
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e10c45a..94d8a3c 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -244,4 +244,10 @@ static inline void vgic_arch_setup(const struct vgic_params *vgic)
 	}
 }
 
+static inline void kvm_arch_hardware_disable(void *garbage) {}
+static inline void kvm_arch_hardware_unsetup(void) {}
+static inline void kvm_arch_sync_events(struct kvm *kvm) {}
+static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
+static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/ia64/include/asm/kvm_host.h b/arch/ia64/include/asm/kvm_host.h
index db95f57..353167d 100644
--- a/arch/ia64/include/asm/kvm_host.h
+++ b/arch/ia64/include/asm/kvm_host.h
@@ -595,6 +595,18 @@ void kvm_sal_emul(struct kvm_vcpu *vcpu);
 struct kvm *kvm_arch_alloc_vm(void);
 void kvm_arch_free_vm(struct kvm *kvm);
 
+static inline void kvm_arch_sync_events(struct kvm *kvm) {}
+static inline void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu) {}
+static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu) {}
+static inline void kvm_arch_free_memslot(struct kvm *kvm,
+		struct kvm_memory_slot *free, struct kvm_memory_slot *dont) {}
+static inline void kvm_arch_memslots_updated(struct kvm *kvm) {}
+static inline void kvm_arch_commit_memory_region(struct kvm *kvm,
+		struct kvm_userspace_memory_region *mem,
+		const struct kvm_memory_slot *old,
+		enum kvm_mr_change change) {}
+static inline void kvm_arch_hardware_unsetup(void) {}
+
 #endif /* __ASSEMBLY__*/
 
 #endif
diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index 0729ba6..5e14dca 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -1364,10 +1364,6 @@ static void kvm_release_vm_pages(struct kvm *kvm)
 	}
 }
 
-void kvm_arch_sync_events(struct kvm *kvm)
-{
-}
-
 void kvm_arch_destroy_vm(struct kvm *kvm)
 {
 	kvm_iommu_unmap_guest(kvm);
@@ -1376,10 +1372,6 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	kvm_release_vm_pages(kvm);
 }
 
-void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
-{
-}
-
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	if (cpu != vcpu->cpu) {
@@ -1468,7 +1460,6 @@ void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu)
 	kfree(vcpu->arch.apic);
 }
 
-
 long kvm_arch_vcpu_ioctl(struct file *filp,
 			 unsigned int ioctl, unsigned long arg)
 {
@@ -1551,21 +1542,12 @@ int kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
 	return VM_FAULT_SIGBUS;
 }
 
-void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free,
-			   struct kvm_memory_slot *dont)
-{
-}
-
 int kvm_arch_create_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
 			    unsigned long npages)
 {
 	return 0;
 }
 
-void kvm_arch_memslots_updated(struct kvm *kvm)
-{
-}
-
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
 		struct kvm_memory_slot *memslot,
 		struct kvm_userspace_memory_region *mem,
@@ -1597,14 +1579,6 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	return 0;
 }
 
-void kvm_arch_commit_memory_region(struct kvm *kvm,
-		struct kvm_userspace_memory_region *mem,
-		const struct kvm_memory_slot *old,
-		enum kvm_mr_change change)
-{
-	return;
-}
-
 void kvm_arch_flush_shadow_all(struct kvm *kvm)
 {
 	kvm_flush_remote_tlbs(kvm);
@@ -1853,10 +1827,6 @@ int kvm_arch_hardware_setup(void)
 	return 0;
 }
 
-void kvm_arch_hardware_unsetup(void)
-{
-}
-
 int kvm_apic_set_irq(struct kvm_vcpu *vcpu, struct kvm_lapic_irq *irq)
 {
 	return __apic_accept_irq(vcpu, irq->vector);
diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index 7a3fc67..b4d900a 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -767,5 +767,16 @@ extern int kvm_mips_trans_mtc0(uint32_t inst, uint32_t *opc,
 extern void kvm_mips_dump_stats(struct kvm_vcpu *vcpu);
 extern unsigned long kvm_mips_get_ramsize(struct kvm *kvm);
 
+static inline void kvm_arch_hardware_disable(void *garbage) {}
+static inline void kvm_arch_hardware_unsetup(void) {}
+static inline void kvm_arch_sync_events(struct kvm *kvm) {}
+static inline void kvm_arch_free_memslot(struct kvm *kvm,
+		struct kvm_memory_slot *free, struct kvm_memory_slot *dont) {}
+static inline void kvm_arch_memslots_updated(struct kvm *kvm) {}
+static inline void kvm_arch_flush_shadow_all(struct kvm *kvm) {}
+static inline void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
+		struct kvm_memory_slot *slot) {}
+static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
+static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 
 #endif /* __MIPS_KVM_HOST_H__ */
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 2362df2..0ec7490 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -82,19 +82,11 @@ int kvm_arch_hardware_enable(void *garbage)
 	return 0;
 }
 
-void kvm_arch_hardware_disable(void *garbage)
-{
-}
-
 int kvm_arch_hardware_setup(void)
 {
 	return 0;
 }
 
-void kvm_arch_hardware_unsetup(void)
-{
-}
-
 void kvm_arch_check_processor_compat(void *rtn)
 {
 	*(int *)rtn = 0;
@@ -163,10 +155,6 @@ void kvm_mips_free_vcpus(struct kvm *kvm)
 	mutex_unlock(&kvm->lock);
 }
 
-void kvm_arch_sync_events(struct kvm *kvm)
-{
-}
-
 static void kvm_mips_uninit_tlbs(void *arg)
 {
 	/* Restore wired count */
@@ -194,21 +182,12 @@ long kvm_arch_dev_ioctl(struct file *filp, unsigned int ioctl,
 	return -ENOIOCTLCMD;
 }
 
-void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free,
-			   struct kvm_memory_slot *dont)
-{
-}
-
 int kvm_arch_create_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
 			    unsigned long npages)
 {
 	return 0;
 }
 
-void kvm_arch_memslots_updated(struct kvm *kvm)
-{
-}
-
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				   struct kvm_memory_slot *memslot,
 				   struct kvm_userspace_memory_region *mem,
@@ -254,19 +233,6 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 	}
 }
 
-void kvm_arch_flush_shadow_all(struct kvm *kvm)
-{
-}
-
-void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
-				   struct kvm_memory_slot *slot)
-{
-}
-
-void kvm_arch_flush_shadow(struct kvm *kvm)
-{
-}
-
 struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm, unsigned int id)
 {
 	int err, size, offset;
@@ -998,14 +964,6 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu)
-{
-}
-
-void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
-{
-}
-
 int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
 				  struct kvm_translation *tr)
 {
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 98d9dd5..0e646c1 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -687,4 +687,12 @@ struct kvm_vcpu_arch {
 #define __KVM_HAVE_ARCH_WQP
 #define __KVM_HAVE_CREATE_DEVICE
 
+static inline void kvm_arch_hardware_disable(void *garbage) {}
+static inline void kvm_arch_hardware_unsetup(void) {}
+static inline void kvm_arch_sync_events(struct kvm *kvm) {}
+static inline void kvm_arch_memslots_updated(struct kvm *kvm) {}
+static inline void kvm_arch_flush_shadow_all(struct kvm *kvm) {}
+static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
+static inline void kvm_arch_exit(void) {}
+
 #endif /* __POWERPC_KVM_HOST_H__ */
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index cbc432f..72c3fc0 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -389,19 +389,11 @@ int kvm_arch_hardware_enable(void *garbage)
 	return 0;
 }
 
-void kvm_arch_hardware_disable(void *garbage)
-{
-}
-
 int kvm_arch_hardware_setup(void)
 {
 	return 0;
 }
 
-void kvm_arch_hardware_unsetup(void)
-{
-}
-
 void kvm_arch_check_processor_compat(void *rtn)
 {
 	*(int *)rtn = kvmppc_core_check_processor_compat();
@@ -462,10 +454,6 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	module_put(kvm->arch.kvm_ops->owner);
 }
 
-void kvm_arch_sync_events(struct kvm *kvm)
-{
-}
-
 int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 {
 	int r;
@@ -608,10 +596,6 @@ int kvm_arch_create_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
 	return kvmppc_core_create_memslot(kvm, slot, npages);
 }
 
-void kvm_arch_memslots_updated(struct kvm *kvm)
-{
-}
-
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				   struct kvm_memory_slot *memslot,
 				   struct kvm_userspace_memory_region *mem,
@@ -628,10 +612,6 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 	kvmppc_core_commit_memory_region(kvm, mem, old);
 }
 
-void kvm_arch_flush_shadow_all(struct kvm *kvm)
-{
-}
-
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 				   struct kvm_memory_slot *slot)
 {
@@ -720,10 +700,6 @@ void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu)
 	kvmppc_subarch_vcpu_uninit(vcpu);
 }
 
-void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
-{
-}
-
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 #ifdef CONFIG_BOOKE
@@ -1347,9 +1323,4 @@ int kvm_arch_init(void *opaque)
 	return 0;
 }
 
-void kvm_arch_exit(void)
-{
-
-}
-
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_ppc_instr);
diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 773bef7..cee2be9 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -450,4 +450,18 @@ void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
 
 extern int sie64a(struct kvm_s390_sie_block *, u64 *);
 extern char sie_exit;
+
+static inline void kvm_arch_hardware_disable(void *garbage) {}
+static inline void kvm_arch_check_processor_compat(void *rtn) {}
+static inline void kvm_arch_exit(void) {}
+static inline void kvm_arch_sync_events(struct kvm *kvm) {}
+static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
+static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
+static inline void kvm_arch_free_memslot(struct kvm *kvm,
+		struct kvm_memory_slot *free, struct kvm_memory_slot *dont) {}
+static inline void kvm_arch_memslots_updated(struct kvm *kvm) {}
+static inline void kvm_arch_flush_shadow_all(struct kvm *kvm) {}
+static inline void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
+		struct kvm_memory_slot *slot) {}
+
 #endif
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 197bec0..043c58b 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -106,10 +106,6 @@ int kvm_arch_hardware_enable(void *garbage)
 	return 0;
 }
 
-void kvm_arch_hardware_disable(void *garbage)
-{
-}
-
 static void kvm_gmap_notifier(struct gmap *gmap, unsigned long address);
 
 int kvm_arch_hardware_setup(void)
@@ -124,19 +120,11 @@ void kvm_arch_hardware_unsetup(void)
 	gmap_unregister_ipte_notifier(&gmap_notifier);
 }
 
-void kvm_arch_check_processor_compat(void *rtn)
-{
-}
-
 int kvm_arch_init(void *opaque)
 {
 	return 0;
 }
 
-void kvm_arch_exit(void)
-{
-}
-
 /* Section: device related */
 long kvm_arch_dev_ioctl(struct file *filp,
 			unsigned int ioctl, unsigned long arg)
@@ -514,10 +502,6 @@ static void kvm_free_vcpus(struct kvm *kvm)
 	mutex_unlock(&kvm->lock);
 }
 
-void kvm_arch_sync_events(struct kvm *kvm)
-{
-}
-
 void kvm_arch_destroy_vm(struct kvm *kvm)
 {
 	kvm_free_vcpus(kvm);
@@ -550,15 +534,6 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu)
-{
-	/* Nothing todo */
-}
-
-void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
-{
-}
-
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	save_fp_ctl(&vcpu->arch.host_fpregs.fpc);
@@ -1681,21 +1656,12 @@ int kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
 	return VM_FAULT_SIGBUS;
 }
 
-void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free,
-			   struct kvm_memory_slot *dont)
-{
-}
-
 int kvm_arch_create_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
 			    unsigned long npages)
 {
 	return 0;
 }
 
-void kvm_arch_memslots_updated(struct kvm *kvm)
-{
-}
-
 /* Section: memory related */
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				   struct kvm_memory_slot *memslot,
@@ -1741,15 +1707,6 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 	return;
 }
 
-void kvm_arch_flush_shadow_all(struct kvm *kvm)
-{
-}
-
-void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
-				   struct kvm_memory_slot *slot)
-{
-}
-
 static int __init kvm_s390_init(void)
 {
 	int ret;
-- 
2.1.0

