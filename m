Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbaBXK46 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 05:56:58 -0500
Received: from mga02.intel.com ([134.134.136.20]:50374 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751915AbaBXK44 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 05:56:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,534,1389772800"; 
   d="scan'208,223";a="488685634"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: "'Paolo Bonzini'" <pbonzini@redhat.com>,
        "'kvm@vger.kernel.org'" <kvm@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'qemu-devel@nongnu.org'" <qemu-devel@nongnu.org>
CC: "'gleb@redhat.com'" <gleb@redhat.com>, "'hpa@zytor.com'" <hpa@zytor.com>
Subject: [PATCH v5 2/3] KVM: x86: add MSR_IA32_BNDCFGS to msrs_to_save
Thread-Topic: [PATCH v5 2/3] KVM: x86: add MSR_IA32_BNDCFGS to msrs_to_save
Thread-Index: Ac8xTyA5JlSaVIliTF+dnpxn0F4Rzw==
Date: Mon, 24 Feb 2014 10:56:53 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923350150E3F7@SHSMSX101.ccr.corp.intel.com>
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

>From 5d5a80cd172ea6fb51786369bcc23356b1e9e956 Mon Sep 17 00:00:00 2001
From: Liu Jinsong <jinsong.liu@intel.com>
Date: Mon, 24 Feb 2014 18:11:55 +0800
Subject: [PATCH v5 2/3] KVM: x86: add MSR_IA32_BNDCFGS to msrs_to_save

Add MSR_IA32_BNDCFGS to msrs_to_save, and corresponding logic
to kvm_get/set_msr().

Signed-off-by: Liu Jinsong <jinsong.liu@intel.com>
---
 arch/x86/kvm/vmx.c |    6 ++++++
 arch/x86/kvm/x86.c |    2 +-
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index e4e4b50..729b1e4 100644
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
