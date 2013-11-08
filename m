Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098Ab3KHKKz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 05:10:55 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:50225 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757062Ab3KHKKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 05:10:50 -0500
Message-ID: <527CB8A7.5080502@linaro.org>
Date: Fri, 08 Nov 2013 11:10:47 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-arm-kernel@lists.infradead.org
CC: linux-sh@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] clocksource: sh_tmu: Add clk_prepare/unprepare
 support
References: <1383000569-8916-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1383057097-22689-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1383057097-22689-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1383057097-22689-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2013 03:31 PM, Laurent Pinchart wrote:
> Prepare the clock at probe time, as there is no other appropriate place
> in the driver where we're allowed to sleep.
>
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Applied in my tree as 3.13 fixes

Thanks Laurent.

   -- Daniel

> ---
>   drivers/clocksource/sh_tmu.c | 9 ++++++++-
>   1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/clocksource/sh_tmu.c b/drivers/clocksource/sh_tmu.c
> index 1597837..63557cd 100644
> --- a/drivers/clocksource/sh_tmu.c
> +++ b/drivers/clocksource/sh_tmu.c
> @@ -472,6 +472,11 @@ static int sh_tmu_setup(struct sh_tmu_priv *p, struct platform_device *pdev)
>   		ret = PTR_ERR(p->clk);
>   		goto err1;
>   	}
> +
> +	ret = clk_prepare(p->clk);
> +	if (ret < 0)
> +		goto err2;
> +
>   	p->cs_enabled = false;
>   	p->enable_count = 0;
>
> @@ -479,10 +484,12 @@ static int sh_tmu_setup(struct sh_tmu_priv *p, struct platform_device *pdev)
>   			      cfg->clockevent_rating,
>   			      cfg->clocksource_rating);
>   	if (ret < 0)
> -		goto err2;
> +		goto err3;
>
>   	return 0;
>
> + err3:
> +	clk_unprepare(p->clk);
>    err2:
>   	clk_put(p->clk);
>    err1:
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

