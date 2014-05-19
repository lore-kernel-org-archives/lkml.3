Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbaESKsN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 06:48:13 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:55577 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbaESKsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 06:48:12 -0400
Message-ID: <5379E177.2030707@linaro.org>
Date: Mon, 19 May 2014 12:48:23 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
CC: "'Thomas Gleixner'" <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "'Shinya Kuribayashi'" <shinya.kuribayashi.px@renesas.com>,
        "'Magnus Damm'" <damm@opensource.se>
Subject: Re: [PATCH 1/4] clocksource: em_sti: remove unnecessary OOM messages
References: <002c01cf6384$781c57b0$68550710$%han@samsung.com> <002d01cf6384$a6dbcf90$f4936eb0$%han@samsung.com>
In-Reply-To: <002d01cf6384$a6dbcf90$f4936eb0$%han@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2014 10:26 AM, Jingoo Han wrote:
> The site-specific OOM messages are unnecessary, because they
> duplicate the MM subsystem generic OOM message.

Are you sure the MM subsys display a message when an allocation fails ?

There are multiple reasons an allocation can fail.

> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>   drivers/clocksource/em_sti.c |    4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/drivers/clocksource/em_sti.c b/drivers/clocksource/em_sti.c
> index 9d17083..d0a7bd6 100644
> --- a/drivers/clocksource/em_sti.c
> +++ b/drivers/clocksource/em_sti.c
> @@ -318,10 +318,8 @@ static int em_sti_probe(struct platform_device *pdev)
>   	int irq;
>
>   	p = devm_kzalloc(&pdev->dev, sizeof(*p), GFP_KERNEL);
> -	if (p == NULL) {
> -		dev_err(&pdev->dev, "failed to allocate driver data\n");
> +	if (p == NULL)
>   		return -ENOMEM;
> -	}
>
>   	p->pdev = pdev;
>   	platform_set_drvdata(pdev, p);
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

