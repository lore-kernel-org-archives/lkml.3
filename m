Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab3KNSSw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 13:18:52 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:55994 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755049Ab3KNSSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 13:18:47 -0500
Date: Thu, 14 Nov 2013 10:18:45 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Laszlo Papp <lpapp@kde.org>
Cc: hjk@hansjkoch.de, lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwmon: (max6650) Add support for gpiodef
Message-ID: <20131114181845.GA13727@roeck-us.net>
References: <1384440661-3769-1-git-send-email-lpapp@kde.org>
 <20131114172427.GA11062@roeck-us.net>
 <CAOMwXhNdo8aRGH9AL+JxYnDg2zAN4+-TeHJU=Kc1kDKmyYuYmA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMwXhNdo8aRGH9AL+JxYnDg2zAN4+-TeHJU=Kc1kDKmyYuYmA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 06:13:45PM +0000, Laszlo Papp wrote:
> On Thu, Nov 14, 2013 at 5:24 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> 
> > On Thu, Nov 14, 2013 at 02:51:01PM +0000, Laszlo Papp wrote:
> > > It is necessary for end users when they are using the gpio pins
> > connected to the
> > > fan controller. There is a separate gpiodef register provided, but it is
> > unused
> > > under the usual circumstances and that is probably the reason why this
> > feature
> > > has not been added before. It is necessary for our board to function
> > properly.
> > >
> > > Signed-off-by: Laszlo Papp <lpapp@kde.org>
> > > ---
> > >  Documentation/hwmon/max6650 |   5 +++
> > >  drivers/hwmon/max6650.c     | 107
> > ++++++++++++++++++++++++++++++++++++++++++++
> > >  2 files changed, 112 insertions(+)
> > >
> > > diff --git a/Documentation/hwmon/max6650 b/Documentation/hwmon/max6650
> > > index 58d9644..32c69a8 100644
> > > --- a/Documentation/hwmon/max6650
> > > +++ b/Documentation/hwmon/max6650
> > > @@ -39,6 +39,11 @@ pwm1               rw      relative speed (0-255),
> > 255=max. speed.
> > >  fan1_div     rw      sets the speed range the inputs can handle. Legal
> > >                       values are 1, 2, 4, and 8. Use lower values for
> > >                       faster fans.
> > > +gpio0        rw      sets the gpio 0 PIN. Legal values are 0, 1, 2, and
> > 3.
> > > +gpio1        rw      sets the gpio 1 PIN. Legal values are 0, 1, 2, and
> > 3.
> > > +gpio2        rw      sets the gpio 2 PIN. Legal values are 0, 1, 2, and
> > 3.
> > > +gpio3        rw      sets the gpio 3 PIN. Legal values are 0, and 1.
> > > +gpio4        rw      sets the gpio 4 PIN. Legal values are 0, and 1.
> > >
> > gpio pins should be exported through the gpio subsystem, usually with a
> > gpio
> > driver. In this case, it may be acceptable to have the driver register with
> > the gpio subsystem to export the pins. Using local sysfs attributes is
> > wrong
> > and unacceptable.
> >
> 
> In short: I am not sure.
> 
> My concern is that these are not generic gpio pins. They seem to have chip
> specific functionality, like alarm, full-on, and clock (internal and
> external). Strictly speaking, one could even mention that to expose the
> GPIODEF register as is without splitting it into five separate gpio pin
> entries. Even those five pins behave slightly differently.
> 
> I considered both, but these are the reasons why I decided to keep it chip
> specific rather than separately in a generic subsystem.
> 
If the registers are not really gpio pins but are needed / used for chip
configuration, the other option would be to configure the values using platform
data and/or devicetree data. Either case, exporting the pins to user space via
sysfs attribute files in the device directory is the wrong approach.

Guenter
