Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751297AbaLQBjE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 20:39:04 -0500
Received: from mga11.intel.com ([192.55.52.93]:29030 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932AbaLQBjC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 20:39:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,590,1413270000"; 
   d="scan'208";a="638736631"
Message-ID: <5490DEB1.30305@intel.com>
Date: Wed, 17 Dec 2014 09:38:57 +0800
From: "Chen, Tiejun" <tiejun.chen@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>, Gleb Natapov <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH] kvm: iommu: Add cond_resched to legacy device assignment
 code
References: <1418744846-12868-1-git-send-email-joro@8bytes.org>
In-Reply-To: <1418744846-12868-1-git-send-email-joro@8bytes.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/12/16 23:47, Joerg Roedel wrote:
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
>   virt/kvm/iommu.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
> index c1e6ae9..ac427e8 100644
> --- a/virt/kvm/iommu.c
> +++ b/virt/kvm/iommu.c

This file is already gone after one latest commit c274e03af705, "kvm: 
x86: move assigned-dev.c and iommu.c to arch/x86/" is introduced, so you 
need to pull your tree firstly :)

Tiejun


> @@ -137,7 +137,7 @@ int kvm_iommu_map_pages(struct kvm *kvm, struct kvm_memory_slot *slot)
>
>   		gfn += page_size >> PAGE_SHIFT;
>
> -
> +		cond_resched();
>   	}
>
>   	return 0;
> @@ -311,6 +311,8 @@ static void kvm_iommu_put_pages(struct kvm *kvm,
>   		kvm_unpin_pages(kvm, pfn, unmap_pages);
>
>   		gfn += unmap_pages;
> +
> +		cond_resched();
>   	}
>   }
>
>
