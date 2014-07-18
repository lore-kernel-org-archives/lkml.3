Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934637AbaGRNDI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:03:08 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17206 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965321AbaGRNDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:03:03 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, James Hogan <james.hogan@imgtec.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        kvm@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        linux-mips@linux-mips.org, Sanjay Lal <sanjayl@kymasys.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 050/170] MIPS: KVM: Remove redundant NULL checks before kfree()
Date: Fri, 18 Jul 2014 14:10:55 +0200
Message-Id: <13fa8defdc11fa6a21315072e18a05192c4072c6.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Hogan <james.hogan@imgtec.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit c6c0a6637f9da54f9472144d44f71cf847f92e20 upstream.

The kfree() function already NULL checks the parameter so remove the
redundant NULL checks before kfree() calls in arch/mips/kvm/.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Gleb Natapov <gleb@kernel.org>
Cc: kvm@vger.kernel.org
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org
Cc: Sanjay Lal <sanjayl@kymasys.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/mips/kvm/kvm_mips.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/arch/mips/kvm/kvm_mips.c b/arch/mips/kvm/kvm_mips.c
index b31153969946..8b900e987338 100644
--- a/arch/mips/kvm/kvm_mips.c
+++ b/arch/mips/kvm/kvm_mips.c
@@ -149,9 +149,7 @@ void kvm_mips_free_vcpus(struct kvm *kvm)
 		if (kvm->arch.guest_pmap[i] != KVM_INVALID_PAGE)
 			kvm_mips_release_pfn_clean(kvm->arch.guest_pmap[i]);
 	}
-
-	if (kvm->arch.guest_pmap)
-		kfree(kvm->arch.guest_pmap);
+	kfree(kvm->arch.guest_pmap);
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		kvm_arch_vcpu_free(vcpu);
@@ -388,12 +386,8 @@ void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
 
 	kvm_mips_dump_stats(vcpu);
 
-	if (vcpu->arch.guest_ebase)
-		kfree(vcpu->arch.guest_ebase);
-
-	if (vcpu->arch.kseg0_commpage)
-		kfree(vcpu->arch.kseg0_commpage);
-
+	kfree(vcpu->arch.guest_ebase);
+	kfree(vcpu->arch.kseg0_commpage);
 }
 
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
-- 
2.0.0

