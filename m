Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019AbaCHVqp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 16:46:45 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:50358 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbaCHVqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 16:46:43 -0500
Message-ID: <531B8FD8.6040704@gmail.com>
Date: Sun, 09 Mar 2014 05:47:04 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: =?ISO-8859-1?Q?H=E5vard_Skinnemoen?= <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch/avr32/mm/cache.c: export symbol flush_icache_range()
 for module using
References: <531B8D32.6000000@gmail.com>
In-Reply-To: <531B8D32.6000000@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


After this patch, our linux kernel can pass "avr32-linux-" allmodconfig
(it contents quite a few of warnings, but after check, I guess they are
not kernel's issue).

:-)

Thanks.


On 03/09/2014 05:35 AM, Chen Gang wrote:
> Need export symbol flush_icache_range() to modules, just like another
> platforms have done, or can not pass compiling.
> 
> The related error (with allmodconfig under avr32):
> 
>   ERROR: "flush_icache_range" [drivers/misc/lkdtm.ko] undefined!
>   make[1]: *** [__modpost] Error 1
>   make: *** [modules] Error 2
> 
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  arch/avr32/mm/cache.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/avr32/mm/cache.c b/arch/avr32/mm/cache.c
> index 6a46ecd..85d635c 100644
> --- a/arch/avr32/mm/cache.c
> +++ b/arch/avr32/mm/cache.c
> @@ -111,6 +111,7 @@ void flush_icache_range(unsigned long start, unsigned long end)
>  	__flush_icache_range(start & ~(linesz - 1),
>  			     (end + linesz - 1) & ~(linesz - 1));
>  }
> +EXPORT_SYMBOL(flush_icache_range);
>  
>  /*
>   * This one is called from __do_fault() and do_swap_page().
> 


-- 
Chen Gang

Open, share and attitude like air, water and life which God blessed
