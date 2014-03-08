Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbaCHEAS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 23:00:18 -0500
Received: from smtprelay0213.hostedemail.com ([216.40.44.213]:41634 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751296AbaCHEAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 23:00:17 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3871:3873:4321:5007:6119:7652:8603:10004:10400:10848:11026:11658:11914:12043:12438:12517:12519:12740:13069:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: pigs56_1f68d8d483327
X-Filterd-Recvd-Size: 2182
Message-ID: <1394251214.6972.20.camel@joe-AO722>
Subject: Re: [PATCH 2/2] mm: Changed pr_warning() to pr_warn()
From: Joe Perches <joe@perches.com>
To: Choi Gi-yong <yong@gnoy.org>
Cc: tj@kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 07 Mar 2014 20:00:14 -0800
In-Reply-To: <1394250681-5258-1-git-send-email-yong@gnoy.org>
References: <1394250681-5258-1-git-send-email-yong@gnoy.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-03-08 at 12:51 +0900, Choi Gi-yong wrote:

> diff --git a/mm/percpu.c b/mm/percpu.c
[]
> @@ -813,7 +813,7 @@ fail_unlock:
>  fail_unlock_mutex:
>  	mutex_unlock(&pcpu_alloc_mutex);
>  	if (warn_limit) {
> -		pr_warning("PERCPU: allocation failed, size=%zu align=%zu, "
> +		pr_warn("PERCPU: allocation failed, size=%zu align=%zu, "
>  			   "%s\n", size, align, err);

If you're going do to this, please coalesce
the format fragments.

		pr_warn("PERCPU: allocation failed, size=%zu align=%zu, %s\n",
			size, align, err);

> @@ -1690,7 +1690,7 @@ int __init pcpu_embed_first_chunk(size_t reserved_size, size_t dyn_size,
>  
>  	/* warn if maximum distance is further than 75% of vmalloc space */
>  	if (max_distance > VMALLOC_TOTAL * 3 / 4) {
> -		pr_warning("PERCPU: max_distance=0x%zx too large for vmalloc "
> +		pr_warn("PERCPU: max_distance=0x%zx too large for vmalloc "
>  			   "space 0x%lx\n", max_distance,
>  			   VMALLOC_TOTAL);

here too

		pr_warn("PERCPU: max_distance=0x%zx too large for vmalloc space 0x%lx\n",
			max_distance, VMALLOC_TOTAL);

> @@ -1774,7 +1774,7 @@ int __init pcpu_page_first_chunk(size_t reserved_size,
>  
>  			ptr = alloc_fn(cpu, PAGE_SIZE, PAGE_SIZE);
>  			if (!ptr) {
> -				pr_warning("PERCPU: failed to allocate %s page "
> +				pr_warn("PERCPU: failed to allocate %s page "
>  					   "for cpu%u\n", psize_str, cpu);

etc.


