Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab3JYND7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 09:03:59 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:55332 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658Ab3JYNDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 09:03:55 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Jonathan Austin <jonathan.austin@arm.com>,
        Christoffer Dall <cdall@cs.columbia.edu>,
        Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the kvm-arm tree
Date: Fri, 25 Oct 2013 15:03:43 +0200
Message-Id: <1382706224-8859-5-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1382706224-8859-1-git-send-email-treding@nvidia.com>
References: <1382632289-18523-1-git-send-email-treding@nvidia.com>
 <1382706224-8859-1-git-send-email-treding@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's linux-next merge of the kvm-arm tree got a conflict in

	arch/arm/kvm/reset.c

caused by commits e8c2d99 (KVM: ARM: Add support for Cortex-A7) and 7999b4d
(ARM: KVM: drop limitation to 4 CPU VMs).

I fixed it up (see below). Please verify that the resolution looks good.

Thanks,
Thierry
---
diff --cc arch/arm/kvm/reset.c
index d153e64,2c5add0..f558c07
--- a/arch/arm/kvm/reset.c
+++ b/arch/arm/kvm/reset.c
@@@ -64,9 -62,7 +62,7 @@@ int kvm_reset_vcpu(struct kvm_vcpu *vcp
  	switch (vcpu->arch.target) {
  	case KVM_ARM_TARGET_CORTEX_A7:
  	case KVM_ARM_TARGET_CORTEX_A15:
- 		if (vcpu->vcpu_id > cortexa_max_cpu_idx)
- 			return -EINVAL;
 -		cpu_reset = &cortexa_regs_reset;
 +		reset_regs = &cortexa_regs_reset;
  		vcpu->arch.midr = read_cpuid_id();
  		cpu_vtimer_irq = &cortexa_vtimer_irq;
  		break;
