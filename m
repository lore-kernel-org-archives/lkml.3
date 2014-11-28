Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751300AbaK1HPq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 02:15:46 -0500
Received: from mail-qg0-f46.google.com ([209.85.192.46]:36814 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbaK1HPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 02:15:45 -0500
Date: Fri, 28 Nov 2014 02:15:41 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Masahiro Yamada <yamada.m@jp.panasonic.com>
cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@linaro.org>, Will Deacon <will.deacon@arm.com>,
        Heiko Stuebner <heiko@sntech.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: decompressor: fix a wrong comment
In-Reply-To: <1417155134-29808-1-git-send-email-yamada.m@jp.panasonic.com>
Message-ID: <alpine.LFD.2.11.1411280215050.11690@knanqh.ubzr>
References: <1417155134-29808-1-git-send-email-yamada.m@jp.panasonic.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Nov 2014, Masahiro Yamada wrote:

> This comment does not correspond to the actual code.
> 
> When zImage is loaded at a lower *OR* higher address of
> the destination of Image, it won't overwrite itself.
> 
> Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>

Acked-by: Nicolas Pitre <nico@linaro.org>


> ---
> 
>  arch/arm/boot/compressed/head.S | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
> index 68be901..9dff614 100644
> --- a/arch/arm/boot/compressed/head.S
> +++ b/arch/arm/boot/compressed/head.S
> @@ -178,7 +178,7 @@ not_angel:
>  
>  		/*
>  		 * Set up a page table only if it won't overwrite ourself.
> -		 * That means r4 < pc && r4 - 16k page directory > &_end.
> +		 * That means r4 < pc || r4 - 16k page directory > &_end.
>  		 * Given that r4 > &_end is most unfrequent, we add a rough
>  		 * additional 1MB of room for a possible appended DTB.
>  		 */
> -- 
> 1.9.1
> 
> 
