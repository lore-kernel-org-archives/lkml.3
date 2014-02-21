Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbaBUIkk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 03:40:40 -0500
Received: from top.free-electrons.com ([176.31.233.9]:35261 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753603AbaBUIkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 03:40:39 -0500
Message-ID: <530710F4.6060804@free-electrons.com>
Date: Fri, 21 Feb 2014 09:40:20 +0100
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: John de la Garza <john@jjdev.com>
CC: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: removed compiler warning
References: <20140217043834.GA7563@vega.jjdev.com>
In-Reply-To: <20140217043834.GA7563@vega.jjdev.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/02/2014 05:38, John de la Garza wrote:
> Removed this compiler warning for arch/arm/boot/compressed/atags_to_fdt.c.
> The warning was: 'memsize' may be used uninitialized in this function.
> 

Indeed it was an error, thanks to have fixed it.

> Signed-off-by: John de la Garza <john@jjdev.com>

Acked-by: Gregory CLEMENT <gregory.clement@free-electrons.com>

> ---
>  arch/arm/boot/compressed/atags_to_fdt.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/compressed/atags_to_fdt.c b/arch/arm/boot/compressed/atags_to_fdt.c
> index d1153c8..75b64da 100644
> --- a/arch/arm/boot/compressed/atags_to_fdt.c
> +++ b/arch/arm/boot/compressed/atags_to_fdt.c
> @@ -110,7 +110,8 @@ int atags_to_fdt(void *atag_list, void *fdt, int total_space)
>  	 * address and size for each bank */
>  	uint32_t mem_reg_property[2 * 2 * NR_BANKS];
>  	int memcount = 0;
> -	int ret, memsize;
> +	int memsize = 0;
> +	int ret;
>  
>  	/* make sure we've got an aligned pointer */
>  	if ((u32)atag_list & 0x3)
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
