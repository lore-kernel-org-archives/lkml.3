Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014AbaHRJsj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:48:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:35654 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753408AbaHRJsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:48:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,885,1400050800"; 
   d="scan'208";a="559946285"
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Gleb Natapov <gleb@kernel.org>, hpa@zytor.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH 2/5] KVM: x86: drop fpu_activate hook
Date: Mon, 18 Aug 2014 17:50:28 +0800
Message-Id: <1408355431-115633-2-git-send-email-wanpeng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1408355431-115633-1-git-send-email-wanpeng.li@linux.intel.com>
References: <1408355431-115633-1-git-send-email-wanpeng.li@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fpu_activate hook is introduced by commit 6b52d186 (KVM: Activate fpu on 
clts), however, there is no user currently, this patch drop it.

Reviewed-by: Yang Zhang <yang.z.zhang@intel.com>
Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
---
 arch/x86/include/asm/kvm_host.h | 1 -
 arch/x86/kvm/svm.c              | 1 -
 arch/x86/kvm/vmx.c              | 1 -
 3 files changed, 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5724601..b68f3e5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -710,7 +710,6 @@ struct kvm_x86_ops {
 	void (*cache_reg)(struct kvm_vcpu *vcpu, enum kvm_reg reg);
 	unsigned long (*get_rflags)(struct kvm_vcpu *vcpu);
 	void (*set_rflags)(struct kvm_vcpu *vcpu, unsigned long rflags);
-	void (*fpu_activate)(struct kvm_vcpu *vcpu);
 	void (*fpu_deactivate)(struct kvm_vcpu *vcpu);
 
 	void (*tlb_flush)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index ddf7427..1f49c86 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -4349,7 +4349,6 @@ static struct kvm_x86_ops svm_x86_ops = {
 	.cache_reg = svm_cache_reg,
 	.get_rflags = svm_get_rflags,
 	.set_rflags = svm_set_rflags,
-	.fpu_activate = svm_fpu_activate,
 	.fpu_deactivate = svm_fpu_deactivate,
 
 	.tlb_flush = svm_flush_tlb,
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 71cbee5..2963303 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -8896,7 +8896,6 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.cache_reg = vmx_cache_reg,
 	.get_rflags = vmx_get_rflags,
 	.set_rflags = vmx_set_rflags,
-	.fpu_activate = vmx_fpu_activate,
 	.fpu_deactivate = vmx_fpu_deactivate,
 
 	.tlb_flush = vmx_flush_tlb,
-- 
1.9.1

