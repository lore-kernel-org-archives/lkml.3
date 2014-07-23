Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933799AbaGWWYf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 18:24:35 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933386AbaGWWYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 18:24:34 -0400
Message-ID: <53D0361B.8060003@nod.at>
Date: Thu, 24 Jul 2014 00:24:27 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Himangi Saraogi <himangi774@gmail.com>, Jeff Dike <jdike@addtoit.com>,
        user-mode-linux-devel@lists.sourceforge.net,
        user-mode-linux-user@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
CC: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH] uml/net_kern: Eliminate NULL test after alloc_bootmem
References: <20140719113405.GA23568@himangi-Dell>
In-Reply-To: <20140719113405.GA23568@himangi-Dell>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Himangi,

Am 19.07.2014 13:34, schrieb Himangi Saraogi:
> alloc_bootmem and related functions never return NULL. Thus a NULL
> test or memset after calls to these functions is unnecessary.
> 
> The following Coccinelle semantic patch was used for making the change:
> 
> @@
> expression E;
> statement S;
> @@
> 
> E = \(alloc_bootmem\|alloc_bootmem_low\|alloc_bootmem_pages\|alloc_bootmem_low_pages\)(...)
> ... when != E
> - if (E == NULL) S
> 
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>

Thank you! All three patches are now queued for 3.17.

Thanks,
//richard

> ---
>  arch/um/drivers/net_kern.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/arch/um/drivers/net_kern.c b/arch/um/drivers/net_kern.c
> index 7d26d9c..f70dd54 100644
> --- a/arch/um/drivers/net_kern.c
> +++ b/arch/um/drivers/net_kern.c
> @@ -659,10 +659,6 @@ static int __init eth_setup(char *str)
>  	}
>  
>  	new = alloc_bootmem(sizeof(*new));
> -	if (new == NULL) {
> -		printk(KERN_ERR "eth_init : alloc_bootmem failed\n");
> -		return 1;
> -	}
>  
>  	INIT_LIST_HEAD(&new->list);
>  	new->index = n;
> 
