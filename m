Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761647Ab3JPSyL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 14:54:11 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:61358 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761613Ab3JPSyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 14:54:01 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Jonathan Austin <jonathan.austin@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>, Olof Johansson <olof@lixom.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the kvm-arm tree
Date: Wed, 16 Oct 2013 20:51:40 +0200
Message-Id: <1381949500-501-3-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381949500-501-1-git-send-email-treding@nvidia.com>
References: <1381949500-501-1-git-send-email-treding@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's linux-next merge of the kvm-arm tree got conflicts in

	arch/arm/kvm/reset.c

caused by commits e8c2d99 (KVM: ARM: Add support for Cortex-A7) and ac570e0
(ARM: kvm: rename cpu_reset to avoid name clash).

I've fixed them up (see below). Please verify that the resolution looks
good.

Thanks,
Thierry
---
diff --cc arch/arm/kvm/reset.c
index c02ba4a,d9bbd83..d153e64
--- a/arch/arm/kvm/reset.c
+++ b/arch/arm/kvm/reset.c
@@@ -62,12 -62,13 +62,13 @@@ int kvm_reset_vcpu(struct kvm_vcpu *vcp
  	const struct kvm_irq_level *cpu_vtimer_irq;
  
  	switch (vcpu->arch.target) {
+ 	case KVM_ARM_TARGET_CORTEX_A7:
  	case KVM_ARM_TARGET_CORTEX_A15:
- 		if (vcpu->vcpu_id > a15_max_cpu_idx)
+ 		if (vcpu->vcpu_id > cortexa_max_cpu_idx)
  			return -EINVAL;
- 		reset_regs = &a15_regs_reset;
 -		cpu_reset = &cortexa_regs_reset;
++		reset_regs = &cortexa_regs_reset;
  		vcpu->arch.midr = read_cpuid_id();
- 		cpu_vtimer_irq = &a15_vtimer_irq;
+ 		cpu_vtimer_irq = &cortexa_vtimer_irq;
  		break;
  	default:
  		return -ENODEV;
