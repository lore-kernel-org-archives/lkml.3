Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243AbaK3MOG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 07:14:06 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:59394 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbaK3MOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 07:14:04 -0500
Date: Sun, 30 Nov 2014 13:14:02 +0100
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Eric Auger <eric.auger@linaro.org>
Cc: eric.auger@st.com, marc.zyngier@arm.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, alex.williamson@redhat.com, joel.schopp@amd.com,
        kim.phillips@freescale.com, paulus@samba.org, gleb@kernel.org,
        pbonzini@redhat.com, agraf@suse.de, linux-kernel@vger.kernel.org,
        patches@linaro.org, will.deacon@arm.com,
        a.motakis@virtualopensystems.com, a.rigo@virtualopensystems.com,
        john.liuli@huawei.com, ming.lei@canonical.com, feng.wu@intel.com
Subject: Re: [PATCH v3 2/8] KVM: arm64: Enable the KVM-VFIO device
Message-ID: <20141130121402.GC82106@macair>
References: <1416767760-14487-1-git-send-email-eric.auger@linaro.org>
 <1416767760-14487-3-git-send-email-eric.auger@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416767760-14487-3-git-send-email-eric.auger@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 23, 2014 at 07:35:54PM +0100, Eric Auger wrote:
> Used by KVM-enabled VFIO-based device passthrough support in QEMU.
> 
> Signed-off-by: Joel Schopp <joel.schopp@amd.com>
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> 
> ---
> 
> Extracted from [RFC PATCH] arm64: KVM: add irqfd support
> http://www.spinics.net/lists/kvm-arm/msg10798.html
> ---
>  arch/arm64/kvm/Kconfig  | 1 +
>  arch/arm64/kvm/Makefile | 2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index 09c25c2..2edf926 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -26,6 +26,7 @@ config KVM
>  	select KVM_ARM_HOST
>  	select KVM_ARM_VGIC
>  	select KVM_ARM_TIMER
> +	select KVM_VFIO
>  	select HAVE_KVM_EVENTFD
>  	---help---
>  	  Support hosting virtualized guest machines.
> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> index 2e6b827..81ed091 100644
> --- a/arch/arm64/kvm/Makefile
> +++ b/arch/arm64/kvm/Makefile
> @@ -11,7 +11,7 @@ ARM=../../../arch/arm/kvm
>  
>  obj-$(CONFIG_KVM_ARM_HOST) += kvm.o
>  
> -kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o
> +kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o $(KVM)/vfio.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(ARM)/arm.o $(ARM)/mmu.o $(ARM)/mmio.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(ARM)/psci.o $(ARM)/perf.o
>  
> -- 
> 1.9.1
> 

Should these patches not be squashed into one?

Also, what do they enable at this point?  Should they be queued by the
end of the series instead?

-Christoffer
