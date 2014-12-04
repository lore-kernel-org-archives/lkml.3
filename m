Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147AbaLDLbj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 06:31:39 -0500
Received: from mga01.intel.com ([192.55.52.88]:40557 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754010AbaLDLbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 06:31:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="424996387"
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Nadav Amit <nadav.amit@gmail.com>, <rkrcmar@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH v2 3/4] kvm: cpuid: fix xsave area size of XSAVEC
Date: Thu,  4 Dec 2014 19:11:09 +0800
Message-Id: <1417691470-5221-3-git-send-email-wanpeng.li@linux.intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417691470-5221-1-git-send-email-wanpeng.li@linux.intel.com>
References: <1417691470-5221-1-git-send-email-wanpeng.li@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

XSAVEC also use the compacted format for the extended region
of the XSAVE area. This patch fix it by caculate the size of
XSAVEC extended region of XSAVE area as compact format.

Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
---
v1 -> v2:
 * use | (bitwise or) instead of II (logical or)

 arch/x86/kvm/cpuid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 5b78e9b..7d5bdb4 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -92,7 +92,7 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
 	}
 
 	best = kvm_find_cpuid_entry(vcpu, 0xD, 1);
-	if (best && (best->eax & F(XSAVES)))
+	if (best && (best->eax & (F(XSAVES) | F(XSAVEC))))
 		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
 
 	/*
-- 
1.9.1

