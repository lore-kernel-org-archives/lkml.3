Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452AbaKXKuI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 05:50:08 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:64668 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbaKXKuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 05:50:06 -0500
Date: Mon, 24 Nov 2014 11:50:37 +0100
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
Subject: Re: [RFC 0/4] vgic additions for forwarded irq
Message-ID: <20141124105037.GL3401@cbox>
References: <1416766373-13569-1-git-send-email-eric.auger@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416766373-13569-1-git-send-email-eric.auger@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 23, 2014 at 07:12:49PM +0100, Eric Auger wrote:
> This series applies on top of "ARM: Forwarding physical
> interrupts to a guest VM" (http://lwn.net/Articles/603514/)
> series.

Marc and Eric,

Does it make sense to review and look at these patches given the current
state of the forwarding patches, or should we wait until Marc respins
that series?

> 
> It brings some extra functionalities that were requested to
> be able to inject virtual level sensitive IRQs triggered from
> VFIO/irqfd.
> 
> It adds:
> - a specific handling of forwarded IRQ into the VGIC state machine.
> - deactivation of physical IRQ and unforwarding on vgic destruction
> - handling of forwarded IRQ injection before the vgic readiness:
>   this was needed because in a sample qemu/vfio use case, qemu
>   registers forwarded IRQ and set up VFIO signaling before the first
>   vcpu run and hence before vgic readiness. At that time some
>   physical IRQ may hit before the VGIC readiness. This is typically
>   observed with Calxeda xgmac on second QEMU run.

this seems related to my note in the last patch?  Same or different
problem?

-Christoffer

> - rbtree lock addition.
> 
> Integrated pieces can be found at
> ssh://git.linaro.org/people/eric.auger/linux.git
> on branch irqfd_integ_v8
> 
> The first 2 patch files were previously part of [RFC v2 0/9]
> KVM-VFIO IRQ forward control (https://lkml.org/lkml/2014/9/1/347).
> 
> 
> Eric Auger (4):
>   KVM: arm: vgic: fix state machine for forwarded IRQ
>   KVM: arm: vgic: add forwarded irq rbtree lock
>   KVM: arm: vgic: cleanup forwarded IRQs on destroy
>   KVM: arm: vgic: handle irqfd forwarded IRQ injection before vgic
>     readiness
> 
>  include/kvm/arm_vgic.h |   1 +
>  virt/kvm/arm/vgic.c    | 128 +++++++++++++++++++++++++++++++++++++++++--------
>  2 files changed, 110 insertions(+), 19 deletions(-)
> 
> -- 
> 1.9.1
> 
