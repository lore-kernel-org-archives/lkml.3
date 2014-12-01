Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004AbaLAJWc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 04:22:32 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60717 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752834AbaLAJWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 04:22:30 -0500
X-Sasl-enc: RK1iTn3L36zvPahrePqLx76KtGhvIZHj7ZGygHPnTNsD 1417425749
Message-ID: <547C3353.9030502@iki.fi>
Date: Mon, 01 Dec 2014 11:22:27 +0200
From: Pekka Enberg <penberg@iki.fi>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>, linux-mm@kvack.org
CC: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] slab: Fix nodeid bounds check for non-contiguous node
 IDs
References: <20141201042844.GB11234@drongo>
In-Reply-To: <20141201042844.GB11234@drongo>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/1/14 6:28 AM, Paul Mackerras wrote:
> ---
> v2: include the oops message in the patch description
>
>   mm/slab.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/slab.c b/mm/slab.c
> index eb2b2ea..f34e053 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -3076,7 +3076,7 @@ static void *____cache_alloc_node(struct kmem_cache *cachep, gfp_t flags,
>   	void *obj;
>   	int x;
>   
> -	VM_BUG_ON(nodeid > num_online_nodes());
> +	VM_BUG_ON(nodeid < 0 || nodeid >= MAX_NUMNODES);
>   	n = get_node(cachep, nodeid);
>   	BUG_ON(!n);

Reviewed-by: Pekka Enberg <penberg@kernel.org>

