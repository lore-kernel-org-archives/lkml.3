Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611AbbAZM5e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 07:57:34 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:44246 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755536AbbAZM52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 07:57:28 -0500
Message-ID: <54C639B5.7050106@cogentembedded.com>
Date: Mon, 26 Jan 2015 15:57:25 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Wenyou Yang <wenyou.yang@atmel.com>, nicolas.ferre@atmel.com,
        linux@arm.linux.org.uk
CC: sylvain.rochet@finsecur.com, linux-kernel@vger.kernel.org,
        alexandre.belloni@free-electrons.com, peda@axentia.se,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 04/12] pm: at91: move the copying the sram function
 to the sram initializationi phase
References: <1422265005-22937-1-git-send-email-wenyou.yang@atmel.com> <1422265201-23110-1-git-send-email-wenyou.yang@atmel.com>
In-Reply-To: <1422265201-23110-1-git-send-email-wenyou.yang@atmel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 1/26/2015 12:40 PM, Wenyou Yang wrote:

> To decrease the suspend time, move the copying the sram function
> to the sram initialization phase, instead of every time go to suspend.

> Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
> Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>   arch/arm/mach-at91/pm.c |    7 +++----
>   1 file changed, 3 insertions(+), 4 deletions(-)

> diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
> index 5dd4e41..409185e 100644
> --- a/arch/arm/mach-at91/pm.c
> +++ b/arch/arm/mach-at91/pm.c
> @@ -161,10 +161,6 @@ static int at91_pm_enter(suspend_state_t state)
>   			 * turning off the main oscillator; reverse on wakeup.
>   			 */
>   			if (slow_clock) {
> -#ifdef CONFIG_AT91_SLOW_CLOCK
> -				/* copy slow_clock handler to SRAM, and call it */
> -				memcpy(slow_clock, at91_slow_clock, at91_slow_clock_sz);
> -#endif
>   				slow_clock(at91_pmc_base, at91_ramc_base[0],
>   					   at91_ramc_base[1],
>   					   at91_pm_data.memctrl);
> @@ -272,6 +268,9 @@ static void __init at91_pm_sram_init(void)
>   	sram_pbase = gen_pool_virt_to_phys(sram_pool, sram_base);
>   	slow_clock = __arm_ioremap_exec(sram_pbase, at91_slow_clock_sz, false);
>
> +	/* Copy slow_clock handler to SRAM, and call it */

    You're not calling it here.

> +	memcpy(slow_clock, at91_slow_clock, at91_slow_clock_sz);
> +
>   put_node:
>   	of_node_put(node);
>   }

WBR, Sergei

