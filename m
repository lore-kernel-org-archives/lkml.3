Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757123Ab3EVT4R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 15:56:17 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:40208 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757055Ab3EVT4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 15:56:14 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v7 02/11] KVM: MMU: drop unnecessary kvm_reload_remote_mmus
Date: Thu, 23 May 2013 03:55:51 +0800
Message-Id: <1369252560-11611-3-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1369252560-11611-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1369252560-11611-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052219-9574-0000-0000-000007FBBCD8
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
index 6739b1d..3758ff9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7060,16 +7060,13 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
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

