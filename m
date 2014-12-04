Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207AbaLDIYk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 03:24:40 -0500
Received: from mga11.intel.com ([192.55.52.93]:14908 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753162AbaLDIYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 03:24:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,514,1413270000"; 
   d="scan'208";a="642209498"
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH 3/4] kvm: cpuid: fix xsave area size of XSAVEC
Date: Thu,  4 Dec 2014 16:24:27 +0800
Message-Id: <1417681468-7165-3-git-send-email-wanpeng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1417681468-7165-1-git-send-email-wanpeng.li@linux.intel.com>
References: <1417681468-7165-1-git-send-email-wanpeng.li@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

XSAVEC also use the compacted format for the extended region
of the XSAVE area. This patch fix it by caculate the size of 
XSAVEC extended region of XSAVE area as compact format.

Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
---
 arch/x86/kvm/cpuid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 70f0fa1..e16a0c7 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -92,7 +92,7 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
 	}
 
 	best = kvm_find_cpuid_entry(vcpu, 0xD, 1);
-	if (best && (best->eax & F(XSAVES)))
+	if (best && (best->eax & (F(XSAVES) || F(XSAVEC))))
 		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
 
 	/*
-- 
1.9.1

