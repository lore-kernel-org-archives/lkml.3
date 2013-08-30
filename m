Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309Ab3H3Okw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 10:40:52 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:44672 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822Ab3H3Okv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 10:40:51 -0400
Message-ID: <5220AEF1.7080808@tilera.com>
Date: Fri, 30 Aug 2013 10:40:49 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: lkml <linux-kernel@vger.kernel.org>, <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 1/2] time: allow changing the timekeeper clock frequency
References: <201308081953.r78Jrt0Z029523@farm-0021.internal.tilera.com> <CALAqxLX8zkzofgGSdEVsP4wdnejd25iSFHyhBwp7nRVgEnqNrA@mail.gmail.com> <520BF6EC.8070006@tilera.com> <521F95BB.2060600@tilera.com> <521FA13F.5040204@linaro.org>
In-Reply-To: <521FA13F.5040204@linaro.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/29/2013 3:30 PM, John Stultz wrote:
> On 08/29/2013 11:40 AM, Chris Metcalf wrote:
>> Ping!  I have this work queued up to push as part of the linux-tile tree for the
>> merge window.  Is that acceptable to the timekeeping/clocksource folks?
>> Should I hold it back pending further review?  Or does it make sense to
>> push it as-is and think about further improvements, if any, for a later release?
>>
>> https://lkml.org/lkml/2013/8/9/497
>> https://lkml.org/lkml/2013/8/9/499
> Oh right! Sorry for the slow response here! I originally replied while I
> was on vacation and didn't flag the thread to follow up on.
>
> Few comments below.

Thanks for the feedback. It does sound like too much to take on before
the 3.12 merge window opens, so we will plan to look into this as time
permits over the next little while. I've filed a bug internally to
track this for us.

It sounds like the most straightforward thing for us to do may be to adopt
your original approach of making our clocksource driver internally convert
the variable frequency clocksource to a fixed frequency; the overhead
shouldn't be too bad and it seems like it should moot all the other
concerns you raised in your email.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

