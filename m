Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805AbaGPXXd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 19:23:33 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:34113 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbaGPXX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 19:23:28 -0400
X-Originating-IP: 83.155.44.161
Message-ID: <1405553002.17757.7.camel@nuvo>
Subject: Re: Power-managing devices that are not of interest at some point
 in time
From: Bastien Nocera <hadess@hadess.net>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Patrik Fimml <patrikf@chromium.org>, linux-pm@vger.kernel.org,
        Dmitry Torokhov <dtor@google.com>, Benson Leung <bleung@google.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 17 Jul 2014 01:23:22 +0200
In-Reply-To: <1463038.d2xocpRFLY@vostro.rjw.lan>
References: <20140716013206.GA13409@google.com>
	 <5611777.bNi5p029gt@vostro.rjw.lan> <1405552422.17757.5.camel@nuvo>
	 <1463038.d2xocpRFLY@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.3 (3.12.3-3.fc21) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-07-17 at 01:33 +0200, Rafael J. Wysocki wrote:
> On Thursday, July 17, 2014 01:13:42 AM Bastien Nocera wrote:
> > On Thu, 2014-07-17 at 01:11 +0200, Rafael J. Wysocki wrote:
> > > On Tuesday, July 15, 2014 06:32:06 PM Patrik Fimml wrote:
> > > > (Re-sending with correct mailing list addresses.)
> > > > 
> > > > Hi,
> > > > 
> > > > When the lid of a laptop is closed, certain devices can no longer
> > > > provide interesting input or will even produce bogus input, such as:
> > > > 
> > > > - input devices: touchscreen, touchpad, keyboard
> > > > - sensors: ambient light sensor, accelerometer, magnetometer
> > > > - a video camera mounted on the lid
> > > > - display backlight
> > > > 
> > > > Various workarounds cover some of these cases, and we have some ugly
> > > > hacks in ChromeOS to make things work. It would be nice if a userspace
> > > > power management daemon could listen to the lid-close event, and then
> > > > have a way to temporarily power off these devices, potentially through
> > > > sysfs.
> > > > 
> > > > I've been discussing this with Dmitry and Benson (cc'd), and we've been
> > > > wondering whether we could come up with a generic solution that could
> > > > benefit multiple device classes.
> > > > 
> > > > There's some overlap with runtime PM here. The action to be taken in
> > > > such a situation would probably be similar to a runtime suspend. The
> > > > match is not perfect though, since devices with more than two power
> > > > states might want to enter different states depending on the situation.
> > > > 
> > > > It's somewhat difficult to get the semantics right, since handles to
> > > > such devices might still be open. It might be easier to implement
> > > > behavior specific to device classes. On the other hand, it would be nice
> > > > to have a uniform way of shutting devices down, and not introduce
> > > > another possible path for a device to enter a power-saving state.
> > > > 
> > > > Rafael, can you give us your opinion on this?
> > > 
> > > Let me try to understand the scenario in the first place.
> > > 
> > > To start with, a number of devices is in use (that is, open, there are
> > > applications listening/talking to them etc).  Now, an event happens, such
> > > as a laptop lid close and you want some of those devices, but possibly
> > > not all of them, to quiesce themselves and go into low-power states.
> > > 
> > > Is that correct?
<snip>
> Well, is the scenario I described correct or not?  If not, then what
> exactly is the scenario you want to be able to handle?

I don't expect devices to have to know about the lid status, no. Patrik
might feel differently, but I think that all that's being asked is
already possible through existing user-space mechanisms, it's just
missing metadata to be able to implement it.

