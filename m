Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbaAUTMl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 14:12:41 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:46119 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbaAUTMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 14:12:39 -0500
Message-ID: <52DEC6A3.9020600@linaro.org>
Date: Tue, 21 Jan 2014 11:12:35 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexey Perevalov <a.perevalov@samsung.com>, linux-kernel@vger.kernel.org
CC: anton@enomsg.org, kyungmin.park@samsung.com, akpm@linux-foundation.org,
        cw00.choi@samsung.com, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 0/3] Deferrable timers support for timerfd API
References: <1389609835-24377-1-git-send-email-a.perevalov@samsung.com>
In-Reply-To: <1389609835-24377-1-git-send-email-a.perevalov@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2014 02:43 AM, Alexey Perevalov wrote:
> Hello dear community.
>
> This is reworked patch set of original Anton's Vorontsov
> proposal regarding unified deferrable timers in the user space.
> http://lwn.net/Articles/514707/
>
>
> I decided to resubmit it due we found it usefull for us too.
>
> timerfd was modified since Anton's commit, Alarm support was added.
> This isn't only rebase. Anton's previous version used deferrable timer
> in couple with hrtimer. This version uses only deferrable timer. It
> mean the behaviour of overrun number is different.
> e.g. if you don't poll one second timer for a 10 seconds - you'll get
> 10 overruns with hrtimer, but for deferrable timer it could be another value.
>

Sorry, last week was a little crazy and I didn't get a chance to closely
review this. But looking at this my major conceptual objection with the
previous patchset (introducing the new clockid) is gone.

My remaining conceptual concern here is that the TIMER_DEFERRABLE flag
is a timerfd only construct here, and I worry we should make sure we
think this through well enough that the same functionality can be
supported via other timer interfaces (like clock_nanosleep, etc), which
may mean the functionality should be pushed more deeply into the hrtimer
subsystem.

So main suggestion here is to make sure you cc Thomas Gleixner on future
iterations, so he can provide some thoughts on what the best approach
might be here. I know he also has some plans that might collide with the
jiffies_to_ktime work.

Thomas: Any thought here? Should we be trying to unify the timerfd flags
and the posix timer flags (specifically things like TIMER_CANCEL_ON_SET,
which is currently timerfd-only)?  Should a deferrable flag be added to
the hrtimer core or left to the timer wheel?

thanks
-john
