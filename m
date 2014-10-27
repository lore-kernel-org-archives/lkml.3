Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607AbaJ0Ppx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 11:45:53 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:52689 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbaJ0Pp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 11:45:27 -0400
X-Originating-IP: 83.155.44.161
Message-ID: <1414424673.30379.58.camel@hadess.net>
Subject: Re: A desktop environment[1] kernel wishlist
From: Bastien Nocera <hadess@hadess.net>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 27 Oct 2014 16:44:33 +0100
In-Reply-To: <CAMuHMdWG=ayxEAno2VYMK=fvf8Brx4rFMc75WOSh2PPLntaa8w@mail.gmail.com>
References: <1413881397.30379.7.camel@hadess.net>
	 <CANcMJZA=7FNNCrMpz-mC4FaJMKi8hEhqGtO_bv7iJdWVC_GpWA@mail.gmail.com>
	 <1413911644.30379.12.camel@hadess.net>
	 <CAMuHMdWw+rX-r2uVN0ZL-GFirOkCn7+Gh7BVd3JvyXXS_pcdVw@mail.gmail.com>
	 <1414419657.30379.51.camel@hadess.net>
	 <CAMuHMdWG=ayxEAno2VYMK=fvf8Brx4rFMc75WOSh2PPLntaa8w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7 (3.12.7-1.fc21) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-27 at 16:31 +0100, Geert Uytterhoeven wrote:
> Hi Bastien,
> 
> On Mon, Oct 27, 2014 at 3:20 PM, Bastien Nocera <hadess@hadess.net> wrote:
> > On Tue, 2014-10-21 at 20:24 +0200, Geert Uytterhoeven wrote:
> >> On Tue, Oct 21, 2014 at 7:14 PM, Bastien Nocera <hadess@hadess.net> wrote:
> >> >> As for: 'Export of "wake reason" when the system wakes up (rtc alarm,
> >> >> lid open, etc.) and wakealarm (/sys/class/rtc/foo/wakealarm)
> >> >> documentation'
> >> >>
> >> >> Can you expand more on the rational for the need here? Is this for UI
> >> >> for power debugging, or something else?
> >> >
> >> > No, it would be used for automating backups, or implementing
> >> > suspend->hibernation transitions. For example, right before the machine
> >> > suspends, I would schedule it to wake up in a hour. If I get woken up by
> >> > the rtc alarm (and not by the user through a lid open), I might:
> >> > - check that I'm plugged into the AC, it's night, and in the vicinity of
> >> > the server that handles my backups and so backup the system.
> >> > - check whether the battery is low, and hibernate the machine (if it
> >> > supports it, obviously).
> >>
> >> Isn't this already available through /sys/kernel/debug/wakeup_sources
> >> and/or the various power/wake* files in sysfs?
> >
> > That might very well be, but /sys/kernel/debug/wakeup_sources really
> > isn't much of a user-space API. Where's the documentation for the
> > various power/wake* files?
> 
> The debugfs entry is indeed not documented.
> Documentation for the others is just a git grep away:

Fair enough, but apart from tallying up wakeup_count by hand, I'm not
sure how I'm supposed to interface with that.

It also doesn't fix the problem of knowing which event caused a wakeup
(or when the last event occurred on a particular device) when this
device can have multiple different reasons to wake up (see the
WOL/connected suspend mentions earlier in the thread).

