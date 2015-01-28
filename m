Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761808AbbA1EpH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:45:07 -0500
Received: from mga02.intel.com ([134.134.136.20]:28961 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761789AbbA1EpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:45:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,479,1418112000"; 
   d="scan'208";a="677140362"
From: "Wu, Feng" <feng.wu@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>, "gleb@kernel.org" <gleb@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jiang.liu@linux.intel.com" <jiang.liu@linux.intel.com>,
        "eric.auger@linaro.org" <eric.auger@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Wu, Feng" <feng.wu@intel.com>
Subject: RE: [v3 00/26] Add VT-d Posted-Interrupts support
Thread-Topic: [v3 00/26] Add VT-d Posted-Interrupts support
Thread-Index: AQHQOqzN7fiykhLSUEKmRufu3jQCOZzU83FQ
Date: Wed, 28 Jan 2015 04:44:52 +0000
Message-ID: <E959C4978C3B6342920538CF579893F002383DF1@SHSMSX104.ccr.corp.intel.com>
References: <1418397300-10870-1-git-send-email-feng.wu@intel.com>
	 <E959C4978C3B6342920538CF579893F00236670C@SHSMSX104.ccr.corp.intel.com>
	 <E959C4978C3B6342920538CF579893F0023826A5@SHSMSX104.ccr.corp.intel.com>
 <1422416668.22865.91.camel@redhat.com>
In-Reply-To: <1422416668.22865.91.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0S4jFpq001900



> -----Original Message-----
> From: Alex Williamson [mailto:alex.williamson@redhat.com]
> Sent: Wednesday, January 28, 2015 11:44 AM
> To: Wu, Feng
> Cc: tglx@linutronix.de; mingo@redhat.com; hpa@zytor.com; x86@kernel.org;
> gleb@kernel.org; pbonzini@redhat.com; dwmw2@infradead.org;
> joro@8bytes.org; jiang.liu@linux.intel.com; eric.auger@linaro.org;
> linux-kernel@vger.kernel.org; iommu@lists.linux-foundation.org;
> kvm@vger.kernel.org
> Subject: Re: [v3 00/26] Add VT-d Posted-Interrupts support
> 
> On Wed, 2015-01-28 at 03:01 +0000, Wu, Feng wrote:
> >
> > > -----Original Message-----
> > > From: Wu, Feng
> > > Sent: Wednesday, January 21, 2015 10:26 AM
> > > To: tglx@linutronix.de; mingo@redhat.com; hpa@zytor.com;
> x86@kernel.org;
> > > gleb@kernel.org; pbonzini@redhat.com; dwmw2@infradead.org;
> > > joro@8bytes.org; alex.williamson@redhat.com; jiang.liu@linux.intel.com
> > > Cc: eric.auger@linaro.org; linux-kernel@vger.kernel.org;
> > > iommu@lists.linux-foundation.org; kvm@vger.kernel.org; Wu, Feng
> > > Subject: RE: [v3 00/26] Add VT-d Posted-Interrupts support
> > >
> > >
> > > > -----Original Message-----
> > > > From: Wu, Feng
> > > > Sent: Friday, December 12, 2014 11:15 PM
> > > > To: tglx@linutronix.de; mingo@redhat.com; hpa@zytor.com;
> > > x86@kernel.org;
> > > > gleb@kernel.org; pbonzini@redhat.com; dwmw2@infradead.org;
> > > > joro@8bytes.org; alex.williamson@redhat.com; jiang.liu@linux.intel.com
> > > > Cc: eric.auger@linaro.org; linux-kernel@vger.kernel.org;
> > > > iommu@lists.linux-foundation.org; kvm@vger.kernel.org; Wu, Feng
> > > > Subject: [v3 00/26] Add VT-d Posted-Interrupts support
> > > >
> > > > VT-d Posted-Interrupts is an enhancement to CPU side Posted-Interrupt.
> > > > With VT-d Posted-Interrupts enabled, external interrupts from
> > > > direct-assigned devices can be delivered to guests without VMM
> > > > intervention when guest is running in non-root mode.
> > > >
> > > > You can find the VT-d Posted-Interrtups Spec. in the following URL:
> > > >
> > >
> http://www.intel.com/content/www/us/en/intelligent-systems/intel-technolog
> > > > y/vt-directed-io-spec.html
> > > >
> > > > v1->v2:
> > > > * Use VFIO framework to enable this feature, the VFIO part of this series is
> > > >   base on Eric's patch "[PATCH v3 0/8] KVM-VFIO IRQ forward control"
> > > > * Rebase this patchset on
> > > > git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git,
> > > >   then revise some irq logic based on the new hierarchy irqdomain
> patches
> > > > provided
> > > >   by Jiang Liu <jiang.liu@linux.intel.com>
> > > >
> > > > v2->v3:
> > > > * Adjust the Posted-interrupts Descriptor updating logic when vCPU is
> > > >   preempted or blocked.
> > > > * KVM_DEV_VFIO_DEVICE_POSTING_IRQ -->
> > > > KVM_DEV_VFIO_DEVICE_POST_IRQ
> > > > * __KVM_HAVE_ARCH_KVM_VFIO_POSTING -->
> > > > __KVM_HAVE_ARCH_KVM_VFIO_POST
> > > > * Add KVM_DEV_VFIO_DEVICE_UNPOST_IRQ attribute for VFIO irq, which
> > > >   can be used to change back to remapping mode.
> > > > * Fix typo
> > > >
> > > > This patch series is made of the following groups:
> > > > 1-6: Some preparation changes in iommu and irq component, this is based
> on
> > > > the
> > > >      new hierarchy irqdomain logic.
> > > > 7-9, 26: IOMMU changes for VT-d Posted-Interrupts, such as, feature
> > > > detection,
> > > >           command line parameter.
> > > > 10-17, 22-25: Changes related to KVM itself.
> > > > 18-20: Changes in VFIO component, this part was previously sent out as
> > > > "[RFC PATCH v2 0/2] kvm-vfio: implement the vfio skeleton for VT-d
> > > > Posted-Interrupts"
> > > > 21: x86 irq related changes
> > > >
> > > > Feng Wu (26):
> > > >   genirq: Introduce irq_set_vcpu_affinity() to target an interrupt to a
> > > >     VCPU
> > > >   iommu: Add new member capability to struct irq_remap_ops
> > > >   iommu, x86: Define new irte structure for VT-d Posted-Interrupts
> > > >   iommu, x86: Implement irq_set_vcpu_affinity for intel_ir_chip
> > > >   x86, irq: Implement irq_set_vcpu_affinity for pci_msi_ir_controller
> > > >   iommu, x86: No need to migrating irq for VT-d Posted-Interrupts
> > > >   iommu, x86: Add cap_pi_support() to detect VT-d PI capability
> > > >   iommu, x86: Add intel_irq_remapping_capability() for Intel
> > > >   iommu, x86: define irq_remapping_cap()
> > > >   KVM: change struct pi_desc for VT-d Posted-Interrupts
> > > >   KVM: Add some helper functions for Posted-Interrupts
> > > >   KVM: Initialize VT-d Posted-Interrupts Descriptor
> > > >   KVM: Define a new interface kvm_find_dest_vcpu() for VT-d PI
> > > >   KVM: Get Posted-Interrupts descriptor address from struct kvm_vcpu
> > > >   KVM: add interfaces to control PI outside vmx
> > > >   KVM: Make struct kvm_irq_routing_table accessible
> > > >   KVM: make kvm_set_msi_irq() public
> > > >   KVM: kvm-vfio: User API for VT-d Posted-Interrupts
> > > >   KVM: kvm-vfio: implement the VFIO skeleton for VT-d Posted-Interrupts
> > > >   KVM: x86: kvm-vfio: VT-d posted-interrupts setup
> > > >   x86, irq: Define a global vector for VT-d Posted-Interrupts
> > > >   KVM: Define a wakeup worker thread for vCPU
> > > >   KVM: Update Posted-Interrupts Descriptor when vCPU is preempted
> > > >   KVM: Update Posted-Interrupts Descriptor when vCPU is blocked
> > > >   KVM: Suppress posted-interrupt when 'SN' is set
> > > >   iommu/vt-d: Add a command line parameter for VT-d posted-interrupts
> > > >
> > > >  Documentation/kernel-parameters.txt        |   1 +
> > > >  Documentation/virtual/kvm/devices/vfio.txt |   9 ++
> > > >  arch/x86/include/asm/entry_arch.h          |   2 +
> > > >  arch/x86/include/asm/hardirq.h             |   1 +
> > > >  arch/x86/include/asm/hw_irq.h              |   2 +
> > > >  arch/x86/include/asm/irq_remapping.h       |  11 ++
> > > >  arch/x86/include/asm/irq_vectors.h         |   1 +
> > > >  arch/x86/include/asm/kvm_host.h            |  12 ++
> > > >  arch/x86/kernel/apic/msi.c                 |   1 +
> > > >  arch/x86/kernel/entry_64.S                 |   2 +
> > > >  arch/x86/kernel/irq.c                      |  27 ++++
> > > >  arch/x86/kernel/irqinit.c                  |   2 +
> > > >  arch/x86/kvm/Makefile                      |   2 +-
> > > >  arch/x86/kvm/kvm_vfio_x86.c                |  77 +++++++++
> > > >  arch/x86/kvm/vmx.c                         | 244
> > > > ++++++++++++++++++++++++++++-
> > > >  arch/x86/kvm/x86.c                         |  22 ++-
> > > >  drivers/iommu/intel_irq_remapping.c        |  68 +++++++-
> > > >  drivers/iommu/irq_remapping.c              |  24 ++-
> > > >  drivers/iommu/irq_remapping.h              |   8 +
> > > >  include/linux/dmar.h                       |  32 ++++
> > > >  include/linux/intel-iommu.h                |   1 +
> > > >  include/linux/irq.h                        |   7 +
> > > >  include/linux/kvm_host.h                   |  46 ++++++
> > > >  include/uapi/linux/kvm.h                   |  11 ++
> > > >  kernel/irq/chip.c                          |  14 ++
> > > >  kernel/irq/manage.c                        |  20 +++
> > > >  virt/kvm/irq_comm.c                        |  43 ++++-
> > > >  virt/kvm/irqchip.c                         |  11 --
> > > >  virt/kvm/kvm_main.c                        |  15 ++
> > > >  virt/kvm/vfio.c                            | 107 +++++++++++++
> > > >  30 files changed, 795 insertions(+), 28 deletions(-)
> > > >  create mode 100644 arch/x86/kvm/kvm_vfio_x86.c
> > > >
> > >
> > > Hi Paolo, Alex, and other maintainers,
> > >
> > > Since this series contain multiple subsystems, IOMMU, irq, x86, VFIO, KVM,
> etc.
> > > I am wondering how you guys handled this case before? If all the patches are
> > > reviewed and acked by the associated maintainer, are you only merge the
> > > patches
> > > related to your own subsystem to your tree? However, you may also need
> get
> > > other
> > > patches to make the build successful, so I am a little curious about how you
> guys
> > > handle this? Thanks a lot!
> >
> > Can anyone share some experiences about this?
> 
> Generally you need to split the patches into logical changes per
> subsystem and submit them separately through the mailing list and
> maintainer.  This helps to make sure the changes make sense and stand on
> their own and aren't simply a hack to reach the end goal.  Submit what
> you can in parallel, but expect that if you send patches dependent on
> other, unmerged series, they will get ignored and will need to be resent
> when the dependencies are resolved in -next.  Thanks,
> 
> Alex

Thanks a lot for your response, Alex! I am still waiting for comments for
the generic IRQ and IOMMU parts, after I got the comments, I will consider
your advice in the next post. Thank you!

Thanks,
Feng

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
