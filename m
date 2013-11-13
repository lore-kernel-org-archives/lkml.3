Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758837Ab3KMLrU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 06:47:20 -0500
Received: from service87.mimecast.com ([91.220.42.44]:49686 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978Ab3KMLrS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 06:47:18 -0500
Message-ID: <528366A9.7060504@arm.com>
Date: Wed, 13 Nov 2013 11:46:49 +0000
From: Jonathan Austin <jonathan.austin@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Ming Lei <tom.leiming@gmail.com>
CC: Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 1/2] ARM: default PHYS_OFFSET if !MMU
References: <1384341351-4110-1-git-send-email-tom.leiming@gmail.com> <1384341351-4110-2-git-send-email-tom.leiming@gmail.com>
In-Reply-To: <1384341351-4110-2-git-send-email-tom.leiming@gmail.com>
X-OriginalArrivalTime: 13 Nov 2013 11:47:14.0369 (UTC) FILETIME=[188FDB10:01CEE066]
X-MC-Unique: 113111311471601101
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ming,

On 13/11/13 11:15, Ming Lei wrote:
> From: Jonathan Austin <jonathan.austin@arm.com>
> 
> Set CONFIG_PAGE_OFFSET as PHYS_OFFSET when !MMU so that
> we can keep CONFIG_PAGE_OFFSET same with PAGE_OFFSET.
>

I'm not so sure about this commit message - I don't think
it makes sense...Should it not be more like:

------->8-------
Subject: ARM: set PAGE_OFFSET = PHYS_OFFSET if !MMU

With !MMU we still set PAGE_OFFSET to 0xC0000000, which
makes little sense and causes a regression on !MMU after
f6537f2f0eba4eba ("scripts/kallsyms: filter symbols not
kernel address space")

This patch sets PAGE_OFFSET to PHYS_OFFSET in the !MMU
case, fixing the regression (Tested on Cortex-R7/Vexpress)
--------8<---------

Russell: Will you pick this patch up from the list or does
it need to go in through the patch system?

Jonny

> This patch and patch 2/2 fix regression on !MMU by
> f6537f2f0eba4eba("scripts/kallsyms: filter symbols not
> in kernel address space")
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Jonathan Austin <jonathan.austin@arm.com>
> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> ---
>   arch/arm/Kconfig |    1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 799ef94..db708c4 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -1560,6 +1560,7 @@ endchoice
>   
>   config PAGE_OFFSET
>   	hex
> +	default PHYS_OFFSET if !MMU
>   	default 0x40000000 if VMSPLIT_1G
>   	default 0x80000000 if VMSPLIT_2G
>   	default 0xC0000000
> 


