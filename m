Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540AbaLBLZU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 06:25:20 -0500
Received: from mga14.intel.com ([192.55.52.115]:12993 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752320AbaLBLZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 06:25:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,500,1413270000"; 
   d="scan'208";a="631320104"
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH v3 3/3] kvm: x86: Enable Intel XSAVES for guest
Date: Tue,  2 Dec 2014 19:21:30 +0800
Message-Id: <1417519290-44063-1-git-send-email-wanpeng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exporse intel xsaves feature to guest.

Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
---
 arch/x86/kvm/cpuid.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index a4f5ac4..0d919bc 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -267,6 +267,7 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 	unsigned f_rdtscp = kvm_x86_ops->rdtscp_supported() ? F(RDTSCP) : 0;
 	unsigned f_invpcid = kvm_x86_ops->invpcid_supported() ? F(INVPCID) : 0;
 	unsigned f_mpx = kvm_x86_ops->mpx_supported() ? F(MPX) : 0;
+	unsigned f_xsaves = kvm_x86_ops->xsaves_supported() ? F(XSAVES) : 0;
 
 	/* cpuid 1.edx */
 	const u32 kvm_supported_word0_x86_features =
@@ -322,7 +323,7 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 
 	/* cpuid 0xD.1.eax */
 	const u32 kvm_supported_word10_x86_features =
-		F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1);
+		F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1) | f_xsaves;
 
 	/* all calls to cpuid_count() should be made on the same cpu */
 	get_cpu();
-- 
1.9.1

