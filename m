Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab3EPVPB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 17:15:01 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:41869 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346Ab3EPVNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 17:13:14 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v6 1/7] KVM: MMU: drop unnecessary kvm_reload_remote_mmus
Date: Fri, 17 May 2013 05:12:56 +0800
Message-Id: <1368738782-18649-2-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1368738782-18649-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1368738782-18649-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051621-5140-0000-0000-00000339283A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is the responsibility of kvm_mmu_zap_all that keeps the
consistent of mmu and tlbs. And it is also unnecessary after
zap all mmio sptes since no mmio spte exists on root shadow
page and it can not be cached into tlb

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/x86.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8d28810..d885418 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7067,16 +7067,13 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 	 * If memory slot is created, or moved, we need to clear all
 	 * mmio sptes.
 	 */
-	if ((change == KVM_MR_CREATE) || (change == KVM_MR_MOVE)) {
+	if ((change == KVM_MR_CREATE) || (change == KVM_MR_MOVE))
 		kvm_mmu_zap_mmio_sptes(kvm);
-		kvm_reload_remote_mmus(kvm);
-	}
 }
 
 void kvm_arch_flush_shadow_all(struct kvm *kvm)
 {
 	kvm_mmu_zap_all(kvm);
-	kvm_reload_remote_mmus(kvm);
 }
 
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
-- 
1.7.7.6

