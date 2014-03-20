Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759267AbaCTQeQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 12:34:16 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:45673 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757428AbaCTQeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 12:34:13 -0400
Message-ID: <532B1881.2050409@gmail.com>
Date: Thu, 20 Mar 2014 17:34:09 +0100
From: Boris BREZILLON <b.brezillon.dev@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: at91: panic when the mck rate is zero
References: <1395332062-4967-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1395332062-4967-1-git-send-email-alexandre.belloni@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 20/03/2014 17:14, Alexandre Belloni a écrit :
> If the mck rate is zero, we'll hit the following warning:
>
> WARNING: CPU: 0 PID: 0 at arch/arm/mach-at91/at91sam926x_time.c:257 at91sam926x_pit_init+0x13c/0x260()
>
> But the kernel will continue to try booting and face a lot of divisions by zero
> when trying to handle the various clocks.
>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>   arch/arm/mach-at91/at91sam926x_time.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/arch/arm/mach-at91/at91sam926x_time.c b/arch/arm/mach-at91/at91sam926x_time.c
> index 0f04ffe9c5a8..f060f6371392 100644
> --- a/arch/arm/mach-at91/at91sam926x_time.c
> +++ b/arch/arm/mach-at91/at91sam926x_time.c
> @@ -250,6 +250,8 @@ void __init at91sam926x_pit_init(void)
>   	if (IS_ERR(mck))
>   		panic("AT91: PIT: Unable to get mck clk\n");
>   	pit_rate = clk_get_rate(mck) / 16;
> +	if (pit_rate == 0)
> +		panic("AT91: PIT: can't continue, mck rate is zero\n");
You're testing pit_rate why not printing:

"AT91: PIT: can't continue, *pit* rate is zero\n"


Otherwise,

Acked-by: Boris BREZILLON <b.brezillon.dev@gmail.com>
>   	pit_cycle = (pit_rate + HZ/2) / HZ;
>   	WARN_ON(((pit_cycle - 1) & ~AT91_PIT_PIV) != 0);
>   

