Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758167Ab3E0NO3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 09:14:29 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:38169 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756122Ab3E0NO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 09:14:28 -0400
Message-ID: <51A35C2F.4000201@linaro.org>
Date: Mon, 27 May 2013 15:14:23 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Baruch Siach <baruch@tkos.co.il>
CC: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] clocksource: dw_apb: fix error check
References: <90d7cc35674bf04806531eb2e9836fdc382868d9.1369655478.git.baruch@tkos.co.il>
In-Reply-To: <90d7cc35674bf04806531eb2e9836fdc382868d9.1369655478.git.baruch@tkos.co.il>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2013 01:51 PM, Baruch Siach wrote:
> irq_of_parse_and_map() returns 0 on error, while the code checks for NO_IRQ.
> This breaks on platforms that have NO_IRQ != 0.
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> ---

Shouldn't the 'irq_of_parse_and_map' function to be fixed and return
NO_IRQ in case of error ? (even if some code checks the return value is
'zero' in case of error [1], while some other code checks NO_IRQ [2]).

[1]
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/arch/x86/kernel/devicetree.c#n124

[2]
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/arch/powerpc/sysdev/fsl_msi.c#n344


>  drivers/clocksource/dw_apb_timer_of.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/clocksource/dw_apb_timer_of.c b/drivers/clocksource/dw_apb_timer_of.c
> index 9fdb4d3..843d43b 100644
> --- a/drivers/clocksource/dw_apb_timer_of.c
> +++ b/drivers/clocksource/dw_apb_timer_of.c
> @@ -47,7 +47,7 @@ static void add_clockevent(struct device_node *event_timer)
>  	u32 irq, rate;
>  
>  	irq = irq_of_parse_and_map(event_timer, 0);
> -	if (irq == NO_IRQ)
> +	if (irq == 0)
>  		panic("No IRQ for clock event timer");
>  
>  	timer_get_base_and_rate(event_timer, &iobase, &rate);
> 


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

