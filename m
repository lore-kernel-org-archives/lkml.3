Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017Ab3JBO5f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 10:57:35 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:51926 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813Ab3JBO4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 10:56:44 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gleb@redhat.com, kvm@vger.kernel.org
Subject: [PATCH 6/7] KVM: mmu: remove ASSERT(vcpu)
Date: Wed,  2 Oct 2013 16:56:15 +0200
Message-Id: <1380725776-14948-7-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380725776-14948-1-git-send-email-pbonzini@redhat.com>
References: <1380725776-14948-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because ASSERT is just a printk, these would oops right away.
The assertion thus hardly adds anything.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index ac598c8..699eab3 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3301,7 +3301,6 @@ static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
 	if (r)
 		return r;
 
-	ASSERT(vcpu);
 	ASSERT(VALID_PAGE(vcpu->arch.mmu.root_hpa));
 
 	gfn = gva >> PAGE_SHIFT;
@@ -3368,7 +3367,6 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa, u32 error_code,
 	int write = error_code & PFERR_WRITE_MASK;
 	bool map_writable;
 
-	ASSERT(vcpu);
 	ASSERT(VALID_PAGE(vcpu->arch.mmu.root_hpa));
 
 	if (unlikely(error_code & PFERR_RSVD_MASK)) {
@@ -3747,7 +3745,6 @@ void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu)
 	bool smep = kvm_read_cr4_bits(vcpu, X86_CR4_SMEP);
 	struct kvm_mmu *context = vcpu->arch.walk_mmu;
 
-	ASSERT(vcpu);
 	ASSERT(!VALID_PAGE(context->root_hpa));
 
 	if (!is_paging(vcpu))
@@ -3771,7 +3768,6 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly)
 {
 	struct kvm_mmu *context = vcpu->arch.walk_mmu;
 
-	ASSERT(vcpu);
 	ASSERT(!VALID_PAGE(context->root_hpa));
 
 	context->shadow_root_level = kvm_x86_ops->get_tdp_level();
@@ -3851,8 +3847,6 @@ static void init_kvm_mmu(struct kvm_vcpu *vcpu)
 
 void kvm_mmu_reset_context(struct kvm_vcpu *vcpu)
 {
-	ASSERT(vcpu);
-
 	kvm_mmu_unload(vcpu);
 	init_kvm_mmu(vcpu);
 }
@@ -4208,8 +4202,6 @@ static int alloc_mmu_pages(struct kvm_vcpu *vcpu)
 	struct page *page;
 	int i;
 
-	ASSERT(vcpu);
-
 	/*
 	 * When emulating 32-bit mode, cr3 is only 32 bits even on x86_64.
 	 * Therefore we need to allocate shadow page tables in the first
@@ -4228,8 +4220,6 @@ static int alloc_mmu_pages(struct kvm_vcpu *vcpu)
 
 int kvm_mmu_create(struct kvm_vcpu *vcpu)
 {
-	ASSERT(vcpu);
-
 	vcpu->arch.walk_mmu = &vcpu->arch.mmu;
 	vcpu->arch.mmu.root_hpa = INVALID_PAGE;
 	vcpu->arch.mmu.translate_gpa = translate_gpa;
@@ -4240,7 +4230,6 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
 
 void kvm_mmu_setup(struct kvm_vcpu *vcpu)
 {
-	ASSERT(vcpu);
 	ASSERT(!VALID_PAGE(vcpu->arch.mmu.root_hpa));
 
 	init_kvm_mmu(vcpu);
@@ -4528,8 +4517,6 @@ EXPORT_SYMBOL_GPL(kvm_mmu_get_spte_hierarchy);
 
 void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
 {
-	ASSERT(vcpu);
-
 	kvm_mmu_unload(vcpu);
 	free_mmu_pages(vcpu);
 	mmu_free_memory_caches(vcpu);
-- 
1.8.3.1


