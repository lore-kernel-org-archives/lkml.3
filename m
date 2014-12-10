Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766AbaLJMwf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 07:52:35 -0500
Received: from mail-oi0-f41.google.com ([209.85.218.41]:37221 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbaLJMwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 07:52:34 -0500
MIME-Version: 1.0
In-Reply-To: <54883DB6.10504@linux.vnet.ibm.com>
References: <CA+iXiiOhPxvJKR5-9U_9Hd6mOnXJadBS+WRZhtv3yPw2r8KgJQ@mail.gmail.com>
	<54883DB6.10504@linux.vnet.ibm.com>
Date: Wed, 10 Dec 2014 18:22:32 +0530
Message-ID: <CAKohpokJxXe2RNc4Jqb20PJo2adr49nKBbzdXzYk9=H4kNjfRQ@mail.gmail.com>
Subject: Re: [Query] Spurious interrupts from clockevent device on X86 Ivybridge
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Santosh Shukla <santosh.shukla@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kevin Hilman <khilman@linaro.org>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 December 2014 at 18:03, Preeti U Murthy <preeti@linux.vnet.ibm.com> wrote:

> Right. We get an interrupt when nobody had asked for it to be delivered
> or had asked for it to be delivered and later canceled the request. It
> is most often in the latter situation, that there can be race
> conditions. If these race conditions are not taken care of, they can
> result in spurious interrupts.

But the delta time will be very small then, right ?

> Since the difference is 1us and not a noticeably high value, it is most
> probably because during hrtimer handling, we traverse all queued timers
> and call their handlers, till we find timers whose expiry is in the
> future. I would not be surprised if we overshoot the expiry of the
> timers at the end of the list by a microsecond by the time we call their
> handlers.

Looks like you misunderstood what he wrote. He isn't saying that we
serviced the timers/hrtimers sometime after we should have.

What he is saying is: we got the clockevent device's interrupt at the
time we requested but hrtimer_update_base() returned a time
lesser than what it *should* have. And that results in a spurious
interrupt.. We enqueue again for 1 us and service the timer then.

Or am I missing something ?

--
viresh
