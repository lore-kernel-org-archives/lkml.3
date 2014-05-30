Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929AbaE3M6L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 08:58:11 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:52796 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbaE3M6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 08:58:09 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-c8-5388805d068d
Message-id: <5388805C.80200@samsung.com>
Date: Fri, 30 May 2014 14:58:04 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, kishon@ti.com
Subject: Re: [PATCH 2/3] phy: exynos-mipi-video: Use PTR_ERR_OR_ZERO
References: <1401345049-14779-1-git-send-email-sachin.kamat@linaro.org>
 <1401345049-14779-2-git-send-email-sachin.kamat@linaro.org>
In-reply-to: <1401345049-14779-2-git-send-email-sachin.kamat@linaro.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPLMWRmVeSWpSXmKPExsVy+t/xq7qxDR3BBgvWsVtceNrDZnF51xw2
	i5N/ehkdmD3uXNvD5nH8xnYmj8+b5AKYo7hsUlJzMstSi/TtErgyHr8RKjjBVdFx/DxTA+Nt
	ji5GTg4JAROJ0/OXMkPYYhIX7q1n62Lk4hASWMooce7dJijnE6PE3ce9jCBVvAIaEs+XfQCz
	WQRUJa7vXQ5mswkYSvQe7QOyOThEBSIkHl8QgigXlPgx+R4LiC0ioCXxsns5E4jNLKAv0TPz
	KFirsICLxKdOkDjIrlZGiTk77oM1cAp4SPw885ANokFHYn/rNChbXmLzmrfMExgFZiHZMQtJ
	2SwkZQsYmVcxiqaWJhcUJ6XnGukVJ+YWl+al6yXn525ihATq1x2MS49ZHWIU4GBU4uHNcGkP
	FmJNLCuuzD3EKMHBrCTCm1bYESzEm5JYWZValB9fVJqTWnyIkYmDU6qBUXQj1/v9lg9Pxjjq
	bq2eYr/rPaP0hRtWR8w/qEoIsij8tGD+mnxA1XLtq99v9komdz5xz3hrFKmy5er6f0cc3tx/
	tD+F06j2MIPjbcHKaD5Wxh8f9t26p2t0YwYjT4W624zF+kW3Dp5X3vZf5JTbEalzs57luGbf
	+L564wsxQ3O+O1u+Znw1XanEUpyRaKjFXFScCAB+UDaYMgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sachin,

On 29/05/14 08:30, Sachin Kamat wrote:
> PTR_ERR_OR_ZERO simplifies the code.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> ---
>  drivers/phy/phy-exynos-mipi-video.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/phy/phy-exynos-mipi-video.c b/drivers/phy/phy-exynos-mipi-video.c
> index ff026689358c..6d6bcf52a10e 100644
> --- a/drivers/phy/phy-exynos-mipi-video.c
> +++ b/drivers/phy/phy-exynos-mipi-video.c
> @@ -9,6 +9,7 @@
>   * published by the Free Software Foundation.
>   */
>  
> +#include <linux/err.h>
>  #include <linux/io.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> @@ -149,10 +150,8 @@ static int exynos_mipi_video_phy_probe(struct platform_device *pdev)
>  
>  	phy_provider = devm_of_phy_provider_register(dev,
>  					exynos_mipi_video_phy_xlate);
> -	if (IS_ERR(phy_provider))
> -		return PTR_ERR(phy_provider);
>  
> -	return 0;
> +	return PTR_ERR_OR_ZERO(phy_provider);

I'm not convinced this is actually an improvement. For me it sounds more
like  obfuscation of the code and reminds me the infamous IS_ERR_OR_NULL()
macro. I'd personally not introduce this change, but if Kishon thinks it's
good I won't object to merging it.

--
Thanks,
Sylwester
