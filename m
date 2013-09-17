Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab3IQVmN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 17:42:13 -0400
Received: from mail-ye0-f179.google.com ([209.85.213.179]:64074 "EHLO
	mail-ye0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863Ab3IQVmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 17:42:11 -0400
Date: Tue, 17 Sep 2013 22:42:08 +0100
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Andrew Jones <drjones@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, catalin.marinas@arm.com,
        gleb@redhat.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, marc.zyngier@arm.com,
        pbonzini@redhat.com, linux@arm.linux.org.uk, will.deacon@arm.com
Subject: Re: [PATCH 2/3] arm32: kvm: rename CONFIG_KVM_ARM_MAX_VCPUS
Message-ID: <20130917214208.GK7623@lvm>
References: <1379160656-28050-1-git-send-email-drjones@redhat.com>
 <1379160656-28050-3-git-send-email-drjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379160656-28050-3-git-send-email-drjones@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 14, 2013 at 02:10:55PM +0200, Andrew Jones wrote:
> Drop the _ARM_ part of the name. We can then introduce a config option
> like this to aarch64 and other arches using the same name - allowing
> grep to show them all. Also update the help text to describe the option
> more completely.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  arch/arm/include/asm/kvm_host.h | 4 ++--
>  arch/arm/kvm/Kconfig            | 8 ++++----
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> index 7d22517d80711..c614d3eb176c6 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -25,8 +25,8 @@
>  #include <asm/fpstate.h>
>  #include <kvm/arm_arch_timer.h>
>  
> -#if defined(CONFIG_KVM_ARM_MAX_VCPUS)
> -#define KVM_MAX_VCPUS CONFIG_KVM_ARM_MAX_VCPUS
> +#if defined(CONFIG_KVM_MAX_VCPUS)
> +#define KVM_MAX_VCPUS CONFIG_KVM_MAX_VCPUS
>  #else
>  #define KVM_MAX_VCPUS 0
>  #endif
> diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
> index ebf5015508b52..de63bfccb3eb5 100644
> --- a/arch/arm/kvm/Kconfig
> +++ b/arch/arm/kvm/Kconfig
> @@ -40,16 +40,16 @@ config KVM_ARM_HOST
>  	---help---
>  	  Provides host support for ARM processors.
>  
> -config KVM_ARM_MAX_VCPUS
> +config KVM_MAX_VCPUS
>  	int "Number maximum supported virtual CPUs per VM"
>  	depends on KVM_ARM_HOST
>  	default 4
>  	help
>  	  Static number of max supported virtual CPUs per VM.
>  
> -	  If you choose a high number, the vcpu structures will be quite
> -	  large, so only choose a reasonable number that you expect to
> -	  actually use.
> +	  The default is set to the highest number of vcpus that
> +	  current hardware supports. Set to a lower number to save
> +	  some resources. Set to a higher number to test scalability.

Consider rephrasing the "Set to a lower number..." sentence to something
like "Choosing a lower number decreases the size of the VM data
structure.".

Also, please rephrase or get rid of the "Set to a higher number to test
scalability." sentence; you increase this value to be able to be able to
run more VCPUs (for whatever reason).

-- 
Christoffer
