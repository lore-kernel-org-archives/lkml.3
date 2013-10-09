Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757586Ab3JIXfk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 19:35:40 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:51336 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756800Ab3JIXfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 19:35:39 -0400
Message-ID: <5255E847.9030502@linaro.org>
Date: Wed, 09 Oct 2013 16:35:35 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Xie XiuQi <xiexiuqi@huawei.com>, Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] clocksource: fix misleading comment for __clocksource_updatefreq_scale()
References: <5239167D.7090404@huawei.com>
In-Reply-To: <5239167D.7090404@huawei.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2013 07:57 PM, Xie XiuQi wrote:
> Functions clocksource_updatefreq_hz() and clocksource_updatefreq_khz()
> mentioned in the comment of __clocksource_updatefreq_scale() do not exist.
>
> As Thomas Gleixner's suggestion, I renamed the functions and the few call
> sites because the underscores are completely meaningless.

First of all, sorry for taking so long to reply here.

So I think the __ tries to imply that those are semi-internal functions
that aren't to be causally used w/o understanding the internal details.

> Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> ---
>  drivers/clocksource/cadence_ttc_timer.c | 2 +-
>  drivers/clocksource/em_sti.c            | 2 +-
>  drivers/clocksource/sh_cmt.c            | 2 +-
>  drivers/clocksource/sh_tmu.c            | 2 +-
>  include/linux/clocksource.h             | 4 ++--
>  5 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/clocksource/cadence_ttc_timer.c b/drivers/clocksource/cadence_ttc_timer.c
> index 4cbe28c..05f00e7 100644
> --- a/drivers/clocksource/cadence_ttc_timer.c
> +++ b/drivers/clocksource/cadence_ttc_timer.c
> @@ -226,7 +226,7 @@ static int ttc_rate_change_clocksource_cb(struct notifier_block *nb,
>  		 * Do whatever is necessary to maintain a proper time base
>  		 *
>  		 * I cannot find a way to adjust the currently used clocksource
> -		 * to the new frequency. __clocksource_updatefreq_hz() sounds
> +		 * to the new frequency. clocksource_updatefreq_hz() sounds
>  		 * good, but does not work. Not sure what's that missing.
>  		 *

So I know you didn't write the comment, but my issue with this comment
is that there isn't a way to adjust the currently used clocksource
frequency, because that is totally unsupported. The
__clocksource_updatefreq_hz() method is really only there for
clocksources that are currently not in-use and are disabled.
Specifically for clocksources that may come out of resume at a different
frequency, like the sh_ ones. Hacks like what the cadence_ttc driver is
trying to do result in very poor timekeeping.

So I'm sort of on the fence about this patch.

Thomas: Any other thoughts?

thanks
-john
