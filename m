Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105AbaBEUEH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:04:07 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:37727 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989AbaBEUDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:03:53 -0500
Message-ID: <52F29923.6020708@wwwdotorg.org>
Date: Wed, 05 Feb 2014 13:03:47 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andrew Chew <achew@nvidia.com>, daniel.lezcano@linaro.org,
        tglx@linutronix.de, thierry.reding@gmail.com, rob@landley.net,
        grant.likely@linaro.org, robh+dt@kernel.org, abrestic@chromium.org,
        dgreid@chromium.org, katierh@chromium.org
CC: linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 2/3] clocksource: tegra: Define timer bases in header
 file
References: <1391473055-3158-1-git-send-email-achew@nvidia.com> <1391473055-3158-3-git-send-email-achew@nvidia.com>
In-Reply-To: <1391473055-3158-3-git-send-email-achew@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2014 05:17 PM, Andrew Chew wrote:
> Added timers that are present in tegra30 and later, that are NOT in tegra20.
> 
> Also, some of these timer bases are needed in the tegra watchdog driver, so
> separate them out into a header file that both the clocksource driver and
> the watchdog driver can share them.

> diff --git a/include/clocksource/tegra_timer.h b/include/clocksource/tegra_timer.h

> +/* Tegra 20 timers */
> +#define TEGRA20_TIMER1_BASE	0x0
> +#define TEGRA20_TIMER2_BASE	0x8
> +#define TEGRA20_TIMER3_BASE	0x50
> +#define TEGRA20_TIMER4_BASE	0x58
> +
> +/* Tegra 30 timers */
> +#define TEGRA30_TIMER1_BASE	TEGRA20_TIMER1_BASE
> +#define TEGRA30_TIMER2_BASE	TEGRA20_TIMER2_BASE
> +#define TEGRA30_TIMER3_BASE	TEGRA20_TIMER3_BASE
> +#define TEGRA30_TIMER4_BASE	TEGRA20_TIMER4_BASE
> +#define TEGRA30_TIMER5_BASE	0x60
> +#define TEGRA30_TIMER6_BASE	0x68
> +#define TEGRA30_TIMER7_BASE	0x70
> +#define TEGRA30_TIMER8_BASE	0x78
> +#define TEGRA30_TIMER9_BASE	0x80
> +#define TEGRA30_TIMER0_BASE	0x88

Why put the SoC name in the define names? Why not just have
TIMER1_BASE..TIMER10_BASE (that should be 10 not 0 as in your patch,
right?) and have the driver know that 1..4 are valid on Tegra20, and
1..10 are valid on later chips.

I guess if the defines are moved into a header file, adding a TEGRA_
prefix does make sense.

But I wonder if it wouldn't be simpler for the Tegra WDT driver to just
call a function on the Tegra clocksource driver to find out which timer
ID(s) to avoid using? Even simpler would be to just put a comment in the
WDT driver saying that timer 5 was chosen arbitrarily, but if it's
changed make sure not to conflict with the clocksource driver (and an
equivalent change to the clocksource driver).
