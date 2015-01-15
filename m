Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860AbbAONYA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 08:24:00 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:40384 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555AbbAONX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 08:23:58 -0500
Message-ID: <54B7BF68.9030303@gmail.com>
Date: Thu, 15 Jan 2015 16:23:52 +0300
From: Dmitry Osipenko <digetx@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>
CC: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: tegra20: cpuidle: remove unnecessary "resettable"
 status clear
References: <1421326202-29845-1-git-send-email-digetx@gmail.com>
In-Reply-To: <1421326202-29845-1-git-send-email-digetx@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

15.01.2015 15:49, Dmitry Osipenko пишет:
> CPU1 "resettable" status is already cleared by final suspend function in case
> of suspend abortion and by reset handler in case of completed CPU powergate,
> no point to do it again.
>
> Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
> ---
>   arch/arm/mach-tegra/cpuidle-tegra20.c | 2 --
>   1 file changed, 2 deletions(-)
>
> diff --git a/arch/arm/mach-tegra/cpuidle-tegra20.c b/arch/arm/mach-tegra/cpuidle-tegra20.c
> index b30bf5c..ad6158e 100644
> --- a/arch/arm/mach-tegra/cpuidle-tegra20.c
> +++ b/arch/arm/mach-tegra/cpuidle-tegra20.c
> @@ -158,8 +158,6 @@ static bool tegra20_idle_enter_lp2_cpu_1(struct cpuidle_device *dev,
>
>   	cpu_suspend(0, tegra20_sleep_cpu_secondary_finish);
>
> -	tegra20_cpu_clear_resettable();
> -
>   	clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &dev->cpu);
>
>   	return true;
>
Completely forgot to remove it also from 'sleep.h' and 'sleep-tegra20.S'. Please 
ignore this patch, I'll include it in ASM -> C conversion series.

-- 
Dmitry
