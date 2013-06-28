Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523Ab3F1KXt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 06:23:49 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:54543 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779Ab3F1KXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 06:23:47 -0400
Date: Fri, 28 Jun 2013 12:23:33 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Anders Hammarquist <iko@iko.pp.se>
Cc: Johan Hovold <jhovold@gmail.com>, Greg KH <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 0/2] *** SUBJECT HERE ***
Message-ID: <20130628102333.GA13241@localhost>
References: <201306190012.r5J0CNJZ031854@eskarina.iko.pp.se>
 <20130619225315.GB12282@kroah.com>
 <201306212308.r5LN8C7M020720@eskarina.iko.pp.se>
 <20130621235603.GA1603@kroah.com>
 <201306221854.r5MIshv5013882@eskarina.iko.pp.se>
 <20130625233911.GA1087@kroah.com>
 <201306260829.r5Q8Txm5003881@eskarina.iko.pp.se>
 <20130626103924.GA30828@localhost>
 <201306272150.r5RLoq2u006119@eskarina.iko.pp.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201306272150.r5RLoq2u006119@eskarina.iko.pp.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 11:50:52PM +0200, Anders Hammarquist wrote:
> In a message of Wed, 26 Jun 2013 12:39:24 +0200, Johan Hovold writes:
> >On Wed, Jun 26, 2013 at 10:29:59AM +0200, Anders Hammarquist wrote:
> >> In a message of Tue, 25 Jun 2013 16:39:11 -0700, Greg KH writes:
> >> >> Indeed. I'd already had some (failed) thoughts about how to handle it
> >> >> nicely. Now I've had another think through, and I have something which
> >> >> deals with it and at least complains if TI_EXTRA_VID_PID_COUNT is changed
> >> >> without changing the initializer. Patch 2/2
> >> >
> >> >Why don't we just drop the extra id thing entirely?  The usb-serial
> >> >subsystem handles new device ids being added dynamically from sysfs for
> >> >a long time now.  Removing this module option would clean up the code a
> >> >lot, and prevent these errors from ever happening again.
> >> 
> >> Aha, yes, I'm all for that (had I only known I'd have done that to start
> >> with). I'll look in to it.
> >
> >I already have a few patches here (part of a larger 3.11 clean-up series)
> >which removes the vid/pid module parameters from all usb-serial modules
> >including ti_usb_3410_5052.
> >
> >I hope to be able to submit the whole series a later tonight, but here's
> >the ti_usb_3410_5052 part if anyone's interested.
> 
> I did a quick check of adding the device id though sysfs, and although
> it partly works, it doesn't find the correct firmware (it ends up trying
> to load 5052 firmware for a 3410 device. Looking at the code it seems
> (struct ti_device) td_is_3410 isn't set properly.)

Turns out that the drivers device-type detection has never worked with
the dynamic id interface (all devices were detected as 2-port devices).

I'm responding to this mail with a fix. Care to give it a try?

Thanks,
Johan
