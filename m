Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794AbaDVKiH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 06:38:07 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:34349 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755760AbaDVKiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 06:38:00 -0400
Message-ID: <535646A1.1020201@linaro.org>
Date: Tue, 22 Apr 2014 12:38:25 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Chander Kashyap <chander.kashyap@linaro.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
CC: lorenzo.pieralisi@arm.com, rjw@rjwysocki.net, kgene.kim@samsung.com,
        Chander Kashyap <k.chander@samsung.com>
Subject: Re: [PATCH 3/4] exynos: cpuidle: do not allow cpuidle registration
 for Exynos5420
References: <1398080958-21677-1-git-send-email-chander.kashyap@linaro.org> <1398080958-21677-4-git-send-email-chander.kashyap@linaro.org>
In-Reply-To: <1398080958-21677-4-git-send-email-chander.kashyap@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2014 01:49 PM, Chander Kashyap wrote:
> Exynos5420 is big.Little Soc. It uses cpuidle-big-litle generic cpuidle driver.
> Hence do not allow exynos cpuidle driver registration for Exynos5420.
>
> Signed-off-by: Chander Kashyap <chander.kashyap@linaro.org>
> Signed-off-by: Chander Kashyap <k.chander@samsung.com>
> ---

Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>

but will conflict with:

http://www.spinics.net/lists/arm-kernel/msg319862.html

>   arch/arm/mach-exynos/cpuidle.c |    3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/arch/arm/mach-exynos/cpuidle.c b/arch/arm/mach-exynos/cpuidle.c
> index c57cae0..242f75d 100644
> --- a/arch/arm/mach-exynos/cpuidle.c
> +++ b/arch/arm/mach-exynos/cpuidle.c
> @@ -219,6 +219,9 @@ static int exynos_cpuidle_probe(struct platform_device *pdev)
>   	int cpu_id, ret;
>   	struct cpuidle_device *device;
>
> +	if (soc_is_exynos5420())
> +		return -ENODEV;
> +
>   	if (soc_is_exynos5250())
>   		exynos5_core_down_clk();
>
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

