Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802AbaEOV1G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 17:27:06 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:47140 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801AbaEOV1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 17:27:04 -0400
Message-ID: <5375311B.2010202@gmail.com>
Date: Thu, 15 May 2014 23:26:51 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Chander Kashyap <chander.kashyap@linaro.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
CC: daniel.lezcano@linaro.org, lorenzo.pieralisi@arm.com, rjw@rjwysocki.net,
        kgene.kim@samsung.com, Chander Kashyap <k.chander@samsung.com>
Subject: Re: [PATCH v5 5/6] exynos: cpuidle: do not allow cpuidle registration
 for Exynos5420
References: <ANuQgHGSPJ45tbrVppAVpOqF0OfHacPWfX=S5mOVxTPr66f7vg@mail.gmail.com> <1400054637-21505-1-git-send-email-chander.kashyap@linaro.org> <1400054637-21505-6-git-send-email-chander.kashyap@linaro.org>
In-Reply-To: <1400054637-21505-6-git-send-email-chander.kashyap@linaro.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chander,

On 14.05.2014 10:03, Chander Kashyap wrote:
> Exynos5420 is big.Little Soc. It uses cpuidle-big-litle generic cpuidle driver.
> Hence do not allow exynos cpuidle driver registration for Exynos5420.
> 
> Signed-off-by: Chander Kashyap <chander.kashyap@linaro.org>
> Signed-off-by: Chander Kashyap <k.chander@samsung.com>
> Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> ---
>  arch/arm/mach-exynos/cpuidle.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/arm/mach-exynos/cpuidle.c b/arch/arm/mach-exynos/cpuidle.c
> index 3dd385e..807a386 100644
> --- a/arch/arm/mach-exynos/cpuidle.c
> +++ b/arch/arm/mach-exynos/cpuidle.c
> @@ -218,6 +218,9 @@ static int exynos_cpuidle_probe(struct platform_device *pdev)
>  	int cpu_id, ret;
>  	struct cpuidle_device *device;
>  
> +	if (soc_is_exynos5420())
> +		return -ENODEV;
> +
>  	if (soc_is_exynos5250())
>  		exynos5_core_down_clk();
>  
> 

Why not put this in exynos.c in exynos_dt_machine_init(), so
exynos_cpuidle_init() is called only if not running on Exynos5420?

Best regards,
Tomasz
