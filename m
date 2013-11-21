Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716Ab3KURfC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 12:35:02 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:49675 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057Ab3KURfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 12:35:00 -0500
Date: Thu, 21 Nov 2013 09:34:58 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Laszlo Papp <lpapp@kde.org>
Cc: Marcus Folkesson <marcus.folkesson@gmail.com>, hjk@hansjkoch.de,
        linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH] hwmon: (max6650) Add support for gpiodef
Message-ID: <20131121173458.GC10783@roeck-us.net>
References: <20131114181845.GA13727@roeck-us.net>
 <CAOMwXhNaZ=oqp5mjnCrOSkdax5U6ffsZf_p4mzd3W2jF+=xWqg@mail.gmail.com>
 <20131114190044.GE13727@roeck-us.net>
 <CAOMwXhPvPnprrJx-1dfJnO+E12sxAE9M_sYg7tyzp4dsDa8vyg@mail.gmail.com>
 <CAJ4dqQu0=HP=Ut+VnNjkSL2cE8QN+JRa-Xd8X01ij+ijKUKxwA@mail.gmail.com>
 <CAOMwXhM1Xi=UqpmKNDsOnQLXKo1o+65TZi6AkBk4Ds9wuXSaWQ@mail.gmail.com>
 <20131119165438.GD30481@roeck-us.net>
 <20131119180007.GB16693@roeck-us.net>
 <CAOMwXhOTRVu1EMSNE_muKKfSYBFQ1XVq1EQEL2d+wCwRJ0tkpw@mail.gmail.com>
 <CAOMwXhN8tZej9=65wyGvsnm64igiLLN6vdsiGaePCozKBs8J7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMwXhN8tZej9=65wyGvsnm64igiLLN6vdsiGaePCozKBs8J7Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 03:20:34PM +0000, Laszlo Papp wrote:
> One week passed since the initial submit. Any feedback from the
> maintainer who accepts patches for this?
> 
Last time I checked that was either Jean Delvare or me.

As I already told you, I won't accept the patch as-is,
and I told you what would need to be changed to have it accepted.

In general, we don't support adding non-standard sysfs attributes in hwmon
drivers unless really needed and discussed. As I see it, there is no need
for non-standard sysfs attributes in this driver; you _could_ use
the gpio subsystem. You chose not to and provide non-standard sysfs
attributes instead, essentially duplicating gpio subsystem functionality.

I see it as even more important to use the gpio subsystem for the intended use
case, which is to use gpio pins for fan control. In that case, providing access
through the gpio subsystem would enable using the gpio-fan driver to actually
control the fans.

You may consider that to be personal taste nitpicking. I don't.

Guenter

> On Tue, Nov 19, 2013 at 7:43 PM, Laszlo Papp <lpapp@kde.org> wrote:
> > On Tue, Nov 19, 2013 at 6:00 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> >> On Tue, Nov 19, 2013 at 08:54:38AM -0800, Guenter Roeck wrote:
> >>> On Tue, Nov 19, 2013 at 04:42:49PM +0000, Laszlo Papp wrote:
> >>> > On Fri, Nov 15, 2013 at 7:52 PM, Marcus Folkesson
> >>> > <marcus.folkesson@gmail.com> wrote:
> >>> > >
> >>> > >> This is just one use case of those, you could also use it for
> >>> > >> non-generic gpio functionality, like alarm, "full-on", internal clock,
> >>> > >> external clock, etc. I believe it is always a bit tricky with MFD. I
> >>> > >> personally prefer to put it into the chip driver because this is not
> >>> > >> clearly a generic gpio interface here, and I need to drive it
> >>> > >> dynamically.
> >>> > >
> >>> > > I agree.
> >>> > >
> >>> > > I think the solution with expose the "GPIOs" in sysfs is the right way to
> >>> > > go.
> >>> > > The chip-function is of a dynamic nature and should therefor not be set in
> >>> > > platform data / devicetree.
> >>> > >
> >>> > > As mentioned before, GPIOs should use the gpio subsystem whenever possible,
> >>> > > but the the gpio-functionality is just a subset of
> >>> > > functions these pins may be set to.
> >>> > >
> >>> > > Also, the I think the *real* reason why the entries is called "gpio" is that
> >>> > > it is so the registers are are mentioned in the datasheet.
> >>> > > Everyone that is working with the device will know what it is all about.
> >>> > > I see it more as an register expose than a gpio interface...
> >>> > >
> >>> > > I agree that the entries does not really fit here. But they does not fit
> >>> > > better elsewhere either.
> >>> > > And I don't think they fit worse than the alarm-entries that is already in
> >>> > > mainline.
> >>> > >
> >>> > > Anyway, I think the documentation file should mention what function each
> >>> > > valid value represent.
> >>> >
> >>> > Yes, makes sense to make the documentation more comprehensive. Thanks.
> >>> >
> >>> > Any other issues from anyone before submitting a polished version?
> >>> >
> >>> You'll have to get feedback from Jean. I won't accept the patch.
> >>>
> >> To add to this: The datasheet clearly states that the pins are GPIO pins,
> >> three of which can be configured as ALERT output, ALL_ON input, or clock
> >> input/output.
> >
> > Which is inline with what we wrote before. Although, you probably
> > meant FULL_ON rather than ALL_ON. There is no "ALL_ON" in this
> > context.
> >
> >> GPIO pins should be made available to the kernel through
> >> the GPIO subsystem; any clock configuration should be configured through the
> >> clock subsystem if needed.
> >
> > I believe we will agree to disagree there. I find it more convenient
> > (along with Markus, etc) to have clearly chip specific feature
> > available for the chip in one place - especially when that follows the
> > consistency - rather than distributed in several sub-spaces. Not that
> > this is only a minor feature. Splitting them into even tinier is
> > strange in my opinion.
> >
> >> The pin configuration as ALERT output/ALL_ON
> >> input/clock is clearly board specific and should thus be provided as
> >> platform data and/or devicetree data if needed.
> >
> > That is still static, not dynamic, hence inappropriate for the use case at hand.
> >
> >> The existing GPIO alarm attributes should be removed. The pin values should be
> >> reported as GPIO pin values instead.
> >
> > Feel free to provide a change for review if you wish.
> >
> > I would like to note that I am not planning to rewrite an already
> > existing and tested feature as of now. Not sure if I could find the
> > motivation and time for doing that any soon. To me, it only looks
> > personal taste nitpicking so far, and the feature would be more
> > important to me. There are pro/cons for both sides, but if this
> > feature cannot get it in with this design, there might be no feature
> > like this for the posterity.
> >
> > So unless there are good arguments with modulo critical answers why it
> > is unacceptably wrong as is for now, let us drop this change in
> > upstream, then.
> 
