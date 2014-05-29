Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948AbaE2Duq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 23:50:46 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:42916 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbaE2Dup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 23:50:45 -0400
Date: Wed, 28 May 2014 22:50:41 -0500
From: Seth Jennings <sjennings@variantweb.net>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] mm/zswap : NUMA aware allocation for zswap_dstmem
Message-ID: <20140529035041.GB18063@cerebellum.variantweb.net>
References: <1401209749.5367.245.camel@edumazet-glaptop2.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401209749.5367.245.camel@edumazet-glaptop2.roam.corp.google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 09:55:49AM -0700, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> zswap_dstmem is a percpu block of memory, which should
> be allocated using kmalloc_node(), to get better NUMA
> locality.
> 
> Without it, all the blocks are allocated from a single node.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Acked-by: Seth Jennings <sjennings@variantweb.net>

> ---
>  mm/zswap.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index aeaef0fb5624..008388fe7b0f 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -347,7 +347,7 @@ static int __zswap_cpu_notifier(unsigned long action, unsigned long cpu)
>  			return NOTIFY_BAD;
>  		}
>  		*per_cpu_ptr(zswap_comp_pcpu_tfms, cpu) = tfm;
> -		dst = kmalloc(PAGE_SIZE * 2, GFP_KERNEL);
> +		dst = kmalloc_node(PAGE_SIZE * 2, GFP_KERNEL, cpu_to_node(cpu));
>  		if (!dst) {
>  			pr_err("can't allocate compressor buffer\n");
>  			crypto_free_comp(tfm);
> 
> 
