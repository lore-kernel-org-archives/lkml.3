Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194Ab3HERWt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 13:22:49 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:62017 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929Ab3HERWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 13:22:47 -0400
Message-ID: <51FFDF63.1090505@samsung.com>
Date: Tue, 06 Aug 2013 02:22:43 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: arm@kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 17/18] ARM: SAMSUNG: Switch to sched_clock_register()
References: <1375309877-16617-1-git-send-email-sboyd@codeaurora.org> <1375309877-16617-18-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1375309877-16617-18-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/13 07:31, Stephen Boyd wrote:
> The 32 bit sched_clock interface now supports 64 bits. Upgrade to
> the 64 bit function to allow us to remove the 32 bit registration
> interface.
>
> Cc: Ben Dooks<ben-linux@fluff.org>
> Cc: Kukjin Kim<kgene.kim@samsung.com>

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

Thanks,
Kukjin

> Signed-off-by: Stephen Boyd<sboyd@codeaurora.org>
> ---
>   arch/arm/plat-samsung/samsung-time.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm/plat-samsung/samsung-time.c b/arch/arm/plat-samsung/samsung-time.c
> index 2957075..1e2119b 100644
> --- a/arch/arm/plat-samsung/samsung-time.c
> +++ b/arch/arm/plat-samsung/samsung-time.c
> @@ -312,7 +312,7 @@ static void __iomem *samsung_timer_reg(void)
>    * this wraps around for now, since it is just a relative time
>    * stamp. (Inspired by U300 implementation.)
>    */
> -static u32 notrace samsung_read_sched_clock(void)
> +static u64 notrace samsung_read_sched_clock(void)
>   {
>   	void __iomem *reg = samsung_timer_reg();
>
> @@ -337,7 +337,7 @@ static void __init samsung_clocksource_init(void)
>   	samsung_time_setup(timer_source.source_id, TCNT_MAX);
>   	samsung_time_start(timer_source.source_id, PERIODIC);
>
> -	setup_sched_clock(samsung_read_sched_clock, TSIZE, clock_rate);
> +	sched_clock_register(samsung_read_sched_clock, TSIZE, clock_rate);
>
>   	if (clocksource_mmio_init(samsung_timer_reg(), "samsung_clocksource_timer",
>   			clock_rate, 250, TSIZE, clocksource_mmio_readl_down))
