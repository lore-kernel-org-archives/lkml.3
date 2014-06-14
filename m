Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750962AbaFNVoY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 17:44:24 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:58507 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750823AbaFNVoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 17:44:23 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AswIAHXBnFNXQyDr/2dsb2JhbABagw2rDgUBAQEBAQEFAZkkgQMXdYQxLyOBGjeIRgHPQheFY4kTHYQtBJpDizCIKINCOw
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Gleb Natapov <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 1/1] arch/x86/kvm/vmx.c: use PAGE_ALIGNED instead of IS_ALIGNED(PAGE_SIZE
Date: Sat, 14 Jun 2014 23:44:29 +0200
Message-Id: <1402782269-10495-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use mm.h definition

Cc: Gleb Natapov <gleb@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 arch/x86/kvm/vmx.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 801332e..4f84be0 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -5918,7 +5918,7 @@ static int nested_vmx_check_vmptr(struct kvm_vcpu *vcpu, int exit_reason,
 		 * which replaces physical address width with 32
 		 *
 		 */
-		if (!IS_ALIGNED(vmptr, PAGE_SIZE) || (vmptr >> maxphyaddr)) {
+		if (!PAGE_ALIGNED(vmptr) || (vmptr >> maxphyaddr)) {
 			nested_vmx_failInvalid(vcpu);
 			skip_emulated_instruction(vcpu);
 			return 1;
@@ -5936,7 +5936,7 @@ static int nested_vmx_check_vmptr(struct kvm_vcpu *vcpu, int exit_reason,
 		vmx->nested.vmxon_ptr = vmptr;
 		break;
 	case EXIT_REASON_VMCLEAR:
-		if (!IS_ALIGNED(vmptr, PAGE_SIZE) || (vmptr >> maxphyaddr)) {
+		if (!PAGE_ALIGNED(vmptr) || (vmptr >> maxphyaddr)) {
 			nested_vmx_failValid(vcpu,
 					     VMXERR_VMCLEAR_INVALID_ADDRESS);
 			skip_emulated_instruction(vcpu);
@@ -5951,7 +5951,7 @@ static int nested_vmx_check_vmptr(struct kvm_vcpu *vcpu, int exit_reason,
 		}
 		break;
 	case EXIT_REASON_VMPTRLD:
-		if (!IS_ALIGNED(vmptr, PAGE_SIZE) || (vmptr >> maxphyaddr)) {
+		if (!PAGE_ALIGNED(vmptr) || (vmptr >> maxphyaddr)) {
 			nested_vmx_failValid(vcpu,
 					     VMXERR_VMPTRLD_INVALID_ADDRESS);
 			skip_emulated_instruction(vcpu);
@@ -8113,14 +8113,14 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 	}
 
 	if ((vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_MSR_BITMAPS) &&
-			!IS_ALIGNED(vmcs12->msr_bitmap, PAGE_SIZE)) {
+			!PAGE_ALIGNED(vmcs12->msr_bitmap)) {
 		/*TODO: Also verify bits beyond physical address width are 0*/
 		nested_vmx_failValid(vcpu, VMXERR_ENTRY_INVALID_CONTROL_FIELD);
 		return 1;
 	}
 
 	if (nested_cpu_has2(vmcs12, SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES) &&
-			!IS_ALIGNED(vmcs12->apic_access_addr, PAGE_SIZE)) {
+			!PAGE_ALIGNED(vmcs12->apic_access_addr)) {
 		/*TODO: Also verify bits beyond physical address width are 0*/
 		nested_vmx_failValid(vcpu, VMXERR_ENTRY_INVALID_CONTROL_FIELD);
 		return 1;
-- 
1.8.4.5

