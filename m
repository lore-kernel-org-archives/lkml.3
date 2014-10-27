Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875AbaJ0Q5A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 12:57:00 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:36426 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbaJ0Q47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 12:56:59 -0400
MIME-Version: 1.0
In-Reply-To: <1414419579.30379.49.camel@hadess.net>
References: <1413881397.30379.7.camel@hadess.net>
	<CANcMJZA=7FNNCrMpz-mC4FaJMKi8hEhqGtO_bv7iJdWVC_GpWA@mail.gmail.com>
	<1413911644.30379.12.camel@hadess.net>
	<CALAqxLURBHdrprCZzUiXdO6M7sjbwawxyDQpoG1-HWRGBvaMjg@mail.gmail.com>
	<1413914978.30379.14.camel@hadess.net>
	<CALAqxLX2Q-2RBF1zY6JAWrqNiqBFG3vxUwUSLVS3qXpgSOb9xA@mail.gmail.com>
	<1414419579.30379.49.camel@hadess.net>
Date: Mon, 27 Oct 2014 09:56:58 -0700
Message-ID: <CALAqxLXyaL55JuDuHAcWX0PEdem-jpVxK0rbJaNrBbBJ3rQY5Q@mail.gmail.com>
Subject: Re: A desktop environment[1] kernel wishlist
From: John Stultz <john.stultz@linaro.org>
To: Bastien Nocera <hadess@hadess.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 7:19 AM, Bastien Nocera <hadess@hadess.net> wrote:
> I also cannot know, from user-space, whether Wake-On-LAN,
> Wake-On-Wireless-LAN, or the Wi-Fi card's "network proximity" triggered
> coming out of suspend for example.
>
> I can certainly check for the status of the lid, but I wouldn't know
> whether a button was pressed to turn the machine back on, as the
> firmware would eat that.

If the firmware eats that button (which I hope it wouldn't, but I
probably should know better then to expect sane behavior), how does
the kernel know anything more?

> To make it short, I don't have a way to know, from user-space, whether
> the event that took it out of suspend was programmatic, or user action.
> I would add that, even if we said that races can occur, I have no easy
> way to know, from user-space, whether the last thing that occurred was
> the Wi-Fi card waking the machine up or the power button being pressed.


Again, I think you just want to know if the power button (or lid
trigger) was pressed. Not if it was the cause for resume (since a
wake-on-lan or alarm could fire right as the user presses the power
button). If those button presses don't reliably get communicated, I
think that's a better problem to solve in the kernel.

Again, part of the reason I'm pushing back here, is that there may be
a lot of things going on on a system, and systems may suspend and
resume quite often while being in use, so applications really should
handle events consistently weather the system was suspended or not
(another lesson from android: suspend blocking is a more flexible
approach then having applications initiate suspend, since you avoid
all the races of multiple applications trying to manage initiating
suspend state).

But the other part of why I'm pushing back is that on future hardware,
we may not have a "suspend" mode, and systems may just be in a deep
idle, with selected interrupts disabled (event filtering, in other
words). So I think its better if you design around events (button
presses, lid triggers, mouse movements, timers firing), rather then
specific system suspend state.


>> Sure. But its not reliably suspending I'm worried about, its
>> accidentally resuming in an environment the hardware wasn't designed
>> for. Its really more of a hardware design issue. I'm not suggesting
>> you don't do it, but I just suspect you'll need to be careful about
>> automatically enabling this on older hardware.
>
> It could be opt-in if that's actually a problem.

Yea. And again,I don't mean to throw water on the idea, I just wanted
to make sure considerations were being made. Its good folks are
working to keep function/feature parity with other modern desktop
OSes, but quite often those OSes aren't expected to run on the same
variety of hardware. So finding a way to detect safe hardware-designs
would be useful for your effort.

thanks
-john
