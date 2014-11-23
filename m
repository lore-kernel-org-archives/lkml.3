Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946AbaKWSOV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 13:14:21 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:45013 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbaKWSOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 13:14:19 -0500
From: Eric Auger <eric.auger@linaro.org>
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org,
        marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        alex.williamson@redhat.com, joel.schopp@amd.com,
        kim.phillips@freescale.com, paulus@samba.org, gleb@kernel.org,
        pbonzini@redhat.com
Cc: linux-kernel@vger.kernel.org, patches@linaro.org, will.deacon@arm.com,
        a.motakis@virtualopensystems.com, a.rigo@virtualopensystems.com,
        john.liuli@huawei.com, ming.lei@canonical.com, feng.wu@intel.com
Subject: [RFC 0/4] vgic additions for forwarded irq
Date: Sun, 23 Nov 2014 19:12:49 +0100
Message-Id: <1416766373-13569-1-git-send-email-eric.auger@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series applies on top of "ARM: Forwarding physical
interrupts to a guest VM" (http://lwn.net/Articles/603514/)
series.

It brings some extra functionalities that were requested to
be able to inject virtual level sensitive IRQs triggered from
VFIO/irqfd.

It adds:
- a specific handling of forwarded IRQ into the VGIC state machine.
- deactivation of physical IRQ and unforwarding on vgic destruction
- handling of forwarded IRQ injection before the vgic readiness:
  this was needed because in a sample qemu/vfio use case, qemu
  registers forwarded IRQ and set up VFIO signaling before the first
  vcpu run and hence before vgic readiness. At that time some
  physical IRQ may hit before the VGIC readiness. This is typically
  observed with Calxeda xgmac on second QEMU run.
- rbtree lock addition.

Integrated pieces can be found at
ssh://git.linaro.org/people/eric.auger/linux.git
on branch irqfd_integ_v8

The first 2 patch files were previously part of [RFC v2 0/9]
KVM-VFIO IRQ forward control (https://lkml.org/lkml/2014/9/1/347).


Eric Auger (4):
  KVM: arm: vgic: fix state machine for forwarded IRQ
  KVM: arm: vgic: add forwarded irq rbtree lock
  KVM: arm: vgic: cleanup forwarded IRQs on destroy
  KVM: arm: vgic: handle irqfd forwarded IRQ injection before vgic
    readiness

 include/kvm/arm_vgic.h |   1 +
 virt/kvm/arm/vgic.c    | 128 +++++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 110 insertions(+), 19 deletions(-)

-- 
1.9.1

