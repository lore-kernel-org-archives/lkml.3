Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbaJ1LhU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:37:20 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:38597 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbaJ1LhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:37:17 -0400
X-Originating-IP: 83.155.44.161
Message-ID: <1414499805.2406.6.camel@hadess.net>
Subject: Re: A desktop environment[1] kernel wishlist
From: Bastien Nocera <hadess@hadess.net>
To: Zygo Blaxell <zblaxell@furryterror.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 28 Oct 2014 13:36:45 +0100
In-Reply-To: <20141027205936.GE17380@hungrycats.org>
References: <1413881397.30379.7.camel@hadess.net>
	 <CANcMJZA=7FNNCrMpz-mC4FaJMKi8hEhqGtO_bv7iJdWVC_GpWA@mail.gmail.com>
	 <1413911644.30379.12.camel@hadess.net>
	 <CALAqxLURBHdrprCZzUiXdO6M7sjbwawxyDQpoG1-HWRGBvaMjg@mail.gmail.com>
	 <1413914978.30379.14.camel@hadess.net>
	 <20141022170433.GA10186@hungrycats.org>
	 <1414420084.30379.53.camel@hadess.net>
	 <20141027205936.GE17380@hungrycats.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7 (3.12.7-1.fc21) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-27 at 16:59 -0400, Zygo Blaxell wrote:
> On Mon, Oct 27, 2014 at 03:28:04PM +0100, Bastien Nocera wrote:
> > On Wed, 2014-10-22 at 13:04 -0400, Zygo Blaxell wrote:
> > > On Tue, Oct 21, 2014 at 08:09:38PM +0200, Bastien Nocera wrote:
> > > > On Tue, 2014-10-21 at 11:00 -0700, John Stultz wrote:
> > > > > On Tue, Oct 21, 2014 at 10:14 AM, Bastien Nocera <hadess@hadess.net> wrote:
> > > > > >> As for: 'Export of "wake reason" when the system wakes up (rtc alarm,
> > > > > >> lid open, etc.) and wakealarm (/sys/class/rtc/foo/wakealarm)
> > > > > >> documentation'
> > > > > >>
> > > > > >> Can you expand more on the rational for the need here? Is this for UI
> > > > > >> for power debugging, or something else?
> > > > > >
> > > > > > No, it would be used for automating backups, or implementing
> > > > > > suspend->hibernation transitions. For example, right before the machine
> > > > > > suspends, I would schedule it to wake up in a hour. If I get woken up by
> > > > > > the rtc alarm (and not by the user through a lid open), I might:
> > > > > > - check that I'm plugged into the AC, it's night, and in the vicinity of
> > > > > > the server that handles my backups and so backup the system.
> > > > > > - check whether the battery is low, and hibernate the machine (if it
> > > > > > supports it, obviously).
> > > > > >
> > > > > > We cannot do that if we can't make out whether the wake-up came from a
> > > > > > user action, or the alarm we set.
> > > > > 
> > > > > I suspect wakeup type reporting is maybe not the best way to go about
> > > > > this, since there may be a number of causes for wakeups and they can
> > > > > arrive closely together in different orders, which can result in
> > > > > races.
> > > > > 
> > > > > For instance, if the machine suspends, and sets an alarm to be woken
> > > > > up at midnight to do a backup, if the user resumes their laptop at
> > > > > 11:59:59, should the backup still proceed at midnight?
> > > > 
> > > > No. And I would expect that we would get a wake up type of "power
> > > > button" or "lid open" in this case.
> > > 
> > > I have been using something like this for the last 7 years or so.
> > > The relevant inputs are:
> > > 
> > > 	1. is the user present (is there recent input on HID devices,
> > > 	keyboard/mouse, but ignore devices like light sensors, 3D
> > > 	accelerometers, and ACPI virtual keys)?
> > 
> > If the user woke the machine up through the power button, you wouldn't
> > see that from user-space. You could detect that the lid was opened,
> > because you have state.
> > 
> > > 	2. which network connection(s) are available to reach the
> > > 	backup server?
> > > 
> > > 	3. how much power is available (if on battery, how much run
> > > 	time left?)
> > > 
> > > 	4. what is the policy (do backups happen at a specific time
> > > 	of day, or whenever they can?)
> > > 
> > > 	5. was a backup completed successfully in the last N hours?
> > > 
> > > Note the absence of any information about the cause of recent
> > > suspend/resume activity, or any input from suspend/resume at all.
> > 
> > How do I tell my environment not to wake the screen up when the machine
> > was woken up by an alarm I scheduled to launch a backup? 
> 
> Lid closed?  Screen off (nobody can see it, it wastes power on battery,
> and lengthens charge time on AC).
> 
> Lid open and user input?  Screen on.
> 
> Lid open and user disabled time-based screen power saving?  Screen on.
> 
> These are not symmetrical.  To wake up the screen, the screen needs to
> be visible, and the policy conditions to wake up the screen need to be
> met.  Spontaneously firing up a backlight at full power in a dark room
> in the middle of the night may not be appreciated by the system owner.

How do I detect that the screen is visible on a tablet? I could turn on
the webcam to see if a face is detected ;)

Maybe the wake-up reason isn't good enough on its own, but how do I know
which one the possible wake-up reasons was the last one to trigger?

