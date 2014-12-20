Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039AbaLTWv6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 17:51:58 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:56933 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879AbaLTWvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 17:51:54 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>,
        Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arch: ia64: kernel: irq_ia64.c:  Remove some unused functions
Date: Sat, 20 Dec 2014 23:54:39 +0100
Message-Id: <1419116079-13052-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
rnat_consumption() inat_page_consumption() privilege_reg()
unimpl_daddr() privilege_op() rsv_reg_field() illegal_dep()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/ia64/kvm/process.c |   70 -----------------------------------------------
 1 file changed, 70 deletions(-)

diff --git a/arch/ia64/kvm/process.c b/arch/ia64/kvm/process.c
index b039874..ab9d9e7 100644
--- a/arch/ia64/kvm/process.c
+++ b/arch/ia64/kvm/process.c
@@ -302,56 +302,6 @@ void illegal_op(struct kvm_vcpu *vcpu)
 	_general_exception(vcpu);
 }
 
-/*
- * Illegal Dependency Fault
- *  @ General Exception Vector
- * Refer to SDM Vol2 Table 5-6 & 8-1
- */
-void illegal_dep(struct kvm_vcpu *vcpu)
-{
-	_general_exception(vcpu);
-}
-
-/*
- * Reserved Register/Field Fault
- *  @ General Exception Vector
- * Refer to SDM Vol2 Table 5-6 & 8-1
- */
-void rsv_reg_field(struct kvm_vcpu *vcpu)
-{
-	_general_exception(vcpu);
-}
-/*
- * Privileged Operation Fault
- *  @ General Exception Vector
- * Refer to SDM Vol2 Table 5-6 & 8-1
- */
-
-void privilege_op(struct kvm_vcpu *vcpu)
-{
-	_general_exception(vcpu);
-}
-
-/*
- * Unimplement Data Address Fault
- *  @ General Exception Vector
- * Refer to SDM Vol2 Table 5-6 & 8-1
- */
-void unimpl_daddr(struct kvm_vcpu *vcpu)
-{
-	_general_exception(vcpu);
-}
-
-/*
- * Privileged Register Fault
- *  @ General Exception Vector
- * Refer to SDM Vol2 Table 5-6 & 8-1
- */
-void privilege_reg(struct kvm_vcpu *vcpu)
-{
-	_general_exception(vcpu);
-}
-
 /* Deal with
  *  Nat consumption vector
  * Parameter:
@@ -370,26 +320,6 @@ static void _nat_consumption_fault(struct kvm_vcpu *vcpu, u64 vadr,
 }
 
 /*
- * Instruction Nat Page Consumption Fault
- *  @ Nat Consumption Vector
- * Refer to SDM Vol2 Table 5-6 & 8-1
- */
-void inat_page_consumption(struct kvm_vcpu *vcpu, u64 vadr)
-{
-	_nat_consumption_fault(vcpu, vadr, INSTRUCTION);
-}
-
-/*
- * Register Nat Consumption Fault
- *  @ Nat Consumption Vector
- * Refer to SDM Vol2 Table 5-6 & 8-1
- */
-void rnat_consumption(struct kvm_vcpu *vcpu)
-{
-	_nat_consumption_fault(vcpu, 0, REGISTER);
-}
-
-/*
  * Data Nat Page Consumption Fault
  *  @ Nat Consumption Vector
  * Refer to SDM Vol2 Table 5-6 & 8-1
-- 
1.7.10.4

