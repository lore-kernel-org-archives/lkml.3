Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421Ab3KQU1v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 15:27:51 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:54959 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906Ab3KQU1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 15:27:43 -0500
MIME-Version: 1.0
In-Reply-To: <1384558303-10731-1-git-send-email-sboyd@codeaurora.org>
References: <1384558303-10731-1-git-send-email-sboyd@codeaurora.org>
Date: Mon, 18 Nov 2013 00:27:42 +0400
Message-ID: <CAMo8Bf+kQi7-7FfteB-DpdauSYJn4Ztjuy6oTOnVXk9aVBzUbQ@mail.gmail.com>
Subject: Re: [PATCH] xtensa: Switch to sched_clock_register()
From: Max Filippov <jcmvbkbc@gmail.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Chris Zankel <chris@zankel.net>,
        "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 16, 2013 at 3:31 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> The 32 bit sched_clock interface now supports 64 bits. Upgrade
> to the 64 bit function to allow us to remove the 32 bit
> registration interface.
>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>
> Patch is based on Linus' tip. Not event compile tested.
>
>  arch/xtensa/kernel/time.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Build and run-tested, appears to work.
Acked-by: Max Filippov <jcmvbkbc@gmail.com>

Should it go through xtensa tree, or through some other tree as a part
of a bigger conversion series?

> diff --git a/arch/xtensa/kernel/time.c b/arch/xtensa/kernel/time.c
> index 9af3dd8..415c3f6 100644
> --- a/arch/xtensa/kernel/time.c
> +++ b/arch/xtensa/kernel/time.c
> @@ -36,7 +36,7 @@ static cycle_t ccount_read(struct clocksource *cs)
>         return (cycle_t)get_ccount();
>  }
>
> -static u32 notrace ccount_sched_clock_read(void)
> +static u64 notrace ccount_sched_clock_read(void)
>  {
>         return get_ccount();
>  }
> @@ -141,7 +141,7 @@ void __init time_init(void)
>         setup_irq(ccount_timer.evt.irq, &timer_irqaction);
>         ccount_timer.irq_enabled = 1;
>
> -       setup_sched_clock(ccount_sched_clock_read, 32, ccount_freq);
> +       sched_clock_register(ccount_sched_clock_read, 32, ccount_freq);
>  }
>
>  /*
> --
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
>



-- 
Thanks.
-- Max
