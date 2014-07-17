Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933607AbaGQO6P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 10:58:15 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:17234 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932139AbaGQO6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 10:58:13 -0400
Date: Thu, 17 Jul 2014 17:58:11 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andrey Utkin <andrey.krieger.utkin@gmail.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-metag@vger.kernel.org, james.hogan@imgtec.com
Subject: Re: [PATCH 1/3] arch/metag/kernel/cachepart.c: fix failure check
Message-ID: <20140717145811.GI25880@mwanda>
References: <1405603586-12515-1-git-send-email-andrey.krieger.utkin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405603586-12515-1-git-send-email-andrey.krieger.utkin@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 04:26:26PM +0300, Andrey Utkin wrote:
> [linux-3.16-rc5/arch/metag/kernel/cachepart.c:102]: (style) Checking if unsigned variable 'thread_cache_size' is less than zero.
> 
> Source code is
> 
>         if (thread_cache_size < 0)
>             pr_emerg("Can't read %s cache size\n",
>                  cache_type ? "DCACHE" : "ICACHE");
> 
> but
> 
>     unsigned int thread_cache_size;
> 
> Function get_thread_cache_size returns an error code
> as (unsigned int) -1.
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=80361
> Reported-by: David Binderman <dcb314@hotmail.com>
> Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>
> ---
>  arch/metag/kernel/cachepart.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/metag/kernel/cachepart.c b/arch/metag/kernel/cachepart.c
> index 0a2385f..b137034 100644
> --- a/arch/metag/kernel/cachepart.c
> +++ b/arch/metag/kernel/cachepart.c
> @@ -99,7 +99,7 @@ void check_for_cache_aliasing(int thread_id)
>  	for (cache_type = ICACHE; cache_type <= DCACHE; cache_type++) {
>  		thread_cache_size =
>  				get_thread_cache_size(cache_type, thread_id);
> -		if (thread_cache_size < 0)
> +		if (thread_cache_size == (unsigned int)-1)

Oh, wow.  Every single variable in this file is an unsigned int.  :P

We should just make this int.  The values of thread_cache_size do not
go that high.

regards,
dan carpenter

