Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759725AbaGPHM7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 03:12:59 -0400
Received: from www.linutronix.de ([62.245.132.108]:53487 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759184AbaGPHMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 03:12:55 -0400
Date: Wed, 16 Jul 2014 09:12:52 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: John Stultz <john.stultz@linaro.org>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: Re: [patch 14/55] timekeeping: Provide internal ktime_t based data
In-Reply-To: <alpine.DEB.2.10.1407160859110.24854@nanos>
Message-ID: <alpine.DEB.2.10.1407160909310.24854@nanos>
References: <20140711133623.530368377@linutronix.de> <20140711133706.426549845@linutronix.de> <CALAqxLUPjqCidKaXQowDw5L2WQnyZsozpjhwO0QQcXvpXBt5fg@mail.gmail.com> <alpine.DEB.2.10.1407160859110.24854@nanos>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jul 2014, Thomas Gleixner wrote:

> On Tue, 15 Jul 2014, John Stultz wrote:
> > Hrmm.. So I do understand why this is useful performance wise.
> > However, I'm really starting to feel that keeping all this duplicate
> > data is a real maintenance burden, as remembering to keep the values
> > in sync always is prone to error.
> > 
> > So I may have to just put up with it, but I'd like to start thinking
> > about how to reduce the duplicated data in the future. Arnd had an
> > interesting idea for something like storing fixed point seconds, which
> > could be cheaply converted to either ktime_t or timespec values.
> > However, I suspect that would be even more complex for folks to
> > understand, which I'd rather not do.
> > 
> > Overall, it might be best if we just kill the timespec
> > wall_to_monotonic/total_sleep_time/tai_offset values and keep the
> > timekeeper values almost all in timespecs. Then we can leave the
> 
> So we kill the time specs and store everything in timespecs :)
> 
> > conversion process to basically cache the timespec values to the
> > vsyscall_update logic?

Looking into it I think for now it's the least risky approach to keep
the core logic based on the timespec stuff unmodified and update the
ktime_t members in timekeeping_update(). Converting the whole thing to
a pure nsec based mechanism and update the timespec stuff in
timekeeping_update() needs a lot more thought and we should do that
later on. It wont change any of the interfaces.

Thanks,

	tglx
