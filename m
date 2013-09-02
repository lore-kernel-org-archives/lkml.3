Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758440Ab3IBJ3f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 05:29:35 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:51852 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758306Ab3IBJ3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 05:29:33 -0400
Message-ID: <52245A7C.6070602@linaro.org>
Date: Mon, 02 Sep 2013 11:29:32 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
CC: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] intel_idle: mark some functions with __init tag
References: <2017492.SHLf7BQHGW@amdc1032>
In-Reply-To: <2017492.SHLf7BQHGW@amdc1032>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2013 12:27 PM, Bartlomiej Zolnierkiewicz wrote:
> intel_idle_probe() and intel_idle_cpuidle_driver_init() can be marked
> with __init tag as they are only called from intel_idle_init().
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Len Brown <lenb@kernel.org>
> ---

Reviewed-by: Daniel Lezcano <daniel.lezcano@linaro.org>


>  drivers/idle/intel_idle.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
> index 53b24f1..33e599e 100644
> --- a/drivers/idle/intel_idle.c
> +++ b/drivers/idle/intel_idle.c
> @@ -490,7 +490,7 @@ MODULE_DEVICE_TABLE(x86cpu, intel_idle_ids);
>  /*
>   * intel_idle_probe()
>   */
> -static int intel_idle_probe(void)
> +static int __init intel_idle_probe(void)
>  {
>  	unsigned int eax, ebx, ecx;
>  	const struct x86_cpu_id *id;
> @@ -558,7 +558,7 @@ static void intel_idle_cpuidle_devices_uninit(void)
>   * intel_idle_cpuidle_driver_init()
>   * allocate, initialize cpuidle_states
>   */
> -static int intel_idle_cpuidle_driver_init(void)
> +static int __init intel_idle_cpuidle_driver_init(void)
>  {
>  	int cstate;
>  	struct cpuidle_driver *drv = &intel_idle_driver;

-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

