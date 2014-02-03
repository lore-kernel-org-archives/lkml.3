Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbaBCQjy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 11:39:54 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:48574 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbaBCQjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 11:39:53 -0500
Message-ID: <52EFC652.9000209@linaro.org>
Date: Mon, 03 Feb 2014 17:39:46 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andrew Chew <achew@nvidia.com>, tglx@linutronix.de, swarren@wwwdotorg.org,
        thierry.reding@gmail.com, abrestic@chromium.org, dgreid@chromium.org,
        katierh@chromium.org
CC: linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH v1] clocksource: tegra: Add nvidia,tegra30-timer compat
References: <1391203779-5676-1-git-send-email-achew@nvidia.com>
In-Reply-To: <1391203779-5676-1-git-send-email-achew@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2014 10:29 PM, Andrew Chew wrote:
> There are some differences between tegra20's timer registers and tegra30's
> (and later).  For one thing, the watchdogs don't seem to be present in
> tegra20.

"don't seem", so it is an assumption ?

> Add this compatibility string in order to be able to distinguish
> whether the watchdogs are there or not.

Sorry but I don't get the connection between declaring the tegra30_timer 
and the log. Can you elaborate please ?

> Signed-off-by: Andrew Chew <achew@nvidia.com>
> ---
>   drivers/clocksource/tegra20_timer.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/clocksource/tegra20_timer.c b/drivers/clocksource/tegra20_timer.c
> index d1869f0..73cfa56 100644
> --- a/drivers/clocksource/tegra20_timer.c
> +++ b/drivers/clocksource/tegra20_timer.c
> @@ -218,6 +218,7 @@ static void __init tegra20_init_timer(struct device_node *np)
>   					0x1, 0x1fffffff);
>   }
>   CLOCKSOURCE_OF_DECLARE(tegra20_timer, "nvidia,tegra20-timer", tegra20_init_timer);
> +CLOCKSOURCE_OF_DECLARE(tegra30_timer, "nvidia,tegra30-timer", tegra20_init_timer);
>
>   static void __init tegra20_init_rtc(struct device_node *np)
>   {
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

