Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090AbaAMSDE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 13:03:04 -0500
Received: from mail-qe0-f45.google.com ([209.85.128.45]:48062 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499AbaAMSDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 13:03:02 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:4c75:e659:d4b7:8090]
In-Reply-To: <20140113010025.GA14431@amd.pavel.ucw.cz>
References: <20140113010025.GA14431@amd.pavel.ucw.cz>
Date: Mon, 13 Jan 2014 10:02:58 -0800
Message-ID: <CAOesGMjG37FprRX7U-+S3nFCuv=RVAOUv7wb8K-Tcqr26ETevw@mail.gmail.com>
Subject: Re: [patch] fix omap compile with randconfig
From: Olof Johansson <olof@lixom.net>
To: Pavel Machek <pavel@ucw.cz>
Cc: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 12, 2014 at 5:00 PM, Pavel Machek <pavel@ucw.cz> wrote:
>
> This fixes:
>
> arch/arm/mach-omap2/built-in.o: In function `omap_reserve':
> /data/l/linux-n900/arch/arm/mach-omap2/common.c:36: undefined
>   reference to `omap_fb_reserve_memblock'
>
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
>
> diff --git a/arch/arm/mach-omap2/common.c b/arch/arm/mach-omap2/common.c
> index 9beecde..857907f 100644
> --- a/arch/arm/mach-omap2/common.c
> +++ b/arch/arm/mach-omap2/common.c
> @@ -33,5 +33,7 @@ void __init omap_reserve(void)
>         omap_dsp_reserve_sdram_memblock();
>         omap_secure_ram_reserve_memblock();
>         omap_barrier_reserve_memblock();
> +#ifdef CONFIG_OMAP2_VRFB
>         omap_fb_reserve_memblock();
> +#endif
>  }

What is this patch against? omap_fb_reserve_memblock() doesn't exist
in v3.13-rc8, nor in -next.

Adding an ifdef here is likely the wrong thing anyway, there should be
a stub provided for !CONFIG_OMAP2_VRFB in the header file instead.


-Olof
