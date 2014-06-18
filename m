Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967043AbaFROWR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:22:17 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:12352 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966884AbaFROWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:22:13 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Au4BAB2goVOERCABjGdsb2JhbABarlABAQaDXo4Gh0SBChYPAQEBJzyFA4FRiELHFoVeF4ViiC9kHYQtBIo5pyeBaw
X-IPAS-Result: Au4BAB2goVOERCABjGdsb2JhbABarlABAQaDXo4Gh0SBChYPAQEBJzyFA4FRiELHFoVeF4ViiC9kHYQtBIo5pyeBaw
X-IronPort-AV: E=Sophos;i="5.01,501,1400014800"; 
   d="scan'208";a="112035367"
From: Nadav Amit <namit@cs.technion.ac.il>
To: pbonzini@redhat.com
Cc: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH] KVM: x86: Increase the number of fixed MTRR regs to 10
Date: Wed, 18 Jun 2014 17:21:19 +0300
Message-Id: <1403101279-23759-1-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recent Intel CPUs have 10 variable range MTRRs. Since operating systems
sometime make assumptions on CPUs while they ignore capability MSRs, it is
better for KVM to be consistent with recent CPUs. Reporting more MTRRs than
actually supported has no functional implications.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4931415..0bab29d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -95,7 +95,7 @@ static inline gfn_t gfn_to_index(gfn_t gfn, gfn_t base_gfn, int level)
 #define KVM_REFILL_PAGES 25
 #define KVM_MAX_CPUID_ENTRIES 80
 #define KVM_NR_FIXED_MTRR_REGION 88
-#define KVM_NR_VAR_MTRR 8
+#define KVM_NR_VAR_MTRR 10
 
 #define ASYNC_PF_PER_VCPU 64
 
-- 
1.9.1

