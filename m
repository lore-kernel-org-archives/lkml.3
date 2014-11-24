Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998AbaKXLJy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 06:09:54 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:37718 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbaKXLJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 06:09:52 -0500
Date: Mon, 24 Nov 2014 11:09:45 +0000
From: Will Deacon <will.deacon@arm.com>
To: Eric Auger <eric.auger@linaro.org>
Cc: "eric.auger@st.com" <eric.auger@st.com>,
        "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "joel.schopp@amd.com" <joel.schopp@amd.com>,
        "kim.phillips@freescale.com" <kim.phillips@freescale.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "gleb@kernel.org" <gleb@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "a.motakis@virtualopensystems.com" <a.motakis@virtualopensystems.com>,
        "a.rigo@virtualopensystems.com" <a.rigo@virtualopensystems.com>,
        "john.liuli@huawei.com" <john.liuli@huawei.com>,
        "ming.lei@canonical.com" <ming.lei@canonical.com>,
        "feng.wu@intel.com" <feng.wu@intel.com>
Subject: Re: [PATCH v4 1/3] KVM: arm/arm64: unset CONFIG_HAVE_KVM_IRQCHIP
Message-ID: <20141124105532.GA13324@arm.com>
References: <1416765420-12057-1-git-send-email-eric.auger@linaro.org>
 <1416765420-12057-2-git-send-email-eric.auger@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416765420-12057-2-git-send-email-eric.auger@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 23, 2014 at 05:56:58PM +0000, Eric Auger wrote:
> CONFIG_HAVE_KVM_IRQCHIP is needed to support IRQ routing (along
> with irq_comm.c and irqchip.c usage). This is not the case for
> arm/arm64 currently.
> 
> This patch unsets the flag for both arm and arm64.
> 
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> ---

The arm64 change is fine by me. I assume this will go via the kvm tree
eventually?

  Acked-by: Will Deacon <will.deacon@arm.com>

Will

>  arch/arm/kvm/Kconfig   | 2 --
>  arch/arm64/kvm/Kconfig | 1 -
>  2 files changed, 3 deletions(-)
> 
> diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
> index 466bd29..9f581b1 100644
> --- a/arch/arm/kvm/Kconfig
> +++ b/arch/arm/kvm/Kconfig
> @@ -55,7 +55,6 @@ config KVM_ARM_MAX_VCPUS
>  config KVM_ARM_VGIC
>  	bool "KVM support for Virtual GIC"
>  	depends on KVM_ARM_HOST && OF
> -	select HAVE_KVM_IRQCHIP
>  	default y
>  	---help---
>  	  Adds support for a hardware assisted, in-kernel GIC emulation.
> @@ -63,7 +62,6 @@ config KVM_ARM_VGIC
>  config KVM_ARM_TIMER
>  	bool "KVM support for Architected Timers"
>  	depends on KVM_ARM_VGIC && ARM_ARCH_TIMER
> -	select HAVE_KVM_IRQCHIP
>  	default y
>  	---help---
>  	  Adds support for the Architected Timers in virtual machines
> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index 8ba85e9..279e1a0 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -50,7 +50,6 @@ config KVM_ARM_MAX_VCPUS
>  config KVM_ARM_VGIC
>  	bool
>  	depends on KVM_ARM_HOST && OF
> -	select HAVE_KVM_IRQCHIP
>  	---help---
>  	  Adds support for a hardware assisted, in-kernel GIC emulation.
>  
> -- 
> 1.9.1
> 
> 
