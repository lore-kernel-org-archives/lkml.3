Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758435AbaGCOmW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 10:42:22 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:49585 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845AbaGCOmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 10:42:18 -0400
MIME-Version: 1.0
In-Reply-To: <20140703095922.14c70ab1@gandalf.local.home>
References: <CAKohpomvG-jEhMow=g5-nOAW7aBGBAfMjwRocOMU3rMfK9VTgA@mail.gmail.com>
	<20140703095922.14c70ab1@gandalf.local.home>
Date: Thu, 3 Jul 2014 20:12:18 +0530
Message-ID: <CAKohpokj3nop9OKAmK386ofs4FM_KhjpLD+xz5Hf4gz+gp5dgA@mail.gmail.com>
Subject: Re: [Query/tick] Are we enqueing 'tick-sched' hrtimers in past ?
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linaro Networking <linaro-networking@linaro.org>,
        Kevin Hilman <khilman@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 July 2014 19:29, Steven Rostedt <rostedt@goodmis.org> wrote:
> Unless you changed clocks, the default timing of the trace is done by

I haven't..

> trace_clock_local() which basically just calls sched_clock(). Not much
> to be fixed there.

Okay.

> I would be interested in seeing another hrtimer_expire_entry to see if
> that is off by anything else other than 10ms. As that event is the only
> one shown to show what hrtimer thinks "now" is.

I checked that for some other timer and it was still 10ms. So, its not a
tick-sched issue.

> Also, I'm not really seeing what is wrong with the above. The
> expire_entry means the timer is being triggered and it raised the
> softirq. The hrtimer_start is a new setting to go off at 149.745. Since
> you noticed that the trace time stamp is 10ms ahead, that would state
> that the hrtimer would go off around trace timestamp 149.755.

The only part that looked odd to me was this offset of 10ms.

> The trace timer stamp uses a different clock than hrtimers does. Do not
> confuse them as the same clock.

Hmm, that's new. And the diff might be ~10ms

> The best you can do is reference
> that "now" value to get the difference between the two and use that as a
> reference for what the time stamp of the trace should be when the
> hrtimer goes off again.

Yeah, it was on time as this 10ms offset was consistent ..

So, there is no problem in traces apart from the fact that people might
try to match trace-time and hrtimer time, like I did.

But the other issue I reported in hrtimer/tick-sched code might still be valid.

Thanks for your reply.

--
viresh
