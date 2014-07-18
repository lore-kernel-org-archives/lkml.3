Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761362AbaGRJpj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 05:45:39 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:43762 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761296AbaGRJph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 05:45:37 -0400
Message-ID: <53C8ECBD.5080700@imgtec.com>
Date: Fri, 18 Jul 2014 10:45:33 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andrey Utkin <andrey.krieger.utkin@gmail.com>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        <linux-metag@vger.kernel.org>
CC: <dan.carpenter@oracle.com>
Subject: Re: [PATCH] arch/metag/kernel/cachepart.c: fix failure check
References: <20140717145811.GI25880@mwanda> <1405612686-3554-1-git-send-email-andrey.krieger.utkin@gmail.com>
In-Reply-To: <1405612686-3554-1-git-send-email-andrey.krieger.utkin@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.101]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/07/14 16:58, Andrey Utkin wrote:
> [linux-3.16-rc5/arch/metag/kernel/cachepart.c:102]: (style) Checking if
> unsigned variable 'thread_cache_size' is less than zero.
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
> Changed get_thread_cache_size() to return signed int, and its result is stored
> into signed int variable.
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=80361
> Reported-by: David Binderman <dcb314@hotmail.com>
> Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>

Thanks, applied!

Cheers
James

> ---
>  arch/metag/kernel/cachepart.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/metag/kernel/cachepart.c b/arch/metag/kernel/cachepart.c
> index 0a2385f..04b7d4f 100644
> --- a/arch/metag/kernel/cachepart.c
> +++ b/arch/metag/kernel/cachepart.c
> @@ -55,7 +55,7 @@ unsigned int get_global_icache_size(void)
>  	return (get_icache_size() * ((temp >> SYSC_xCPARTG_AND_S) + 1)) >> 4;
>  }
>  
> -static unsigned int get_thread_cache_size(unsigned int cache, int thread_id)
> +static int get_thread_cache_size(unsigned int cache, int thread_id)
>  {
>  	unsigned int cache_size;
>  	unsigned int t_cache_part;
> @@ -94,7 +94,7 @@ static unsigned int get_thread_cache_size(unsigned int cache, int thread_id)
>  
>  void check_for_cache_aliasing(int thread_id)
>  {
> -	unsigned int thread_cache_size;
> +	int thread_cache_size;
>  	unsigned int cache_type;
>  	for (cache_type = ICACHE; cache_type <= DCACHE; cache_type++) {
>  		thread_cache_size =
> 
