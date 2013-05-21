Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008Ab3EUU4W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 16:56:22 -0400
Received: from mail-da0-f52.google.com ([209.85.210.52]:50882 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478Ab3EUUzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 16:55:05 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org, kvm@vger.kernel.org,
        Sanjay Lal <sanjayl@kymasys.com>, Gleb Natapov <gleb@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH v4 4/6] mips/kvm: Use ARRAY_SIZE() instead of hardcoded constants in kvm_arch_vcpu_ioctl_{s,g}et_regs
Date: Tue, 21 May 2013 13:54:53 -0700
Message-Id: <1369169695-10444-5-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1369169695-10444-1-git-send-email-ddaney.cavm@gmail.com>
References: <1369169695-10444-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

Also we cannot set special zero register, so force it to zero.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 arch/mips/kvm/kvm_mips.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/mips/kvm/kvm_mips.c b/arch/mips/kvm/kvm_mips.c
index 93da750..71a1fc1 100644
--- a/arch/mips/kvm/kvm_mips.c
+++ b/arch/mips/kvm/kvm_mips.c
@@ -677,9 +677,9 @@ int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 {
 	int i;
 
-	for (i = 0; i < 32; i++)
+	for (i = 1; i < ARRAY_SIZE(vcpu->arch.gprs); i++)
 		vcpu->arch.gprs[i] = regs->gpr[i];
-
+	vcpu->arch.gprs[0] = 0; /* zero is special, and cannot be set. */
 	vcpu->arch.hi = regs->hi;
 	vcpu->arch.lo = regs->lo;
 	vcpu->arch.pc = regs->pc;
@@ -691,7 +691,7 @@ int kvm_arch_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 {
 	int i;
 
-	for (i = 0; i < 32; i++)
+	for (i = 0; i < ARRAY_SIZE(vcpu->arch.gprs); i++)
 		regs->gpr[i] = vcpu->arch.gprs[i];
 
 	regs->hi = vcpu->arch.hi;
-- 
1.7.11.7

