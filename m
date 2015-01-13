Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838AbbAMO1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 09:27:09 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:41591 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143AbbAMO1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 09:27:07 -0500
Message-ID: <54B52B39.1000607@linaro.org>
Date: Tue, 13 Jan 2015 15:27:05 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Yanchang Li <yl22@csr.com>, Barry Song <Baohua.Song@csr.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] clocksource: sirf: remove unused variable
References: <1599190.ZYSE4SrQSK@wuerfel>
In-Reply-To: <1599190.ZYSE4SrQSK@wuerfel>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2015 03:22 PM, Arnd Bergmann wrote:
> A recent rework of the driver left an obviously unused variable
> around, and now the compiler complains:
>
> clocksource/timer-marco.c: In function 'sirfsoc_marco_timer_init':
> clocksource/timer-marco.c:260:6: warning: unused variable 'timer_div' [-Wunused-variable]
>
> Remove it.

Hi Arnd,

thanks for the fix. But this has been already fixed and merged in my 
tree [1].

   -- Daniel

[1] 
https://git.linaro.org/people/daniel.lezcano/linux.git/commitdiff/2a016d694f36fc31f7f9fede902346c5895702bb?hp=89de77a8c557f14d2713a1f43fbc33980e639b98

> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: ef89af1f4380b92 ("clocksource: sirf: Remove hard-coded clock rate")
>
> diff --git a/drivers/clocksource/timer-marco.c b/drivers/clocksource/timer-marco.c
> index 361a789d4bee..3ddb81f7ee66 100644
> --- a/drivers/clocksource/timer-marco.c
> +++ b/drivers/clocksource/timer-marco.c
> @@ -257,7 +257,6 @@ static void __init sirfsoc_clockevent_init(void)
>   /* initialize the kernel jiffy timer source */
>   static void __init sirfsoc_marco_timer_init(struct device_node *np)
>   {
> -	u32 timer_div;
>   	struct clk *clk;
>
>   	clk = of_clk_get(np, 0);
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

