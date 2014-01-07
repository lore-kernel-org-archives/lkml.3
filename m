Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417AbaAGRfF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 12:35:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42267 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbaAGRe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 12:34:57 -0500
Date: Tue, 7 Jan 2014 17:34:53 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, dinguyen@altera.com, baruch@tkos.co.il,
        tglx@linutronix.de
Subject: Re: [PATCH-3.12.y 1/2] clocksource: dw_apb_timer_of: Fix
 read_sched_clock
Message-ID: <20140107173453.GD4383@hercules>
References: <1387492214-27911-1-git-send-email-daniel.lezcano@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387492214-27911-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 11:30:13PM +0100, Daniel Lezcano wrote:
> From: Dinh Nguyen <dinguyen@altera.com>
> 
> Upstream commit 85dc6ee
> 
> The read_sched_clock should return the ~value because the clock is a
> countdown implementation. read_sched_clock() should be the same as
>  __apbt_read_clocksource().
> 
> Signed-off-by: Dinh Nguyen <dinguyen@altera.com>
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> ---
>  drivers/clocksource/dw_apb_timer_of.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/clocksource/dw_apb_timer_of.c b/drivers/clocksource/dw_apb_timer_of.c
> index 4cbae4f..33fd4ff 100644
> --- a/drivers/clocksource/dw_apb_timer_of.c
> +++ b/drivers/clocksource/dw_apb_timer_of.c
> @@ -108,7 +108,7 @@ static void add_clocksource(struct device_node *source_timer)
>  
>  static u32 read_sched_clock(void)
>  {
> -	return __raw_readl(sched_io_base);
> +	return ~__raw_readl(sched_io_base);
>  }
>  
>  static const struct of_device_id sptimer_ids[] __initconst = {
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

I believe these 2 patches are also applicable to the 3.11 kernel.  Unless
there are any objection, I'm queuing it for the next release.

Cheers,
--
Luis
