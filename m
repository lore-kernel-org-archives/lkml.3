Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067AbaFEANt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:13:49 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:35545 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094AbaFEANr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 20:13:47 -0400
Date: Wed, 4 Jun 2014 17:13:44 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Nishanth Aravamudan <nacc@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Joonsoo Kim <js1304@gmail.com>,
        Han Pingtian <hanpt@linux.vnet.ibm.com>, paulus@samba.org,
        Anton Blanchard <anton@samba.org>, mpm@selenic.com,
        linuxppc-dev@lists.ozlabs.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: Re: [RESEND PATCH] slub: search partial list on numa_mem_id(),
 instead of numa_node_id()
In-Reply-To: <1391674026-20092-1-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <alpine.DEB.2.02.1406041712350.23521@chino.kir.corp.google.com>
References: <20140206020757.GC5433@linux.vnet.ibm.com> <1391674026-20092-1-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2014, Joonsoo Kim wrote:

> Currently, if allocation constraint to node is NUMA_NO_NODE, we search
> a partial slab on numa_node_id() node. This doesn't work properly on the
> system having memoryless node, since it can have no memory on that node and
> there must be no partial slab on that node.
> 
> On that node, page allocation always fallback to numa_mem_id() first. So
> searching a partial slab on numa_node_id() in that case is proper solution
> for memoryless node case.
> 
> Acked-by: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
> Acked-by: David Rientjes <rientjes@google.com>
> Acked-by: Christoph Lameter <cl@linux.com>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 545a170..cc1f995 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -1698,7 +1698,7 @@ static void *get_partial(struct kmem_cache *s, gfp_t flags, int node,
>  		struct kmem_cache_cpu *c)
>  {
>  	void *object;
> -	int searchnode = (node == NUMA_NO_NODE) ? numa_node_id() : node;
> +	int searchnode = (node == NUMA_NO_NODE) ? numa_mem_id() : node;
>  
>  	object = get_partial_node(s, get_node(s, searchnode), c, flags);
>  	if (object || node != NUMA_NO_NODE)

Andrew, can you merge this please?  It's still not in linux-next.
