Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab3EPMSS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 08:18:18 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:59220 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227Ab3EPMSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 08:18:09 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v5 1/8] KVM: MMU: drop unnecessary kvm_reload_remote_mmus
Date: Thu, 16 May 2013 20:17:46 +0800
Message-Id: <1368706673-8530-2-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1368706673-8530-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1368706673-8530-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051612-8878-0000-0000-00000722DF8C
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

