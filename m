Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760230AbaGDVoP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 17:44:15 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:50188 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753595AbaGDVoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 17:44:13 -0400
Message-ID: <53B72025.5030902@samsung.com>
Date: Sat, 05 Jul 2014 06:44:05 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        David Riley <davidriley@chromium.org>,
        Chirantan Ekbote <chirantan@chromium.org>,
        linux-kernel@vger.kernel.org,
        Amit Daniel Kachhap <amit.daniel@samsung.com>, olof@lixom.net,
        Vincent Guittot <vincent.guittot@linaro.org>, tglx@linutronix.de,
        javier.martinez@collabora.co.uk, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 0/3] Exynos MCT udelay, MCT cleanup, MCT to 32-bits
References: <1403286472-6817-1-git-send-email-dianders@chromium.org>
In-Reply-To: <1403286472-6817-1-git-send-email-dianders@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/14 02:47, Doug Anderson wrote:
> This is a series of 3 patches related to the exynos MCT (multi core
> timer).  The first allows MCT to function as a udelay() timer which
> fixes broken udelay on 5400, 5800, and even (to a lesser extent) on
> 5250.  The second is some general cleanup.  The third moves MCT to
> 32-bits where possible to give us a nice speedup.
>
> The first probably ought to be destined for 3.16 as a bugfix whereas
> the others could land in a future kernel release.
>
> This series is based on (clocksource: exynos_mct: Fix ftrace).
>
> With this series we can drop the patches I submitted:
> - clocksource: exynos_mct: cache mct upper count
> - clocksource: exynos_mct: Optimize register reads with ldmia
>
> Changes in v3:
> - Back to exynos_frc_read for now until 32/64 is resolved.
> - Now returns cycles_t which matches arch/arm/include/asm/timex.h.
> - Rebased.
> - Moved registration to its own function.
> - __raw_readl / __raw_writel patch new for version 3
> - Now 32-bit version instead of ldmia version
>
> Changes in v2:
> - Added #defines for ARM and ARM64 as pointed by Doug Anderson.
>
> Amit Daniel Kachhap (1):
>    clocksource: exynos_mct: Register the timer for stable udelay
>
> Doug Anderson (2):
>    clocksource: exynos_mct: __raw_readl/__raw_writel =>
>      readl_relaxed/writel_relaxed
>    clocksource: exynos_mct: Only use 32-bits where possible
>
>   drivers/clocksource/Kconfig      |  1 +
>   drivers/clocksource/exynos_mct.c | 72 ++++++++++++++++++++++++++++++----------
>   2 files changed, 55 insertions(+), 18 deletions(-)
>

Sorry for late taking this series...looks good to me and applied 
including previous 'fix ftrace'.

Thanks,
Kukjin
