Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884Ab3LRL7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 06:59:19 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:37877 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474Ab3LRL7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 06:59:18 -0500
Date: Wed, 18 Dec 2013 11:59:13 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Laszlo Papp <lpapp@kde.org>
Cc: sameo@linux.intel.com, LKML <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: Simple MFD driver example
Message-ID: <20131218115913.GG14274@lee--X1>
References: <20131216150514.GN18769@lee--X1>
 <CAOMwXhMn5W76Dp=EFNHaknXCqZ4q4e7fphgtttx+8U=1Fc_DMQ@mail.gmail.com>
 <20131216164844.GS18769@lee--X1>
 <CAOMwXhPLNVKbRqR2tPQc758zLsh0Lg0D6JUf2yrf+ZosJVANAw@mail.gmail.com>
 <20131218091609.GB14274@lee--X1>
 <CAOMwXhOSpnEiDoyXNPmy0Gt1tLiwdzGRqoseKqtAUogLEfkCZQ@mail.gmail.com>
 <20131218111232.GE14274@lee--X1>
 <CAOMwXhNMrnLEDUHrPqH1rgbFDgNPWmhCr2dPUNhdhfmdPTcGfg@mail.gmail.com>
 <20131218113449.GF14274@lee--X1>
 <CAOMwXhNEcHgObYPYCXrb_4FiDYBVhK1HQuKEj40jittgrcvJfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOMwXhNEcHgObYPYCXrb_4FiDYBVhK1HQuKEj40jittgrcvJfw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Dec 2013, Laszlo Papp wrote:

> On Wed, Dec 18, 2013 at 11:34 AM, Lee Jones <lee.jones@linaro.org> wrote:
> >> >> What you eventually see in hwmon is only a subset of all the features
> >> >> the IC provides. You may want to read this thread:
> >> >> https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg536509.html
> >> >
> >> > Okay, so the best thing to do is send out the entire patch-set at
> >> > once, CC'ing each of the maintainers on every patch so we can all see
> >> > how this thing fits together.
> >>
> >> Well, I am not even sure currently where to head with the MFD bits and
> >> its children subdevices currently....
> >>
> >> I would appreciate any direction. Yesterday, I was told on IRC, I
> >> would need to switch from i2c to platform drivers for the hwmon and
> >> gpio parts, but looking at some existing mfd driver code and their
> >> children drivers, I do not see it like that.
> >>
> >> I have already sent out the gpio driver yesterday which works fine on
> >> its own: http://www.spinics.net/lists/kernel/msg1655805.html
> >
> > This is going to need a lot of work.
> >
> > Did you run the patch through `./scripts/checkpatch.pl` before
> > submitting?
> 
> Of course, there has been zero errors and warnings. Eventually, I even
> ran the Lindent. Actual feedback is welcome for sure.

I barely have enough time to review my own subsystem, let alone
others. Linus will do a great job in this regard.

> >> Could you please guide me into the right direction what I need to
> >> change once we have standalone drivers, and they should be glued
> >> together? I thought adding an abstraction with the mfd layer would be
> >> sufficient, but apparently, that is not enough.
> >>
> >> Practically speaking, I am confused since if I needed to change the
> >> existing drivers, that means I could potentially break the interface
> >> for the existing users if the drivers stop working on their own, but
> >> then again, I am such a newbie that I would greatly appreciate some
> >> pointers.
> >
> > The MFD subsystem is quite simple to use. I'm taken aback that this is
> > your major stumbling block. Read though the mfd_add_device(s)() calls
> > to see what it expects. The rest is childs play.
> 
> Yeah, I have taken, but that does not still explain the consistency I
> mentioned above. Some children do not conform the "platform" driver
> suggestion I was told.
> 
> Also, what about the actual MFD code submitted? Anything to modify in
> there? Could you please comment on that, or is the direction of it
> good enough for me to submit it as a real patch at this stage?

Submit them all as I requested before and we will do a proper review.

Copy and pasting patches into conversation emails isn't the correct
method to use.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
