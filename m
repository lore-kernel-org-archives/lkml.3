Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932165Ab3FGXGt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 19:06:49 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:44223 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757690Ab3FGXDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 19:03:54 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org, kvm@vger.kernel.org,
        Sanjay Lal <sanjayl@kymasys.com>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH 25/31] mips/kvm: Add some asm-offsets constants used by MIPSVZ.
Date: Fri,  7 Jun 2013 16:03:29 -0700
Message-Id: <1370646215-6543-26-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
References: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

Signed-off-by: David Daney <david.daney@cavium.com>
---
 arch/mips/kernel/asm-offsets.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/mips/kernel/asm-offsets.c b/arch/mips/kernel/asm-offsets.c
index 37fd9e2..db09376 100644
--- a/arch/mips/kernel/asm-offsets.c
+++ b/arch/mips/kernel/asm-offsets.c
@@ -19,6 +19,7 @@
 
 #include <linux/kvm_host.h>
 #include <asm/kvm_mips_te.h>
+#include <asm/kvm_mips_vz.h>
 
 void output_ptreg_defines(void)
 {
@@ -345,6 +346,8 @@ void output_pbe_defines(void)
 void output_kvm_defines(void)
 {
 	COMMENT(" KVM/MIPS Specfic offsets. ");
+	OFFSET(KVM_ARCH_IMPL, kvm, arch.impl);
+	OFFSET(KVM_VCPU_KVM, kvm_vcpu, kvm);
 	DEFINE(VCPU_ARCH_SIZE, sizeof(struct kvm_vcpu_arch));
 	OFFSET(VCPU_RUN, kvm_vcpu, run);
 	OFFSET(VCPU_HOST_ARCH, kvm_vcpu, arch);
@@ -411,5 +414,9 @@ void output_kvm_defines(void)
 	OFFSET(COP0_TLB_HI, mips_coproc, reg[MIPS_CP0_TLB_HI][0]);
 	OFFSET(COP0_STATUS, mips_coproc, reg[MIPS_CP0_STATUS][0]);
 	BLANK();
+
+	COMMENT(" Linux struct kvm mipsvz offsets. ");
+	OFFSET(KVM_MIPS_VZ_PGD,	kvm_mips_vz, pgd);
+	BLANK();
 }
 #endif
-- 
1.7.11.7

