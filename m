Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760705AbaJaNz0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 09:55:26 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:57161 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759301AbaJaNzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 09:55:23 -0400
X-Originating-IP: 83.155.44.161
Message-ID: <1414763680.2406.68.camel@hadess.net>
Subject: Re: A desktop environment[1] kernel wishlist
From: Bastien Nocera <hadess@hadess.net>
To: John Stultz <john.stultz@linaro.org>
Cc: Zygo Blaxell <zblaxell@furryterror.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 31 Oct 2014 14:54:40 +0100
In-Reply-To: <CALAqxLUdkpwg=+Fcz+BKTAb1uzYbeSU0M6o5FcZGOD8X37Dfzw@mail.gmail.com>
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
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7 (3.12.7-1.fc21) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-28 at 07:36 -0700, John Stultz wrote:
> On Tue, Oct 28, 2014 at 5:36 AM, Bastien Nocera <hadess@hadess.net> wrote:
> > Maybe the wake-up reason isn't good enough on its own, but how do I know
> > which one the possible wake-up reasons was the last one to trigger?
> 
> So I feel like I'm still missing why its so critical to know what the
> last-event was?  To me it seems a number of events have occurred, and
> they should all be processed. Since they're all asynchronous, they
> could come in any order, so it seems best handle them one by one
> rather then have any requirement on which one happened last.
> 
> What does the exact timeline of the events provide for you?

What's most important is the reason for (device) wake-up. I could see if
the event that woke up the machine was Wake-On-LAN (which would wake up
the screen), or the proximity of wireless networks (Wi-Fi card firmwares
can do that on their own) (which wouldn't wake the screen up).

The timestamp makes it possible to avoid races that were mentioned
earlier in the thread.

Knowing whether an alarm or a button woke the machine would be useful as
well (even if we would need to monitor additional resources, such as the
input devices, or accelerometers, to know what state the machine
currently is in).

As others mentioned, this is also useful as a power debugging tool. The
important part here would be that each device would report its own
wake-up reason, which the driver can know better than user-space or
other parts of the kernel. User-space would be responsible for
coalescing that information.

