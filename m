Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497Ab3DWQpk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 12:45:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58296 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755985Ab3DWQpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 12:45:39 -0400
Date: Tue, 23 Apr 2013 13:45:28 -0300
From: Rafael Aquini <aquini@redhat.com>
To: Aaron Tomlin <atomlin@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cl@linux.com,
        penberg@kernel.org, Rik <riel@redhat.com>
Subject: Re: [Patch v2] mm: slab: Verify the nodeid passed to
 ____cache_alloc_node
Message-ID: <20130423164528.GC16695@optiplex.redhat.com>
References: <1081382531.982691.1366726661820.JavaMail.root@redhat.com>
 <1014891011.990074.1366727496599.JavaMail.root@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1014891011.990074.1366727496599.JavaMail.root@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 10:31:36AM -0400, Aaron Tomlin wrote:
> Hi,
> 
> This patch is in response to BZ#42967 [1]. 
> Using VM_BUG_ON so it's used only when CONFIG_DEBUG_VM is set,
> given that ____cache_alloc_node() is a hot code path.
> 
This seems to be a valid condition to BUG_ON, though.

> Cheers,
> Aaron
> 
> [1]: https://bugzilla.kernel.org/show_bug.cgi?id=42967
> 
> ---8<---
> mm: slab: Verify the nodeid passed to ____cache_alloc_node
>     
> If the nodeid is > num_online_nodes() this can cause an
> Oops and a panic(). The purpose of this patch is to assert
> if this condition is true to aid debugging efforts rather
> than some random NULL pointer dereference or page fault.
>     
> Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
> Reviewed-by: Rik van Riel <riel@redhat.com>
>

Acked-by: Rafael Aquini <aquini@redhat.com>


 
> 
>  slab.c |    1 +
>  1 file changed, 1 insertion(+)
>  
> diff --git a/mm/slab.c b/mm/slab.c
> index e7667a3..735e8bd 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
>  -3412,6 +3412,7 @@ static void *____cache_alloc_node(struct kmem_cache *cachep, gfp_t flags,
>  	void *obj;
>  	int x;
>  
> +	VM_BUG_ON(nodeid > num_online_nodes());
>  	l3 = cachep->nodelists[nodeid];
>  	BUG_ON(!l3);
