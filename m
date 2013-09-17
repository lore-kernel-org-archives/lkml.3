Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016Ab3IQVec (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 17:34:32 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:33396 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954Ab3IQVeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 17:34:31 -0400
Date: Tue, 17 Sep 2013 22:34:28 +0100
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Andrew Jones <drjones@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, catalin.marinas@arm.com,
        gleb@redhat.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, marc.zyngier@arm.com,
        pbonzini@redhat.com, linux@arm.linux.org.uk, will.deacon@arm.com
Subject: Re: [PATCH 3/3] aarch64: kvm: introduce CONFIG_KVM_MAX_VCPUS
Message-ID: <20130917213428.GJ7623@lvm>
References: <1379160656-28050-1-git-send-email-drjones@redhat.com>
 <1379160656-28050-4-git-send-email-drjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379160656-28050-4-git-send-email-drjones@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 14, 2013 at 02:10:56PM +0200, Andrew Jones wrote:
> Take CONFIG_KVM_MAX_VCPUS from arm32, but set the default to 8.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  arch/arm64/include/asm/kvm_host.h |  7 ++++++-
>  arch/arm64/kvm/Kconfig            | 11 +++++++++++
>  2 files changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 0859a4ddd1e7d..d1af8c49a5ca4 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -26,7 +26,12 @@
>  #include <asm/kvm_asm.h>
>  #include <asm/kvm_mmio.h>
>  
> -#define KVM_MAX_VCPUS 4
> +#if defined(CONFIG_KVM_MAX_VCPUS)
> +#define KVM_MAX_VCPUS CONFIG_KVM_MAX_VCPUS
> +#else
> +#define KVM_MAX_VCPUS 0
> +#endif
> +
>  #define KVM_USER_MEM_SLOTS 32
>  #define KVM_PRIVATE_MEM_SLOTS 4
>  #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index 21e90820bd23c..c9924b02e84f7 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -35,6 +35,17 @@ config KVM_ARM_HOST
>  	---help---
>  	  Provides host support for ARM processors.
>  
> +config KVM_MAX_VCPUS
> +	int "Number maximum supported virtual CPUs per VM"
> +	depends on KVM_ARM_HOST
> +	default 8

That data structure gets really big with 8 max vcpus.  I think we should
keep this at 4 for now, a quad-core VM is quite reasonable for now.

> +	help
> +	  Static number of max supported virtual CPUs per VM.
> +
> +	  The default is set to the highest number of vcpus that
> +	  current hardware supports. Set to a lower number to save
> +	  some resources. Set to a higher number to test scalability.
> +
>  config KVM_ARM_VGIC
>  	bool
>  	depends on KVM_ARM_HOST && OF
> -- 
> 1.8.1.4
> 

-- 
Christoffer
