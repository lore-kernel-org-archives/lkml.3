Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334Ab3H3QE4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 12:04:56 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:33950 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144Ab3H3QEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 12:04:54 -0400
Message-ID: <5220C2A2.1020502@linaro.org>
Date: Fri, 30 Aug 2013 09:04:50 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Chris Metcalf <cmetcalf@tilera.com>
CC: lkml <linux-kernel@vger.kernel.org>, cpufreq@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 1/2] time: allow changing the timekeeper clock frequency
References: <201308081953.r78Jrt0Z029523@farm-0021.internal.tilera.com> <CALAqxLX8zkzofgGSdEVsP4wdnejd25iSFHyhBwp7nRVgEnqNrA@mail.gmail.com> <520BF6EC.8070006@tilera.com> <521F95BB.2060600@tilera.com> <521FA13F.5040204@linaro.org> <5220AEF1.7080808@tilera.com>
In-Reply-To: <5220AEF1.7080808@tilera.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2013 07:40 AM, Chris Metcalf wrote:
> On 8/29/2013 3:30 PM, John Stultz wrote:
>> On 08/29/2013 11:40 AM, Chris Metcalf wrote:
>>> Ping!  I have this work queued up to push as part of the linux-tile tree for the
>>> merge window.  Is that acceptable to the timekeeping/clocksource folks?
>>> Should I hold it back pending further review?  Or does it make sense to
>>> push it as-is and think about further improvements, if any, for a later release?
>>>
>>> https://lkml.org/lkml/2013/8/9/497
>>> https://lkml.org/lkml/2013/8/9/499
>> Oh right! Sorry for the slow response here! I originally replied while I
>> was on vacation and didn't flag the thread to follow up on.
>>
>> Few comments below.
> Thanks for the feedback. It does sound like too much to take on before
> the 3.12 merge window opens, so we will plan to look into this as time
> permits over the next little while. I've filed a bug internally to
> track this for us.
>
> It sounds like the most straightforward thing for us to do may be to adopt
> your original approach of making our clocksource driver internally convert
> the variable frequency clocksource to a fixed frequency; the overhead
> shouldn't be too bad and it seems like it should moot all the other
> concerns you raised in your email.
Yea, so most of my concerns would also apply to having the clocksource
driver hide the frequency changes (since there still will be latency
error, and variable freq error), but I do prefer having it as a
clocksource specific hack, rather then in the timekeeping core so we can
avoid seemingly condoning wide use of freq changing clocksources. If it
does go in the core, I'm sure a few years down the line, someone will
notice a problem with their freq changing clocksource and demand the
bugs be fixed!

That said, I'm still open to further discussing your current approach
for the next cycle. Since its possible the latency and freq errors
really are small enough to not matter, avoiding the inefficiencies of
hiding the changes in the clocksource driver might be worth it.

thanks
-john

