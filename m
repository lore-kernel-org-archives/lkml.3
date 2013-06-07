Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331Ab3FGP4e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 11:56:34 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:43758 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756205Ab3FGP4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 11:56:32 -0400
Message-ID: <51B202A4.6090903@gmail.com>
Date: Fri, 07 Jun 2013 23:56:20 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch -mm] mm, vmalloc: unbreak __vunmap()
References: <20130607120738.GA13851@debian>
In-Reply-To: <20130607120738.GA13851@debian>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2013 08:07 PM, Dan Carpenter wrote:
> There is an extra semi-colon so the function always returns.

Acked-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

This is imported by using the macro PAGE_ALIGNED.

> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 91a1047..96b77a9 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -1453,7 +1453,7 @@ static void __vunmap(const void *addr, int deallocate_pages)
>  		return;
>  
>  	if (WARN(!PAGE_ALIGNED(addr), "Trying to vfree() bad address (%p)\n",
> -			addr));
> +			addr))
>  		return;
>  
>  	area = remove_vm_area(addr);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

