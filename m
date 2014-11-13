Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbaKMCzt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 21:55:49 -0500
Received: from relay.variantweb.net ([104.131.199.242]:53824 "EHLO
	relay.variantweb.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753537AbaKMCzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 21:55:47 -0500
Date: Wed, 12 Nov 2014 20:55:44 -0600
From: Seth Jennings <sjennings@variantweb.net>
To: Mahendran Ganesh <opensource.ganesh@gmail.com>
Cc: minchan@kernel.org, ddstreet@ieee.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/zswap: add __init to some functions in zswap
Message-ID: <20141113025544.GB9068@medulla.variantweb.net>
References: <1415535832-4822-1-git-send-email-opensource.ganesh@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415535832-4822-1-git-send-email-opensource.ganesh@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 09, 2014 at 08:23:52PM +0800, Mahendran Ganesh wrote:
> zswap_cpu_init/zswap_comp_exit/zswap_entry_cache_create is only
> called by __init init_zswap()

Thanks for the cleanup!

Acked-by: Seth Jennings <sjennings@variantweb.net>

> 
> Signed-off-by: Mahendran Ganesh <opensource.ganesh@gmail.com>
> ---
>  mm/zswap.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 51a2c45..2e621fa 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -149,7 +149,7 @@ static int __init zswap_comp_init(void)
>  	return 0;
>  }
>  
> -static void zswap_comp_exit(void)
> +static void __init zswap_comp_exit(void)
>  {
>  	/* free percpu transforms */
>  	if (zswap_comp_pcpu_tfms)
> @@ -206,7 +206,7 @@ static struct zswap_tree *zswap_trees[MAX_SWAPFILES];
>  **********************************/
>  static struct kmem_cache *zswap_entry_cache;
>  
> -static int zswap_entry_cache_create(void)
> +static int __init zswap_entry_cache_create(void)
>  {
>  	zswap_entry_cache = KMEM_CACHE(zswap_entry, 0);
>  	return zswap_entry_cache == NULL;
> @@ -389,7 +389,7 @@ static struct notifier_block zswap_cpu_notifier_block = {
>  	.notifier_call = zswap_cpu_notifier
>  };
>  
> -static int zswap_cpu_init(void)
> +static int __init zswap_cpu_init(void)
>  {
>  	unsigned long cpu;
>  
> -- 
> 1.7.9.5
> 
