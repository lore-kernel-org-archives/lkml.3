Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759919AbbA0Ubm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 15:31:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47347 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759655AbbA0Ubk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 15:31:40 -0500
Message-ID: <54C7F59E.9090806@redhat.com>
Date: Tue, 27 Jan 2015 21:31:26 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>, Gleb Natapov <gleb@kernel.org>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, jroedel@suse.de
Subject: Re: [PATCH v2] kvm: iommu: Add cond_resched to legacy device assignment
 code
References: <1422356239-18203-1-git-send-email-joro@8bytes.org>
In-Reply-To: <1422356239-18203-1-git-send-email-joro@8bytes.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 27/01/2015 11:57, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> When assigning devices to large memory guests (>=128GB guest
> memory in the failure case) the functions to create the
> IOMMU page-tables for the whole guest might run for a very
> long time. On non-preemptible kernels this might cause
> Soft-Lockup warnings. Fix these by adding a cond_resched()
> to the mapping and unmapping loops.
> 
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  arch/x86/kvm/iommu.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/iommu.c b/arch/x86/kvm/iommu.c
> index 17b73ee..7dbced3 100644
> --- a/arch/x86/kvm/iommu.c
> +++ b/arch/x86/kvm/iommu.c
> @@ -138,7 +138,7 @@ int kvm_iommu_map_pages(struct kvm *kvm, struct kvm_memory_slot *slot)
>  
>  		gfn += page_size >> PAGE_SHIFT;
>  
> -
> +		cond_resched();
>  	}
>  
>  	return 0;
> @@ -306,6 +306,8 @@ static void kvm_iommu_put_pages(struct kvm *kvm,
>  		kvm_unpin_pages(kvm, pfn, unmap_pages);
>  
>  		gfn += unmap_pages;
> +
> +		cond_resched();
>  	}
>  }
>  
> 

Applying to kvm/queue, thanks.

Paolo
