Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101AbaKXJrE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 04:47:04 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:41566 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328AbaKXJrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 04:47:01 -0500
Date: Mon, 24 Nov 2014 10:47:31 +0100
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Eric Auger <eric.auger@linaro.org>
Cc: eric.auger@st.com, marc.zyngier@arm.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, alex.williamson@redhat.com, joel.schopp@amd.com,
        kim.phillips@freescale.com, paulus@samba.org, gleb@kernel.org,
        pbonzini@redhat.com, linux-kernel@vger.kernel.org, patches@linaro.org,
        will.deacon@arm.com, a.motakis@virtualopensystems.com,
        a.rigo@virtualopensystems.com, john.liuli@huawei.com,
        ming.lei@canonical.com, feng.wu@intel.com
Subject: Re: [PATCH v4 0/3] irqfd support for arm/arm64
Message-ID: <20141124094731.GH3401@cbox>
References: <1416765420-12057-1-git-send-email-eric.auger@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416765420-12057-1-git-send-email-eric.auger@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 23, 2014 at 06:56:57PM +0100, Eric Auger wrote:
> This patch series enables irqfd on arm and arm64.
> 
> Irqfd framework enables to inject a virtual IRQ into a guest upon an
> eventfd trigger. User-side uses KVM_IRQFD VM ioctl to provide KVM with
> a kvm_irqfd struct that associates a VM, an eventfd, a virtual IRQ number
> (aka. the gsi). When an actor signals the eventfd (typically a VFIO
> platform driver), the kvm irqfd subsystem injects the gsi into the VM.
> 
> Resamplefd also is supported for level sensitive interrupts, ie. the
> user can provide another eventfd that is triggered when the completion
> of the virtual IRQ (gsi) is detected by the GIC.
> 
> The gsi must correspond to a shared peripheral interrupt (SPI), ie the
> GIC interrupt ID is gsi + 32.
> 
> The rationale behind not supporting PPI irqfd injection is that
> any device using a PPI would be a private-to-the-CPU device (timer for
> instance), so its state would have to be context-switched along with the
> VCPU and would require in-kernel wiring anyhow. It is not a relevant use
> case for irqfds.
> 
> this patch enables CONFIG_HAVE_KVM_EVENTFD and CONFIG_HAVE_KVM_IRQFD.
> 
> No IRQ routing table is used, enabling to remove CONFIG_HAVE_KVM_IRQCHIP
> 
> can be found at git://git.linaro.org/people/eric.auger/linux.git
> on branch irqfd_integ_v8
> 
> This work was tested with Calxeda Midway xgmac main interrupt with
> qemu-system-arm and QEMU VFIO platform device. Also irqfd was proven
> functional on several vhost-net prototypes.
> 
> v3 -> v4:
> - rebase on 3.18rc5
> - vgic dynamic instantiation brought new challenges:
>   handling of irqfd injection when vgic is not ready
> - unset of CONFIG_HAVE_KVM_IRQCHIP in a separate patch
> - add arm64 enable
> - vgic.c style modifications according to Christoffer comments
> 

There also seems to be a different split of the patches here?

We've probably also reached the point where you need to start rebasing
on Andre's GICv3 patches, which I expect will go in first.

Thanks,
-Christoffer
