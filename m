Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363AbaLGR0S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 12:26:18 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:41571 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbaLGR0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 12:26:16 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Alexander Graf <agraf@suse.de>, Gleb Natapov <gleb@kernel.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] arch: powerpc: kvm: book3s.c:  Remove some unused functions
Date: Sun,  7 Dec 2014 18:28:54 +0100
Message-Id: <1417973334-13318-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
kvmppc_core_load_guest_debugstate() kvmppc_core_load_host_debugstate()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/powerpc/kvm/book3s.c |    8 --------
 arch/powerpc/kvm/e500.c   |    8 --------
 2 files changed, 16 deletions(-)

diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index b32db4b..888bf46 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -64,14 +64,6 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ NULL }
 };
 
-void kvmppc_core_load_host_debugstate(struct kvm_vcpu *vcpu)
-{
-}
-
-void kvmppc_core_load_guest_debugstate(struct kvm_vcpu *vcpu)
-{
-}
-
 void kvmppc_unfixup_split_real(struct kvm_vcpu *vcpu)
 {
 	if (vcpu->arch.hflags & BOOK3S_HFLAG_SPLIT_HACK) {
diff --git a/arch/powerpc/kvm/e500.c b/arch/powerpc/kvm/e500.c
index 2e02ed8..be4f3fd 100644
--- a/arch/powerpc/kvm/e500.c
+++ b/arch/powerpc/kvm/e500.c
@@ -299,14 +299,6 @@ void kvmppc_mmu_msr_notify(struct kvm_vcpu *vcpu, u32 old_msr)
 	kvmppc_e500_recalc_shadow_pid(to_e500(vcpu));
 }
 
-void kvmppc_core_load_host_debugstate(struct kvm_vcpu *vcpu)
-{
-}
-
-void kvmppc_core_load_guest_debugstate(struct kvm_vcpu *vcpu)
-{
-}
-
 static void kvmppc_core_vcpu_load_e500(struct kvm_vcpu *vcpu, int cpu)
 {
 	kvmppc_booke_vcpu_load(vcpu, cpu);
-- 
1.7.10.4

