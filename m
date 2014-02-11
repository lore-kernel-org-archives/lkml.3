Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830AbaBKJUZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 04:20:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37836 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751312AbaBKJUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 04:20:22 -0500
Date: Tue, 11 Feb 2014 09:20:17 +0000
From: Mel Gorman <mgorman@suse.de>
To: Luiz Capitulino <lcapitulino@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mtosatti@redhat.com, aarcange@redhat.com,
        andi@firstfloor.org, riel@redhat.com
Subject: Re: [PATCH 1/4] memblock: memblock_virt_alloc_internal(): alloc from
 specified node only
Message-ID: <20140211092017.GG6732@suse.de>
References: <1392053268-29239-1-git-send-email-lcapitulino@redhat.com>
 <1392053268-29239-2-git-send-email-lcapitulino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1392053268-29239-2-git-send-email-lcapitulino@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 12:27:45PM -0500, Luiz Capitulino wrote:
> From: Luiz capitulino <lcapitulino@redhat.com>
> 
> If an allocation from the node specified by the nid argument fails,
> memblock_virt_alloc_internal() automatically tries to allocate memory
> from other nodes.
> 
> This is fine is the caller don't care which node is going to allocate
> the memory. However, there are cases where the caller wants memory to
> be allocated from the specified node only. If that's not possible, then
> memblock_virt_alloc_internal() should just fail.
> 
> This commit adds a new flags argument to memblock_virt_alloc_internal()
> where the caller can control this behavior.
> 
> Signed-off-by: Luiz capitulino <lcapitulino@redhat.com>
> ---
>  mm/memblock.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memblock.c b/mm/memblock.c
> index 39a31e7..b0c7b2e 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -1028,6 +1028,8 @@ phys_addr_t __init memblock_alloc_try_nid(phys_addr_t size, phys_addr_t align, i
>  	return memblock_alloc_base(size, align, MEMBLOCK_ALLOC_ACCESSIBLE);
>  }
>  
> +#define ALLOC_SPECIFIED_NODE_ONLY 0x1
> +

It's not a perfect fit but you could use gfp_t and GFP_THISNODE. The
meaning of the flag is recognised and while you are not using it with a
page allocator, we already use GFP flags with the slab allocator without
confusion.

-- 
Mel Gorman
SUSE Labs
