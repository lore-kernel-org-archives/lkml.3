Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712Ab3IQS5a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 14:57:30 -0400
Received: from www.linutronix.de ([62.245.132.108]:54624 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447Ab3IQS53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 14:57:29 -0400
Date: Tue, 17 Sep 2013 20:57:23 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Xie XiuQi <xiexiuqi@huawei.com>
cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clocksource: fix comment for
 __clocksource_updatefreq_scale
In-Reply-To: <523831AB.9060101@huawei.com>
Message-ID: <alpine.DEB.2.02.1309172056320.4089@ionos.tec.linutronix.de>
References: <523831AB.9060101@huawei.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Sep 2013, Xie XiuQi wrote:

> The functions clocksource_updatefreq_hz() and clocksource_updatefreq_khz()
> do not exist, The proper ones are __clocksource_updatefreq_hz() and
> __clocksource_updatefreq_khz().

I'd rather rename the functions and the few call sites because the
underscores are completely meaningless.

Thanks,

	tglx

> Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
> ---
>  kernel/time/clocksource.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
> index 50a8736..d2f6ddc 100644
> --- a/kernel/time/clocksource.c
> +++ b/kernel/time/clocksource.c
> @@ -714,7 +714,8 @@ static void clocksource_enqueue(struct clocksource *cs)
>   * This should only be called from the clocksource->enable() method.
>   *
>   * This *SHOULD NOT* be called directly! Please use the
> - * clocksource_updatefreq_hz() or clocksource_updatefreq_khz helper functions.
> + * __clocksource_updatefreq_hz() or __clocksource_updatefreq_khz helper
> + * functions.
>   */
>  void __clocksource_updatefreq_scale(struct clocksource *cs, u32 scale, u32 freq)
>  {
> -- 
> 1.8.2.1
> 
> 
