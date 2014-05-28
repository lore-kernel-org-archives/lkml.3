Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655AbaE1I6Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 04:58:25 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:64243 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634AbaE1I6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 04:58:19 -0400
Message-ID: <5385A538.8020504@linaro.org>
Date: Wed, 28 May 2014 10:58:32 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Chander Kashyap <chander.kashyap@linaro.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
CC: linux-arm-kernel@lists.infradead.org, lorenzo.pieralisi@arm.com,
        rjw@rjwysocki.net, kgene.kim@samsung.com, tomasz.figa@gmail.com,
        Chander Kashyap <k.chander@samsung.com>
Subject: Re: [PATCH v6 1/6] driver: cpuidle-big-little: add of_device_id structure
References: <CANuQgHGSA+R__raSa_tzrgpceqLD2SZw+s0XQUHGF4wscgh6Kg@mail.gmail.com> <1400227438-27155-1-git-send-email-chander.kashyap@linaro.org> <1400227438-27155-2-git-send-email-chander.kashyap@linaro.org>
In-Reply-To: <1400227438-27155-2-git-send-email-chander.kashyap@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2014 10:03 AM, Chander Kashyap wrote:
> This driver will be used by many big.Little Soc's. As of now it does
> string matching of hardcoded compatible string to init the driver. This
> comparison list will keep on growing with addition of new SoC's.
> Hence add of_device_id structure to collect the compatible strings of
> SoC's using this driver.
>
> Signed-off-by: Chander Kashyap <chander.kashyap@linaro.org>
> Signed-off-by: Chander Kashyap <k.chander@samsung.com>

Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>

> ---
>   drivers/cpuidle/cpuidle-big_little.c |   11 ++++++++++-
>   1 file changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/cpuidle/cpuidle-big_little.c b/drivers/cpuidle/cpuidle-big_little.c
> index b45fc62..4cd02bd 100644
> --- a/drivers/cpuidle/cpuidle-big_little.c
> +++ b/drivers/cpuidle/cpuidle-big_little.c
> @@ -163,14 +163,23 @@ static int __init bl_idle_driver_init(struct cpuidle_driver *drv, int cpu_id)
>   	return 0;
>   }
>
> +static const struct of_device_id compatible_machine_match[] = {
> +	{ .compatible = "arm,vexpress,v2p-ca15_a7" },
> +	{},
> +};
> +
>   static int __init bl_idle_init(void)
>   {
>   	int ret;
> +	struct device_node *root = of_find_node_by_path("/");
> +
> +	if (!root)
> +		return -ENODEV;
>
>   	/*
>   	 * Initialize the driver just for a compliant set of machines
>   	 */
> -	if (!of_machine_is_compatible("arm,vexpress,v2p-ca15_a7"))
> +	if (!of_match_node(compatible_machine_match, root))
>   		return -ENODEV;
>   	/*
>   	 * For now the differentiation between little and big cores
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

