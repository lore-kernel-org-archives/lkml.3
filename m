Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601Ab3D2Q75 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 12:59:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:43000 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756852Ab3D2Q74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 12:59:56 -0400
Message-ID: <517EA6F2.706@infradead.org>
Date: Mon, 29 Apr 2013 09:59:30 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: gleb@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: KVM_CAP_IOMMU only available with device assignment
References: <20130429165334.19404.54557.stgit@bling.home>
In-Reply-To: <20130429165334.19404.54557.stgit@bling.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/13 09:54, Alex Williamson wrote:
> Fix build with CONFIG_PCI unset by linking KVM_CAP_IOMMU to
> device assignment config option.  It has no purpose otherwise.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.


> ---
>  arch/ia64/kvm/kvm-ia64.c |    2 ++
>  arch/x86/kvm/x86.c       |    2 ++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
> index dcc5607..5b2dc0d 100644
> --- a/arch/ia64/kvm/kvm-ia64.c
> +++ b/arch/ia64/kvm/kvm-ia64.c
> @@ -204,9 +204,11 @@ int kvm_dev_ioctl_check_extension(long ext)
>  	case KVM_CAP_COALESCED_MMIO:
>  		r = KVM_COALESCED_MMIO_PAGE_OFFSET;
>  		break;
> +#ifdef CONFIG_KVM_DEVICE_ASSIGNMENT
>  	case KVM_CAP_IOMMU:
>  		r = iommu_present(&pci_bus_type);
>  		break;
> +#endif
>  	default:
>  		r = 0;
>  	}
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 73e443f..f83a8e0 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2543,9 +2543,11 @@ int kvm_dev_ioctl_check_extension(long ext)
>  	case KVM_CAP_PV_MMU:	/* obsolete */
>  		r = 0;
>  		break;
> +#ifdef CONFIG_KVM_DEVICE_ASSIGNMENT
>  	case KVM_CAP_IOMMU:
>  		r = iommu_present(&pci_bus_type);
>  		break;
> +#endif
>  	case KVM_CAP_MCE:
>  		r = KVM_MAX_MCE_BANKS;
>  		break;
> 
> --


-- 
~Randy
