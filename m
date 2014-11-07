Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543AbaKGERH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 23:17:07 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:58302 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbaKGERE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 23:17:04 -0500
Message-ID: <545C47BC.4050207@nvidia.com>
Date: Thu, 06 Nov 2014 21:17:00 -0700
From: Stephen Warren <swarren@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Anatol Pomozov <anatol.pomozov@gmail.com>
CC: pdeschrijver@nvidia.com, marc.zyngier@arm.com,
        linux-kernel@vger.kernel.org,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH] clocksource: tegra: Port tegra20 clocksource to arm64
References: <1415319715-21757-1-git-send-email-anatol.pomozov@gmail.com>
In-Reply-To: <1415319715-21757-1-git-send-email-anatol.pomozov@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2014 05:21 PM, Anatol Pomozov wrote:
> register_persistent_clock() are in different headers in arm/arm64
> 
> Tested: Compiled the driver on 64bit platform and make sure that
> it works

I assume "it works" refers to "it compiles" not "it executes successfully"?

I think it'd be better to make the same APIs available on arm and arm64,
or even across all architectures.

> Signed-off-by: Anatol Pomozov <anatol.pomozov@gmail.com>
> ---
>  drivers/clocksource/tegra20_timer.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/clocksource/tegra20_timer.c b/drivers/clocksource/tegra20_timer.c
> index d2616ef..e0123c7 100644
> --- a/drivers/clocksource/tegra20_timer.c
> +++ b/drivers/clocksource/tegra20_timer.c
> @@ -29,8 +29,12 @@
>  #include <linux/sched_clock.h>
>  #include <linux/delay.h>
>  
> +#ifdef CONFIG_ARM64
> +#include <asm/time.h>
> +#else
>  #include <asm/mach/time.h>
>  #include <asm/smp_twd.h>
> +#endif
>  
>  #define RTC_SECONDS            0x08
>  #define RTC_SHADOW_SECONDS     0x0c
> 

