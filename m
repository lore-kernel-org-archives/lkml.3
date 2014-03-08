Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082AbaCHDz7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 22:55:59 -0500
Received: from smtprelay0246.hostedemail.com ([216.40.44.246]:38727 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752966AbaCHDz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 22:55:57 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:960:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3872:3873:4321:4605:5007:6119:7652:8603:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12740:13019:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: end29_8b26a20dac81b
X-Filterd-Recvd-Size: 2173
Message-ID: <1394250953.6972.16.camel@joe-AO722>
Subject: Re: [PATCH] mm: Fix Coding style
From: Joe Perches <joe@perches.com>
To: Choi Gi-yong <yong@gnoy.org>
Cc: tj@kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 07 Mar 2014 19:55:53 -0800
In-Reply-To: <1394250361-5151-1-git-send-email-yong@gnoy.org>
References: <1394250361-5151-1-git-send-email-yong@gnoy.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-03-08 at 12:46 +0900, Choi Gi-yong wrote:
[]
> diff --git a/mm/percpu.c b/mm/percpu.c

Please run your suggested patches through checkpatch.

> @@ -715,7 +715,7 @@ static void __percpu *pcpu_alloc(size_t size, size_t align, bool reserved)
>  
>  	if (unlikely(!size || size > PCPU_MIN_UNIT_SIZE || align > PAGE_SIZE)) {
>  		WARN(true, "illegal size (%zu) or align (%zu) for "
> -		     "percpu allocation\n", size, align);
> +				"percpu allocation\n", size, align);

It'd be better to coalesce the format fragments

[]

> @@ -968,8 +968,8 @@ bool is_kernel_percpu_address(unsigned long addr)
>  		void *start = per_cpu_ptr(base, cpu);
>  
>  		if ((void *)addr >= start && (void *)addr < start + static_size)
> -			return true;
> -        }
> +		return true;
> +       }

Not an improvement.
Why do you think it's better?

> @@ -1929,8 +1929,7 @@ void __init setup_per_cpu_areas(void)
>   */
>  void __init percpu_init_late(void)
>  {
> -	struct pcpu_chunk *target_chunks[] =
> -		{ pcpu_first_chunk, pcpu_reserved_chunk, NULL };
> +	struct pcpu_chunk *target_chunks[] = { pcpu_first_chunk, pcpu_reserved_chunk, NULL };

This exceeds 80 columns.

This would be better as:

	struct pcpu_chunk *target_chunks[] = {
		pcpu_first_chunk, pcpu_reserved_chunk, NULL
	};

And perhaps this should be static const

>  	struct pcpu_chunk *chunk;
>  	unsigned long flags;
>  	int i;



