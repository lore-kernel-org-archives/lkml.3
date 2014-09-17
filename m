Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbaIQI3q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 04:29:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53682 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753739AbaIQI3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 04:29:44 -0400
Date: Wed, 17 Sep 2014 10:29:38 +0200
From: Joerg Roedel <jroedel@suse.de>
To: Joerg Roedel <joro@8bytes.org>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 09/12] kvm: iommu: Convert to use new iommu_capable() API
 function
Message-ID: <20140917082938.GC2533@suse.de>
References: <1409914384-21191-1-git-send-email-joro@8bytes.org>
 <1409914384-21191-10-git-send-email-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409914384-21191-10-git-send-email-joro@8bytes.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paolo, Gleb,

On Fri, Sep 05, 2014 at 12:53:01PM +0200, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> Cc: Gleb Natapov <gleb@kernel.org>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  virt/kvm/iommu.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)

Do you have any objections against this patch? I would like to put this
series into the iommu tree.


Thanks,

	Joerg

> 
> diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
> index 714b949..45ee080 100644
> --- a/virt/kvm/iommu.c
> +++ b/virt/kvm/iommu.c
> @@ -191,8 +191,7 @@ int kvm_assign_device(struct kvm *kvm,
>  		return r;
>  	}
>  
> -	noncoherent = !iommu_domain_has_cap(kvm->arch.iommu_domain,
> -					    IOMMU_CAP_CACHE_COHERENCY);
> +	noncoherent = !iommu_capable(&pci_bus_type, IOMMU_CAP_CACHE_COHERENCY);
>  
>  	/* Check if need to update IOMMU page table for guest memory */
>  	if (noncoherent != kvm->arch.iommu_noncoherent) {
> @@ -254,8 +253,7 @@ int kvm_iommu_map_guest(struct kvm *kvm)
>  	}
>  
>  	if (!allow_unsafe_assigned_interrupts &&
> -	    !iommu_domain_has_cap(kvm->arch.iommu_domain,
> -				  IOMMU_CAP_INTR_REMAP)) {
> +	    !iommu_capable(&pci_bus_type, IOMMU_CAP_INTR_REMAP)) {
>  		printk(KERN_WARNING "%s: No interrupt remapping support,"
>  		       " disallowing device assignment."
>  		       " Re-enble with \"allow_unsafe_assigned_interrupts=1\""
> -- 
> 1.9.1
