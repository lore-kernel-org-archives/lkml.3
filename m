Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933292AbaJUROn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 13:14:43 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:34002 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932570AbaJUROm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 13:14:42 -0400
X-Originating-IP: 83.155.44.161
Message-ID: <1413911644.30379.12.camel@hadess.net>
Subject: Re: A desktop environment[1] kernel wishlist
From: Bastien Nocera <hadess@hadess.net>
To: John Stultz <john.stultz@linaro.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 21 Oct 2014 19:14:04 +0200
In-Reply-To: <CANcMJZA=7FNNCrMpz-mC4FaJMKi8hEhqGtO_bv7iJdWVC_GpWA@mail.gmail.com>
References: <1413881397.30379.7.camel@hadess.net>
	 <CANcMJZA=7FNNCrMpz-mC4FaJMKi8hEhqGtO_bv7iJdWVC_GpWA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7 (3.12.7-1.fc21) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Tue, 2014-10-21 at 10:04 -0700, John Stultz wrote:
> On Tue, Oct 21, 2014 at 1:49 AM, Bastien Nocera <hadess@hadess.net> wrote:
> > Hey,
> >
> > GNOME has had discussions with kernel developers in the past, and,
> > fortunately, in some cases we were able to make headway.
> >
> > There are however a number of items that we still don't have solutions
> > for, items that kernel developers might not realise we'd like to rely
> > on, or don't know that we'd make use of if merged.
> >
> > I've posted this list at:
> > https://wiki.gnome.org/BastienNocera/KernelWishlist
> >
> > Let me know on-list or off-list if you have any comments about those, so
> > I can update the list.
> 
> As for: 'Export of "wake reason" when the system wakes up (rtc alarm,
> lid open, etc.) and wakealarm (/sys/class/rtc/foo/wakealarm)
> documentation'
> 
> Can you expand more on the rational for the need here? Is this for UI
> for power debugging, or something else?

No, it would be used for automating backups, or implementing
suspend->hibernation transitions. For example, right before the machine
suspends, I would schedule it to wake up in a hour. If I get woken up by
the rtc alarm (and not by the user through a lid open), I might:
- check that I'm plugged into the AC, it's night, and in the vicinity of
the server that handles my backups and so backup the system.
- check whether the battery is low, and hibernate the machine (if it
supports it, obviously).

We cannot do that if we can't make out whether the wake-up came from a
user action, or the alarm we set.

Cheers

