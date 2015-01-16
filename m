Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839AbbAPJet (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 04:34:49 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:59947 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751041AbbAPJer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 04:34:47 -0500
Message-ID: <54B8DB30.2070206@arm.com>
Date: Fri, 16 Jan 2015 09:34:40 +0000
From: =?windows-1252?Q?Andr=E9_Przywara?= <andre.przywara@arm.com>
Organization: ARM Ltd.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Eric Auger <eric.auger@linaro.org>, eric.auger@st.com,
        christoffer.dall@linaro.org, marc.zyngier@arm.com,
        andre.przywara@arm.com, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        alex.williamson@redhat.com, agraf@suse.de, gleb@kernel.org,
        pbonzini@redhat.com, borntraeger@de.ibm.com, cornelia.huck@de.ibm.com
CC: will.deacon@arm.com, linux-kernel@vger.kernel.org, patches@linaro.org
Subject: Re: [PATCH v7 1/4] KVM: arm/arm64: unset CONFIG_HAVE_KVM_IRQCHIP
References: <1421333267-15287-1-git-send-email-eric.auger@linaro.org> <1421333267-15287-2-git-send-email-eric.auger@linaro.org>
In-Reply-To: <1421333267-15287-2-git-send-email-eric.auger@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2015 02:47 PM, Eric Auger wrote:
> CONFIG_HAVE_KVM_IRQCHIP is needed to support IRQ routing (along
> with irq_comm.c and irqchip.c usage). This is not the case for
> arm/arm64 currently.
> 
> This patch unsets the flag for both arm and arm64.
> 
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
> Acked-by: Will Deacon <will.deacon@arm.com>

Given it's current usage in the kernel HAVE_KVM_IRQCHIP seems to be
grossly misnamed these days, but that's certainly not the duty of this
patch to solve. So:

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre.

> ---
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
> 

