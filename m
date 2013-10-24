Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab3JXJwK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 05:52:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59313 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754577Ab3JXJwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 05:52:09 -0400
Date: Thu, 24 Oct 2013 12:52:04 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 10/15] KVM: MMU: allocate shadow pages from slab
Message-ID: <20131024095204.GD5289@redhat.com>
References: <1382534973-13197-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <1382534973-13197-11-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <20131024091905.GB5289@redhat.com>
 <5268E888.7060608@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5268E888.7060608@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 24, 2013 at 05:29:44PM +0800, Xiao Guangrong wrote:
> On 10/24/2013 05:19 PM, Gleb Natapov wrote:
> 
> >> @@ -946,7 +947,7 @@ static inline struct kvm_mmu_page *page_header(hpa_t shadow_page)
> >>  {
> >>  	struct page *page = pfn_to_page(shadow_page >> PAGE_SHIFT);
> >>  
> >> -	return (struct kvm_mmu_page *)page_private(page);
> >> +	return (struct kvm_mmu_page *)(page->mapping);
> > Why?
> 
> That's because page->private has been used by slab:
>
But does lockless path actually looks at it?
  
> 	/* Remainder is not double word aligned */
> 	union {
> 		unsigned long private;		/* Mapping-private opaque data:
> 					 	 * usually used for buffer_heads
> 						 * if PagePrivate set; used for
> 						 * swp_entry_t if PageSwapCache;
> 						 * indicates order in the buddy
> 						 * system if PG_buddy is set.
> 						 */
> #if USE_SPLIT_PTLOCKS
> 		spinlock_t ptl;
> #endif
> 		struct kmem_cache *slab_cache;	/* SL[AU]B: Pointer to slab */
> 		struct page *first_page;	/* Compound tail pages */
> 	};

--
			Gleb.
