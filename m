Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760807AbaJ3Rlk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 13:41:40 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53614 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760674AbaJ3Rlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 13:41:37 -0400
Date: Thu, 30 Oct 2014 18:41:35 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Bastien Nocera <hadess@hadess.net>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andy Lutomirski <luto@amacapital.net>,
        John Stultz <john.stultz@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: A desktop environment[1] kernel wishlist
Message-ID: <20141030174135.GA13814@amd>
References: <CALAqxLURBHdrprCZzUiXdO6M7sjbwawxyDQpoG1-HWRGBvaMjg@mail.gmail.com>
 <1413914978.30379.14.camel@hadess.net>
 <20141027092804.GB9807@amd>
 <1414420292.30379.55.camel@hadess.net>
 <54513DDC.2020700@amacapital.net>
 <20141029202616.GC5000@thunk.org>
 <20141029211608.GA32576@amd>
 <1414680302.2406.55.camel@hadess.net>
 <20141030150501.GD31927@thunk.org>
 <1414682115.2406.59.camel@hadess.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414682115.2406.59.camel@hadess.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2014-10-30 16:15:15, Bastien Nocera wrote:
> On Thu, 2014-10-30 at 11:05 -0400, Theodore Ts'o wrote:
> > On Thu, Oct 30, 2014 at 03:45:02PM +0100, Bastien Nocera wrote:
> > > > Actually Maemo people (on Nokia N900 and friends) got it right: unlike
> > > > android devices, it does not suspend to RAM at any point, and still
> > > > has reasonable battery life.
> > > 
> > > Android devices don't suspend to RAM. Neither do Tizen devices AFAIK.
> > 
> > Actually, Android devices have historically always suspended the CPU
> > whenever there wasn't a wakelock keeping the device to suspend.  You
> > might not consider this "suspend to RAM" but in fact it uses the
> > identical kernel and hardware facilities as the legacy "suspend to
> > RAM" mechanism.
> 
> I wouldn't consider this "suspend to RAM", but that's because I expect
> the firmware to implement most of that. Anyway, that's splitting
> hair.

Could you rephrase that?

Anyway, this is "echo mem > /sys/power/state" or
suspend-to-RAM. Android does the same, with more tricky wakeup logic. 

> > > I don't think anyone was discussing cell phones in particular in this
> > > thread, and knowing when user-space got woken up because of the baseband
> > > processor having information for us would still be useful.
> > 
> > It matters because for laptops, what's important is whether the lid is
> > closed or not.  Whether and how the laptop was "woken" is really
> > beside the point, as others have argued.  Your counter argument is
> > that tablets don't have lids.  But tablets are going to be using
> > schemes similar to Android, Tizen, and Maemo, and they are *not* going
> > to be using the legacy suspend-to-RAM model, because it's not
> > sufficiently good at power saving.
> 
> There are plenty of tablets around that aren't Android devices. There
> are plenty of laptops that can be switched to a tablet mode for which
> this wouldn't apply either.

Yes, still the right question is "was the power button pressed while
userland was suspended" not "was the system woken by power
button"... and yes, I guess kernel should add the "power button" event
to the input queue, even if that press was used to wake up the system.

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
