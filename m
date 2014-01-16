Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406AbaAPJhZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 04:37:25 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:37652 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbaAPJhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 04:37:20 -0500
Message-ID: <52D7A84E.3090300@linaro.org>
Date: Thu, 16 Jan 2014 10:37:18 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Wei Yongjun <weiyj.lk@gmail.com>, tglx@linutronix.de
CC: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] clocksource: keystone: Fix return value check in
 keystone_timer_init()
References: <CAPgLHd-XC6xeUxQJBNe=grLvZUxSc_bcrEVo=Tc1jbyGmHjdgw@mail.gmail.com>
In-Reply-To: <CAPgLHd-XC6xeUxQJBNe=grLvZUxSc_bcrEVo=Tc1jbyGmHjdgw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2014 09:29 AM, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> In case of error, function of_clk_get() returns ERR_PTR()
> and never returns NULL. The NULL test in the return value
> check should be replaced with IS_ERR().
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>   drivers/clocksource/timer-keystone.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/clocksource/timer-keystone.c b/drivers/clocksource/timer-keystone.c
> index cbac8d0..4ca05ec 100644
> --- a/drivers/clocksource/timer-keystone.c
> +++ b/drivers/clocksource/timer-keystone.c
> @@ -168,7 +168,7 @@ static void __init keystone_timer_init(struct device_node *np)
>   	}
>
>   	clk = of_clk_get(np, 0);
> -	if (!clk) {
> +	if (IS_ERR(clk)) {
>   		pr_err("%s: failed to get clock\n", __func__);
>   		iounmap(timer.base);
>   		return;

Good catch. Applied for 3.15.

Thanks for the fix.

   -- Daniel





-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

