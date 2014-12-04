Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932516AbaLDP5g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 10:57:36 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:47352 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932451AbaLDP53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 10:57:29 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: rkrcmar@redhat.com, Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH 3/9] KVM: x86: use F() macro throughout cpuid.c
Date: Thu,  4 Dec 2014 16:57:08 +0100
Message-Id: <1417708634-24333-4-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1417708634-24333-1-git-send-email-pbonzini@redhat.com>
References: <1417708634-24333-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For code that deals with cpuid, this makes things a bit more readable.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/cpuid.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index a4f5ac46226c..11f09a2b31a0 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -53,6 +53,8 @@ u64 kvm_supported_xcr0(void)
 	return xcr0;
 }
 
+#define F(x) bit(X86_FEATURE_##x)
+
 int kvm_update_cpuid(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best;
@@ -64,13 +66,13 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
 
 	/* Update OSXSAVE bit */
 	if (cpu_has_xsave && best->function == 0x1) {
-		best->ecx &= ~(bit(X86_FEATURE_OSXSAVE));
+		best->ecx &= ~F(OSXSAVE);
 		if (kvm_read_cr4_bits(vcpu, X86_CR4_OSXSAVE))
-			best->ecx |= bit(X86_FEATURE_OSXSAVE);
+			best->ecx |= F(OSXSAVE);
 	}
 
 	if (apic) {
-		if (best->ecx & bit(X86_FEATURE_TSC_DEADLINE_TIMER))
+		if (best->ecx & F(TSC_DEADLINE_TIMER))
 			apic->lapic_timer.timer_mode_mask = 3 << 17;
 		else
 			apic->lapic_timer.timer_mode_mask = 1 << 17;
@@ -122,8 +124,8 @@ static void cpuid_fix_nx_cap(struct kvm_vcpu *vcpu)
 			break;
 		}
 	}
-	if (entry && (entry->edx & bit(X86_FEATURE_NX)) && !is_efer_nx()) {
-		entry->edx &= ~bit(X86_FEATURE_NX);
+	if (entry && (entry->edx & F(NX)) && !is_efer_nx()) {
+		entry->edx &= ~F(NX);
 		printk(KERN_INFO "kvm: guest NX capability removed\n");
 	}
 }
@@ -227,8 +229,6 @@ static void do_cpuid_1_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 	entry->flags = 0;
 }
 
-#define F(x) bit(X86_FEATURE_##x)
-
 static int __do_cpuid_ent_emulated(struct kvm_cpuid_entry2 *entry,
 				   u32 func, u32 index, int *nent, int maxnent)
 {
-- 
1.8.3.1


