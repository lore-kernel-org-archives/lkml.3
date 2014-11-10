Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736AbaKJGgc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 01:36:32 -0500
Received: from mga11.intel.com ([192.55.52.93]:54478 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799AbaKJGgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 01:36:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,351,1413270000"; 
   d="scan'208";a="629364094"
From: Feng Wu <feng.wu@intel.com>
To: gleb@kernel.org, pbonzini@redhat.com, dwmw2@infradead.org, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Cc: kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Feng Wu <feng.wu@intel.com>
Subject: [PATCH 00/13] Add VT-d Posted-Interrupts support for KVM
Date: Mon, 10 Nov 2014 14:26:39 +0800
Message-Id: <1415600812-27773-1-git-send-email-feng.wu@intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VT-d Posted-Interrupts is an enhancement to CPU side Posted-Interrupt.
With VT-d Posted-Interrupts enabled, external interrupts from
direct-assigned devices can be delivered to guests without VMM
intervention when guest is running in non-root mode.

You can find the VT-d Posted-Interrtups Spec. in the following URL:
http://www.intel.com/content/www/us/en/intelligent-systems/intel-technology/vt-directed-io-spec.html

Feng Wu (13):
  iommu/vt-d: VT-d Posted-Interrupts feature detection
  KVM: Initialize VT-d Posted-Interrtups Descriptor
  KVM: Add KVM_CAP_PI to detect VT-d Posted-Interrtups
  iommu/vt-d: Adjust 'struct irte' to better suit for VT-d
    Posted-Interrupts
  KVM: Update IRTE according to guest interrupt configuration changes
  KVM: Add some helper functions for Posted-Interrupts
  x86, irq: Define a global vector for VT-d Posted-Interrupts
  KVM: Update Posted-Interrupts descriptor during VCPU scheduling
  KVM: Change NDST field after VCPU scheduling
  KVM: Add the handler for Wake-up Vector
  KVM: Suppress posted-interrupt when 'SN' is set
  iommu/vt-d: No need to migrating irq for VT-d Posted-Interrtups
  iommu/vt-d: Add a command line parameter for VT-d posted-interrupts

 arch/x86/include/asm/entry_arch.h    |    2 +
 arch/x86/include/asm/hardirq.h       |    1 +
 arch/x86/include/asm/hw_irq.h        |    2 +
 arch/x86/include/asm/irq_remapping.h |    7 +
 arch/x86/include/asm/irq_vectors.h   |    1 +
 arch/x86/include/asm/kvm_host.h      |    9 ++
 arch/x86/kernel/apic/apic.c          |    1 +
 arch/x86/kernel/entry_64.S           |    2 +
 arch/x86/kernel/irq.c                |   27 ++++
 arch/x86/kernel/irqinit.c            |    2 +
 arch/x86/kvm/vmx.c                   |  257 +++++++++++++++++++++++++++++++++-
 arch/x86/kvm/x86.c                   |   53 ++++++-
 drivers/iommu/amd_iommu.c            |    6 +
 drivers/iommu/intel_irq_remapping.c  |   83 +++++++++--
 drivers/iommu/irq_remapping.c        |   20 +++
 drivers/iommu/irq_remapping.h        |    8 +
 include/linux/dmar.h                 |   30 ++++-
 include/linux/intel-iommu.h          |    1 +
 include/linux/kvm_host.h             |   25 ++++
 include/uapi/linux/kvm.h             |    2 +
 virt/kvm/assigned-dev.c              |  141 +++++++++++++++++++
 virt/kvm/irq_comm.c                  |    4 +-
 virt/kvm/irqchip.c                   |   11 --
 virt/kvm/kvm_main.c                  |   14 ++
 24 files changed, 667 insertions(+), 42 deletions(-)

