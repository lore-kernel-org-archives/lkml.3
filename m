Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759723AbaGPDu1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 23:50:27 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:60661 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891AbaGPDuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 23:50:25 -0400
MIME-Version: 1.0
In-Reply-To: <20140711133709.584242982@linutronix.de>
References: <20140711133623.530368377@linutronix.de>
	<20140711133709.584242982@linutronix.de>
Date: Tue, 15 Jul 2014 20:50:24 -0700
Message-ID: <CALAqxLWE9CdXOpK=UgY19mw835woccfvGg_CqX92D-K67hr3SA@mail.gmail.com>
Subject: Re: [patch 51/55] clocksource: Make delta calculation a function
From: John Stultz <john.stultz@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 6:45 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> @@ -335,16 +335,15 @@ static void timekeeping_update(struct ti
>   */
>  static void timekeeping_forward_now(struct timekeeper *tk)
>  {
> -       cycle_t cycle_now, cycle_delta;
> +       cycle_t cycle_now, delta;
>         struct clocksource *clock;
>         s64 nsec;
>
>         clock = tk->clock;
>         cycle_now = clock->read(clock);
> -       cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
> -       tk->cycle_last = clock->cycle_last = cycle_now;
> +       delta = clocksource_delta(cycle_now, clock->cycle_last, clock->mask);

Errr.. Was dropping the update to tk->cycle_last and clock->cycle_last
intended? That seems broken.

thanks
-john
