Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739AbaJaRiV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 13:38:21 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:48304 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbaJaRiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 13:38:20 -0400
MIME-Version: 1.0
In-Reply-To: <1414763680.2406.68.camel@hadess.net>
References: <1413881397.30379.7.camel@hadess.net>
	<CANcMJZA=7FNNCrMpz-mC4FaJMKi8hEhqGtO_bv7iJdWVC_GpWA@mail.gmail.com>
	<1413911644.30379.12.camel@hadess.net>
	<CALAqxLURBHdrprCZzUiXdO6M7sjbwawxyDQpoG1-HWRGBvaMjg@mail.gmail.com>
	<1413914978.30379.14.camel@hadess.net>
	<20141022170433.GA10186@hungrycats.org>
	<1414420084.30379.53.camel@hadess.net>
	<20141027205936.GE17380@hungrycats.org>
	<1414499805.2406.6.camel@hadess.net>
	<CALAqxLUdkpwg=+Fcz+BKTAb1uzYbeSU0M6o5FcZGOD8X37Dfzw@mail.gmail.com>
	<1414763680.2406.68.camel@hadess.net>
Date: Fri, 31 Oct 2014 10:38:18 -0700
Message-ID: <CALAqxLV2jnUp0f=xhEOh0JaeghnwFyE7rbVke5iDJgQUeDLFVA@mail.gmail.com>
Subject: Re: A desktop environment[1] kernel wishlist
From: John Stultz <john.stultz@linaro.org>
To: Bastien Nocera <hadess@hadess.net>
Cc: Zygo Blaxell <zblaxell@furryterror.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 6:54 AM, Bastien Nocera <hadess@hadess.net> wrote:
> On Tue, 2014-10-28 at 07:36 -0700, John Stultz wrote:
>> On Tue, Oct 28, 2014 at 5:36 AM, Bastien Nocera <hadess@hadess.net> wrote:
>> > Maybe the wake-up reason isn't good enough on its own, but how do I know
>> > which one the possible wake-up reasons was the last one to trigger?
>>
>> So I feel like I'm still missing why its so critical to know what the
>> last-event was?  To me it seems a number of events have occurred, and
>> they should all be processed. Since they're all asynchronous, they
>> could come in any order, so it seems best handle them one by one
>> rather then have any requirement on which one happened last.
>>
>> What does the exact timeline of the events provide for you?
>
> What's most important is the reason for (device) wake-up.

You keep on insisting this, but I still don't quite understand *why*.

> I could see if
> the event that woke up the machine was Wake-On-LAN (which would wake up
> the screen), or the proximity of wireless networks (Wi-Fi card firmwares
> can do that on their own) (which wouldn't wake the screen up).
>
> The timestamp makes it possible to avoid races that were mentioned
> earlier in the thread.

But even as Alan said, we may not actually know the real ordering even
in the kernel. We come out of resume and there may be three interrupts
pending, and they'll just be handled in priority order, not in real
time order.

> Knowing whether an alarm or a button woke the machine would be useful as
> well (even if we would need to monitor additional resources, such as the
> input devices, or accelerometers, to know what state the machine
> currently is in).
>
> As others mentioned, this is also useful as a power debugging tool. The
> important part here would be that each device would report its own
> wake-up reason, which the driver can know better than user-space or
> other parts of the kernel. User-space would be responsible for
> coalescing that information.

I agree that it can be useful for power statistics and debugging, and
there is work being done by Android folks and others to improve this.
So you might follow along with that work.

But I still am concerned that the model you're seeming to want to use
- depending on what specifically caused the state transition - is
flawed, and instead recommend a more event based model.

Even so, I worry we're just talking past each other, so I'll stop
being a wet blanket here and let you get on with doing development and
hopefully proving me wrong. :)

thanks
-john
