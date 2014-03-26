Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271AbaCZOzY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 10:55:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33344 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754369AbaCZOzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 10:55:22 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: fengguang.wu@intel.com, kvm@vger.kernel.org
Subject: [PATCH] KVM: vmx: fix MPX detection
Date: Wed, 26 Mar 2014 15:54:00 +0100
Message-Id: <1395845640-1976-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kvm_x86_ops is still NULL at this point.  Since kvm_init_msr_list
cannot fail, it is safe to initialize it before the call.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: kvm@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 39c28f09dfd5..49b514f76b5d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5537,9 +5537,10 @@ int kvm_arch_init(void *opaque)
 		goto out_free_percpu;
 
 	kvm_set_mmio_spte_mask();
-	kvm_init_msr_list();
 
 	kvm_x86_ops = ops;
+	kvm_init_msr_list();
+
 	kvm_mmu_set_mask_ptes(PT_USER_MASK, PT_ACCESSED_MASK,
 			PT_DIRTY_MASK, PT64_NX_MASK, 0);
 
-- 
1.8.5.3

