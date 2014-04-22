Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115AbaDVKlp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 06:41:45 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:53691 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755077AbaDVKlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 06:41:39 -0400
Message-ID: <5356477C.1070403@linaro.org>
Date: Tue, 22 Apr 2014 12:42:04 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Chander Kashyap <chander.kashyap@linaro.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
CC: lorenzo.pieralisi@arm.com, rjw@rjwysocki.net, kgene.kim@samsung.com,
        Chander Kashyap <k.chander@samsung.com>
Subject: Re: [PATCH 1/4] cpuidle: config: Add SOC_EXYNOS5420 entry to select
 cpuidle-big-little driver
References: <1398080958-21677-1-git-send-email-chander.kashyap@linaro.org> <1398080958-21677-2-git-send-email-chander.kashyap@linaro.org>
In-Reply-To: <1398080958-21677-2-git-send-email-chander.kashyap@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2014 01:49 PM, Chander Kashyap wrote:
> Exynos5420 is a big-little SoC from Samsung. It has 4 A15 and 4 A7 cores.
> In order to use generic cpuidle-big-little driver, this patch adds Exynos5420
> specific check to initialize generic cpuidle driver.
>
> Signed-off-by: Chander Kashyap <chander.kashyap@linaro.org>
> Signed-off-by: Chander Kashyap <k.chander@samsung.com>
> ---
>   drivers/cpuidle/Kconfig.arm |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/cpuidle/Kconfig.arm b/drivers/cpuidle/Kconfig.arm
> index 97ccc31..5244d87 100644
> --- a/drivers/cpuidle/Kconfig.arm
> +++ b/drivers/cpuidle/Kconfig.arm
> @@ -4,7 +4,7 @@
>
>   config ARM_BIG_LITTLE_CPUIDLE
>   	bool "Support for ARM big.LITTLE processors"
> -	depends on ARCH_VEXPRESS_TC2_PM
> +	depends on ARCH_VEXPRESS_TC2_PM || SOC_EXYNOS5420

For the sake of consistency, I would prefer:

depends on ARCH_VEXPRESS_TC2_PM || ARCH_EXYNOS

and let the current code (and future platform driver) to handle the 
loading of the driver.

>   	select ARM_CPU_SUSPEND
>   	select CPU_IDLE_MULTIPLE_DRIVERS
>   	help
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

