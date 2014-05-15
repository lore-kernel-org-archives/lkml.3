Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673AbaEOThL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 15:37:11 -0400
Received: from emvm-gh1-uea08.nsa.gov ([63.239.67.9]:60479 "EHLO
	emvm-gh1-uea08.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604AbaEOThJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 15:37:09 -0400
X-TM-IMSS-Message-ID: <7d68c8730015f359@nsa.gov>
Message-ID: <5375130B.8010303@tycho.nsa.gov>
Date: Thu, 15 May 2014 15:18:35 -0400
From: Stephen Smalley <sds@tycho.nsa.gov>
Organization: National Security Agency
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        pmoore@redhat.com, eparis@redhat.com
Subject: Re: [2/2] conditionally reschedule in hashtab_insert while loading
 selinux policy.
References: <20140515190353.GB16816@redhat.com>
In-Reply-To: <20140515190353.GB16816@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2014 03:03 PM, Dave Jones wrote:
> After silencing the sleeping warning in mls_convert_context() I started
> seeing similar traces from hashtab_insert. Do a cond_resched there too.
> 
> Signed-off-by: Dave Jones <davej@redhat.com>

Acked-by:  Stephen Smalley <sds@tycho.nsa.gov>

> 
> diff --git a/security/selinux/ss/hashtab.c b/security/selinux/ss/hashtab.c
> index 933e735bb185..2cc496149842 100644
> --- a/security/selinux/ss/hashtab.c
> +++ b/security/selinux/ss/hashtab.c
> @@ -6,6 +6,7 @@
>  #include <linux/kernel.h>
>  #include <linux/slab.h>
>  #include <linux/errno.h>
> +#include <linux/sched.h>
>  #include "hashtab.h"
>  
>  struct hashtab *hashtab_create(u32 (*hash_value)(struct hashtab *h, const void *key),
> @@ -40,6 +41,8 @@ int hashtab_insert(struct hashtab *h, void *key, void *datum)
>  	u32 hvalue;
>  	struct hashtab_node *prev, *cur, *newnode;
>  
> +	cond_resched();
> +
>  	if (!h || h->nel == HASHTAB_MAX_NODES)
>  		return -EINVAL;
>  
> 

