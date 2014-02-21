Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103AbaBUR4H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 12:56:07 -0500
Received: from mga01.intel.com ([192.55.52.88]:2547 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755973AbaBURzx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 12:55:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,520,1389772800"; 
   d="scan'208,223";a="485606025"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: "gleb@redhat.com" <gleb@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
Subject: [PATCH v4 2/3] KVM: x86: add MSR_IA32_BNDCFGS to msrs_to_save
Thread-Topic: [PATCH v4 2/3] KVM: x86: add MSR_IA32_BNDCFGS to msrs_to_save
Thread-Index: Ac8vLiYATjj1h4DwSXOSL0K4eXhHUw==
Date: Fri, 21 Feb 2014 17:55:47 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC829233501509BFC@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 7d1b41c3fdf71e4c73280e117948102f54f74be7 Mon Sep 17 00:00:00 2001
From: Liu Jinsong <jinsong.liu@intel.com>
Date: Sat, 22 Feb 2014 08:10:17 +0800
Subject: [PATCH v4 2/3] KVM: x86: add MSR_IA32_BNDCFGS to msrs_to_save

Add MSR_IA32_BNDCFGS to msrs_to_save, and corresponding logic
to kvm_get/set_msr().

Signed-off-by: Liu Jinsong <jinsong.liu@intel.com>
---
 arch/x86/kvm/vmx.c |    6 ++++++
 arch/x86/kvm/x86.c |    2 +-
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 35d285f..2839c2f 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2484,6 +2484,9 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata)
 	case MSR_IA32_SYSENTER_ESP:
 		data = vmcs_readl(GUEST_SYSENTER_ESP);
 		break;
+	case MSR_IA32_BNDCFGS:
+		data = vmcs_readl(GUEST_BNDCFGS);
+		break;
 	case MSR_IA32_FEATURE_CONTROL:
 		if (!nested_vmx_allowed(vcpu))
 			return 1;
@@ -2552,6 +2555,9 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_SYSENTER_ESP:
 		vmcs_writel(GUEST_SYSENTER_ESP, data);
 		break;
+	case MSR_IA32_BNDCFGS:
+		vmcs_writel(GUEST_BNDCFGS, data);
+		break;
 	case MSR_IA32_TSC:
 		kvm_write_tsc(vcpu, msr_info);
 		break;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7c52acb..89e4e27 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -882,7 +882,7 @@ static u32 msrs_to_save[] = {
 	MSR_CSTAR, MSR_KERNEL_GS_BASE, MSR_SYSCALL_MASK, MSR_LSTAR,
 #endif
 	MSR_IA32_TSC, MSR_IA32_CR_PAT, MSR_VM_HSAVE_PA,
-	MSR_IA32_FEATURE_CONTROL
+	MSR_IA32_FEATURE_CONTROL, MSR_IA32_BNDCFGS
 };
 
 static unsigned num_msrs_to_save;
-- 
1.7.1
