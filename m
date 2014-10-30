Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760287AbaJ3OgY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 10:36:24 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:59710 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759827AbaJ3OgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 10:36:23 -0400
X-Originating-IP: 83.155.44.161
Message-ID: <1414679738.2406.49.camel@hadess.net>
Subject: Re: A desktop environment[1] kernel wishlist
From: Bastien Nocera <hadess@hadess.net>
To: John Stultz <john.stultz@linaro.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 30 Oct 2014 15:35:38 +0100
In-Reply-To: <CALAqxLXyaL55JuDuHAcWX0PEdem-jpVxK0rbJaNrBbBJ3rQY5Q@mail.gmail.com>
References: <1413881397.30379.7.camel@hadess.net>
	 <CANcMJZA=7FNNCrMpz-mC4FaJMKi8hEhqGtO_bv7iJdWVC_GpWA@mail.gmail.com>
	 <1413911644.30379.12.camel@hadess.net>
	 <CALAqxLURBHdrprCZzUiXdO6M7sjbwawxyDQpoG1-HWRGBvaMjg@mail.gmail.com>
	 <1413914978.30379.14.camel@hadess.net>
	 <CALAqxLX2Q-2RBF1zY6JAWrqNiqBFG3vxUwUSLVS3qXpgSOb9xA@mail.gmail.com>
	 <1414419579.30379.49.camel@hadess.net>
	 <CALAqxLXyaL55JuDuHAcWX0PEdem-jpVxK0rbJaNrBbBJ3rQY5Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7 (3.12.7-1.fc21) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-27 at 09:56 -0700, John Stultz wrote:
> On Mon, Oct 27, 2014 at 7:19 AM, Bastien Nocera <hadess@hadess.net> wrote:
> > I also cannot know, from user-space, whether Wake-On-LAN,
> > Wake-On-Wireless-LAN, or the Wi-Fi card's "network proximity" triggered
> > coming out of suspend for example.
> >
> > I can certainly check for the status of the lid, but I wouldn't know
> > whether a button was pressed to turn the machine back on, as the
> > firmware would eat that.
> 
> If the firmware eats that button (which I hope it wouldn't, but I
> probably should know better then to expect sane behavior), how does
> the kernel know anything more?

The kernel receives an interrupt, likely on a different device. Again,
I'm talking about "legacy" devices, for which suspend is actually a
state. If the device is only in low-power mode, you'd probably get the
event on the input device, which is accessible from user-space.

> > To make it short, I don't have a way to know, from user-space, whether
> > the event that took it out of suspend was programmatic, or user action.
> > I would add that, even if we said that races can occur, I have no easy
> > way to know, from user-space, whether the last thing that occurred was
> > the Wi-Fi card waking the machine up or the power button being pressed.
> 
> 
> Again, I think you just want to know if the power button (or lid
> trigger) was pressed. Not if it was the cause for resume (since a
> wake-on-lan or alarm could fire right as the user presses the power
> button). If those button presses don't reliably get communicated, I
> think that's a better problem to solve in the kernel.
> 
> Again, part of the reason I'm pushing back here, is that there may be
> a lot of things going on on a system, and systems may suspend and
> resume quite often while being in use, so applications really should
> handle events consistently weather the system was suspended or not
> (another lesson from android: suspend blocking is a more flexible
> approach then having applications initiate suspend, since you avoid
> all the races of multiple applications trying to manage initiating
> suspend state).
> 
> But the other part of why I'm pushing back is that on future hardware,
> we may not have a "suspend" mode, and systems may just be in a deep
> idle, with selected interrupts disabled (event filtering, in other
> words). So I think its better if you design around events (button
> presses, lid triggers, mouse movements, timers firing), rather then
> specific system suspend state.

Knowing why the Wi-Fi card woke up is also important when there isn't a
full "suspend" state. As was mentioned, it's useful for power debugging,
but it's also useful because that tells things outside the network card
driver what happened.

As I mentioned in more recent emails on this thread, maybe we don't want
to know what woke the system up, but knowing that a wake-up event
occurred on this device, at this time, would allow us to make the
software act accordingly. The fact that we don't know that means that we
cannot take appropriate action.

Cheers

