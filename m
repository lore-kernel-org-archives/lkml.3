Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757827Ab3FMNUF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 09:20:05 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:14642 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754770Ab3FMNUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 09:20:03 -0400
Message-ID: <51B9C6FE.7000302@atmel.com>
Date: Thu, 13 Jun 2013 15:19:58 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Wenyou Yang <wenyou.yang@atmel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux@maxim.org.za>,
        <plagnioj@jcrosoft.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Change the internal SRAM memory type MT_MEMORY_NONCACHED
References: <1369011911-21282-1-git-send-email-wenyou.yang@atmel.com> <1370657863-8725-1-git-send-email-wenyou.yang@atmel.com>
In-Reply-To: <1370657863-8725-1-git-send-email-wenyou.yang@atmel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2013 04:17, Wenyou Yang :
> Because MT_DEVICE is not executable in armv7, we change
> the internal SRAM memory type to MT_MEMORY_NONCACHED.
> As it seems that caching this internal SRAM memory is not necessary,
> we chose the this memory type.
>
> Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

But Russell, can we have your advice on this as you made us re-think 
about that during previous patch discussion?

Bye,

> ---
>   arch/arm/mach-at91/setup.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
> index a33d4b5..98d55ef 100644
> --- a/arch/arm/mach-at91/setup.c
> +++ b/arch/arm/mach-at91/setup.c
> @@ -84,7 +84,7 @@ void __init at91_init_sram(int bank, unsigned long base, unsigned int length)
>
>   	desc->pfn = __phys_to_pfn(base);
>   	desc->length = length;
> -	desc->type = MT_DEVICE;
> +	desc->type = MT_MEMORY_NONCACHED;
>
>   	pr_info("AT91: sram at 0x%lx of 0x%x mapped at 0x%lx\n",
>   		base, length, desc->virtual);
>


-- 
Nicolas Ferre
