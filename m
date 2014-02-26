Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929AbaBZPtc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 10:49:32 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:55569 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbaBZPt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 10:49:28 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, alex.williamson@redhat.com, mtosatti@redhat.com,
        gleb@kernel.org, jan.kiszka@siemens.com
Subject: [PATCH 1/4] KVM: vmx: we do rely on loading DR7 on entry
Date: Wed, 26 Feb 2014 16:49:10 +0100
Message-Id: <1393429753-20857-2-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1393429753-20857-1-git-send-email-pbonzini@redhat.com>
References: <1393429753-20857-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, this works even if the bit is not in "min", because the bit is always
set in MSR_IA32_VMX_ENTRY_CTLS.  Mention it for the sake of documentation, and
to avoid surprises if we later switch to MSR_IA32_VMX_TRUE_ENTRY_CTLS.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index daca80f0eae2..6e57e1434cf3 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2872,7 +2872,7 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf)
 		!(_vmexit_control & VM_EXIT_ACK_INTR_ON_EXIT))
 		_pin_based_exec_control &= ~PIN_BASED_POSTED_INTR;
 
-	min = 0;
+	min = VM_ENTRY_LOAD_DEBUG_CONTROLS;
 	opt = VM_ENTRY_LOAD_IA32_PAT | VM_ENTRY_LOAD_BNDCFGS;
 	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_ENTRY_CTLS,
 				&_vmentry_control) < 0)
-- 
1.8.3.1


