Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235Ab3IYTbR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 15:31:17 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:39707 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164Ab3IYTbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 15:31:15 -0400
Date: Wed, 25 Sep 2013 12:31:27 -0700
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Andrew Jones <drjones@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, catalin.marinas@arm.com,
        gleb@redhat.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, marc.zyngier@arm.com,
        pbonzini@redhat.com, linux@arm.linux.org.uk, will.deacon@arm.com
Subject: Re: [PATCH v2] arm32: kvm: rename CONFIG_KVM_ARM_MAX_VCPUS
Message-ID: <20130925193127.GD32311@cbox>
References: <1379160656-28050-3-git-send-email-drjones@redhat.com>
 <1380031768-21354-1-git-send-email-drjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380031768-21354-1-git-send-email-drjones@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 24, 2013 at 04:09:28PM +0200, Andrew Jones wrote:
> Drop the _ARM_ part of the name. We can then introduce a config option
> like this to aarch64 and other arches using the same name - allowing
> grep to show them all. Also update the help text to describe the option
> more completely.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> 
> ---
> v2: reword help text some more
> ---
>  arch/arm/include/asm/kvm_host.h | 4 ++--
>  arch/arm/kvm/Kconfig            | 9 +++++----
>  2 files changed, 7 insertions(+), 6 deletions(-)
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
> index ebf5015508b52..8e56ccf45edce 100644
> --- a/arch/arm/kvm/Kconfig
> +++ b/arch/arm/kvm/Kconfig
> @@ -40,16 +40,17 @@ config KVM_ARM_HOST
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
> +	  current hardware supports. Choosing a lower number decreases
> +	  the size of the VM data structure. This number may also be
> +	  increased.
>  
Maybe I'm being forgetful, but what do you mean by "This number may also
be increased" ?

-Christoffer
