Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007AbbAXSRb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 13:17:31 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:33184 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368AbbAXSR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 13:17:29 -0500
Date: Sat, 24 Jan 2015 19:17:24 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Daniel Church <dchurch@andplus.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        libc-alpha@sourceware.org
Subject: Re: [PATCH v2 1/2] posix-timers: Prevents overrun counter overflow
Message-ID: <20150124181724.GA5198@localhost.localdomain>
References: <1422121737-3686-1-git-send-email-dchurch@andplus.com>
 <1422121737-3686-2-git-send-email-dchurch@andplus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422121737-3686-2-git-send-email-dchurch@andplus.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 24, 2015 at 12:48:56PM -0500, Daniel Church wrote:
> +/*
> + * Updates a timer's overrun count while capping it to delaytimer_max
> + */
> +static void posix_timer_update_overrun_count(struct k_itimer *timer,
> +					     unsigned int overruns)
> +{
> +	const bool newOverrunsAboveMax = overruns >= delaytimer_max;
> +	const bool totalOverrunsAboveMax =
> +		timer->it_overrun >= 0 &&
> +		timer->it_overrun >= delaytimer_max - overruns;

Lower camel case is not a part of the kernel coding style.

Also, the 'const' keyword is useless in this context.

> +
> +	if (newOverrunsAboveMax || totalOverrunsAboveMax) {
> +		timer->it_overrun = delaytimer_max;
> +	} else {
> +		timer->it_overrun += overruns;
> +	}
> +}
> +
>  /* Get clock_realtime */
>  static int posix_clock_realtime_get(clockid_t which_clock, struct timespec *tp)
>  {
> @@ -1122,3 +1150,4 @@ long clock_nanosleep_restart(struct restart_block *restart_block)
>  
>  	return kc->nsleep_restart(restart_block);
>  }
> +

This stray newline and the camel case are the kinds of things that
checkpatch.pl will catch.

Thanks,
Richard
