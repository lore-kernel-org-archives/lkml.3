Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969Ab3KDUPm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 15:15:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34688 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748Ab3KDUPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 15:15:41 -0500
Date: Mon, 4 Nov 2013 18:14:03 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Greg Edwards <gedwards@ddn.com>
Cc: kvm@vger.kernel.org,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] KVM: IOMMU: hva align mapping page size
Message-ID: <20131104201403.GA15044@amt.cnet>
References: <20131101160855.GB5052@psuche>
 <20131102011433.GA30381@amt.cnet>
 <20131104160812.GA6026@psuche>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131104160812.GA6026@psuche>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 04, 2013 at 09:08:12AM -0700, Greg Edwards wrote:
> When determining the page size we could use to map with the IOMMU, the
> page size should also be aligned with the hva, not just the gfn.  The
> gfn may not reflect the real alignment within the hugetlbfs file.
> 
> Signed-off-by: Greg Edwards <gedwards@ddn.com>
> Cc: stable@vger.kernel.org
> ---
>  virt/kvm/iommu.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
> index 72a130b..c329c8f 100644
> --- a/virt/kvm/iommu.c
> +++ b/virt/kvm/iommu.c
> @@ -103,6 +103,10 @@ int kvm_iommu_map_pages(struct kvm *kvm, struct kvm_memory_slot *slot)
>  		while ((gfn << PAGE_SHIFT) & (page_size - 1))
>  			page_size >>= 1;
>  
> +		/* Make sure hva is aligned to the page size we want to map */
> +		while (__gfn_to_hva_memslot(slot, gfn) & (page_size - 1))
> +			page_size >>= 1;
> +
>  		/*
>  		 * Pin all pages we are about to map in memory. This is
>  		 * important because we unmap and unpin in 4kb steps later.
> -- 
> 1.8.3.2

Reviewed-by: Marcelo Tosatti <mtosatti@redhat.com>

