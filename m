Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161082AbaDSWTc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 18:19:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38125 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754982AbaDSWSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 18:18:16 -0400
From: Bandan Das <bsd@redhat.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/3] KVM: nVMX: Advertise support for interrupt acknowledgement
Date: Sat, 19 Apr 2014 18:17:46 -0400
Message-Id: <1397945866-6961-4-git-send-email-bsd@redhat.com>
In-Reply-To: <1397945866-6961-1-git-send-email-bsd@redhat.com>
References: <1397945866-6961-1-git-send-email-bsd@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some Type 1 hypervisors such as XEN won't enable VMX without it present

Signed-off-by: Bandan Das <bsd@redhat.com>
---
 arch/x86/kvm/vmx.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 5c0b74d..7bed3e3 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2283,7 +2283,7 @@ static __init void nested_vmx_setup_ctls_msrs(void)
 	rdmsr(MSR_IA32_VMX_EXIT_CTLS,
 		nested_vmx_exit_ctls_low, nested_vmx_exit_ctls_high);
 	nested_vmx_exit_ctls_low = VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR;
-	/* Note that guest use of VM_EXIT_ACK_INTR_ON_EXIT is not supported. */
+
 	nested_vmx_exit_ctls_high &=
 #ifdef CONFIG_X86_64
 		VM_EXIT_HOST_ADDR_SPACE_SIZE |
@@ -2291,7 +2291,8 @@ static __init void nested_vmx_setup_ctls_msrs(void)
 		VM_EXIT_LOAD_IA32_PAT | VM_EXIT_SAVE_IA32_PAT;
 	nested_vmx_exit_ctls_high |= VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR |
 		VM_EXIT_LOAD_IA32_EFER | VM_EXIT_SAVE_IA32_EFER |
-		VM_EXIT_SAVE_VMX_PREEMPTION_TIMER;
+		VM_EXIT_SAVE_VMX_PREEMPTION_TIMER | VM_EXIT_ACK_INTR_ON_EXIT;
+
 	if (vmx_mpx_supported())
 		nested_vmx_exit_ctls_high |= VM_EXIT_CLEAR_BNDCFGS;
 
-- 
1.8.3.1

