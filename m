Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325AbbASOeP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 09:34:15 -0500
Received: from mga11.intel.com ([192.55.52.93]:26324 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730AbbASOd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 09:33:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,427,1418112000"; 
   d="scan'208";a="653182704"
Date: Mon, 19 Jan 2015 22:33:39 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: kbuild-all@01.org, Paolo Bonzini <pbonzini@redhat.com>,
        Gleb Natapov <gleb@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH kvm] KVM: kvm_read_nested_guest_page() can be static
Message-ID: <20150119143339.GA28243@snb>
References: <201501192223.rdrTzdYB%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201501192223.rdrTzdYB%fengguang.wu@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: fengguang.wu@intel.com
X-SA-Exim-Scanned: No (on bee); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/x86/kvm/x86.c:495:5: sparse: symbol 'kvm_read_nested_guest_page' was not declared. Should it be static?
arch/x86/kvm/x86.c:646:5: sparse: symbol '__kvm_set_xcr' was not declared. Should it be static?
arch/x86/kvm/x86.c:1183:15: sparse: symbol 'max_tsc_khz' was not declared. Should it be static?
arch/x86/kvm/x86.c:1237:6: sparse: symbol 'kvm_track_tsc_matching' was not declared. Should it be static?

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 x86.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c259814..f149b7c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -492,7 +492,7 @@ int kvm_read_guest_page_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 }
 EXPORT_SYMBOL_GPL(kvm_read_guest_page_mmu);
 
-int kvm_read_nested_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn,
+static int kvm_read_nested_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn,
 			       void *data, int offset, int len, u32 access)
 {
 	return kvm_read_guest_page_mmu(vcpu, vcpu->arch.walk_mmu, gfn,
@@ -643,7 +643,7 @@ static void kvm_put_guest_xcr0(struct kvm_vcpu *vcpu)
 	}
 }
 
-int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
+static int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 {
 	u64 xcr0 = xcr;
 	u64 old_xcr0 = vcpu->arch.xcr0;
@@ -1180,7 +1180,7 @@ static atomic_t kvm_guest_has_master_clock = ATOMIC_INIT(0);
 #endif
 
 static DEFINE_PER_CPU(unsigned long, cpu_tsc_khz);
-unsigned long max_tsc_khz;
+static unsigned long max_tsc_khz;
 
 static inline u64 nsec_to_cycles(struct kvm_vcpu *vcpu, u64 nsec)
 {
@@ -1234,7 +1234,7 @@ static u64 compute_guest_tsc(struct kvm_vcpu *vcpu, s64 kernel_ns)
 	return tsc;
 }
 
-void kvm_track_tsc_matching(struct kvm_vcpu *vcpu)
+static void kvm_track_tsc_matching(struct kvm_vcpu *vcpu)
 {
 #ifdef CONFIG_X86_64
 	bool vcpus_matched;
