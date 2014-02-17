Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120AbaBQJxW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 04:53:22 -0500
Received: from cassarossa.samfundet.no ([193.35.52.29]:34912 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973AbaBQJxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 04:53:19 -0500
Date: Mon, 17 Feb 2014 10:53:14 +0100
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: =?iso-8859-1?Q?H=E5vard?= Skinnemoen <hskinnemoen@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, havard@skinnemoen.net,
        josh.wu@atmel.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch: avr32: include: asm: add generic ioremap_wc()
 definition in "io.h"
Message-ID: <20140217095314.GC20665@samfundet.no>
References: <5300A372.1050501@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5300A372.1050501@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Sun 16 Feb 2014 19:39:30 +0800 or thereabout, Chen Gang wrote:
> Need generic ioremap_wc(), or can not pass compiling with allmodconfig,
> the related error:
> 
>     CC [M]  drivers/gpu/drm/drm_bufs.o
>   drivers/gpu/drm/drm_bufs.c: In function 'drm_addmap_core':
>   drivers/gpu/drm/drm_bufs.c:217: error: implicit declaration of function 'ioremap_wc'
>   drivers/gpu/drm/drm_bufs.c:218: warning: assignment makes pointer from integer without a cast

I guess this patch needs to go in before pulling in vga.h.

> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>

> ---
>  arch/avr32/include/asm/io.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/avr32/include/asm/io.h b/arch/avr32/include/asm/io.h
> index fc6483f..4f5ec2b 100644
> --- a/arch/avr32/include/asm/io.h
> +++ b/arch/avr32/include/asm/io.h
> @@ -295,6 +295,8 @@ extern void __iounmap(void __iomem *addr);
>  #define iounmap(addr)				\
>  	__iounmap(addr)
>  
> +#define ioremap_wc ioremap_nocache
> +
>  #define cached(addr) P1SEGADDR(addr)
>  #define uncached(addr) P2SEGADDR(addr)
>  
-- 
mvh
Hans-Christian Egtvedt
