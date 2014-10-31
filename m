Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933158AbaJaOKW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 10:10:22 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:20667 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932536AbaJaOKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 10:10:20 -0400
Date: Fri, 31 Oct 2014 10:10:13 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Li Haifeng <omycle@gmail.com>, akpm@linux-foundation.org
Cc: open list <linux-kernel@vger.kernel.org>,
        "open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>
Subject: Re: [PATCH] Frontswap: fix the condition in BUG_ON
Message-ID: <20141031141013.GH4704@laptop.dumpdata.com>
References: <CAFNq8R7xYA2GTpWE-5rHr5c-xX0ZONKHX6wSbra2MDo1M2DSHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFNq8R7xYA2GTpWE-5rHr5c-xX0ZONKHX6wSbra2MDo1M2DSHQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 06:14:19PM +0800, Li Haifeng wrote:
> >From 012a564c7210346b99d12e3d2485542bb090586e Mon Sep 17 00:00:00 2001
> From: Haifeng Li <omycle@gmail.com>
> Date: Fri, 31 Oct 2014 17:40:44 +0800
> Subject: [PATCH] Frontswap: fix the condition in BUG_ON
> 
> The largest index of swap device is MAX_SWAPFILES-1. So the type
> should be less than MAX_SWAPFILES.

Ok, so we would never hit this BUG_ON because of that.

Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

P.S.
Andrew - are you OK picking this up?

Thank you!
> 
> Signed-off-by: Haifeng Li <omycle@gmail.com>
> ---
>  mm/frontswap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/frontswap.c b/mm/frontswap.c
> index c30eec5..1b80c05 100644
> --- a/mm/frontswap.c
> +++ b/mm/frontswap.c
> @@ -182,7 +182,7 @@ void __frontswap_init(unsigned type, unsigned long *map)
>         if (frontswap_ops)
>                 frontswap_ops->init(type);
>         else {
> -               BUG_ON(type > MAX_SWAPFILES);
> +               BUG_ON(type >= MAX_SWAPFILES);
>                 set_bit(type, need_init);
>         }
>  }
> -- 
> 1.9.1
