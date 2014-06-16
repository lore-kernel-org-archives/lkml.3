Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241AbaFPHpq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 03:45:46 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:46910 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbaFPHpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 03:45:44 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Mon, 16 Jun 2014 09:45:03 +0200
From: Johan Hovold <johan@kernel.org>
To: Janne Kanniainen <janne.kanniainen@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, Jiri Kosina <jkosina@suse.cz>,
        Johan Hovold <johan@kernel.org>, Bryan Wu <cooloney@gmail.com>,
        linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH v5] leds: USB: HID: Add support for MSI GT683R led panels
Message-ID: <20140616074503.GB20636@localhost>
References: <20140612090636.GK10256@localhost>
 <1402605252-9620-1-git-send-email-janne.kanniainen@gmail.com>
 <20140614224222.GE1389@xo-6d-61-c0.localdomain>
 <CAEEjW04wA3PT2=oE4Z=tP-RWkmyiWpM5NzCH5Owwh8vCRbqMTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEEjW04wA3PT2=oE4Z=tP-RWkmyiWpM5NzCH5Owwh8vCRbqMTA@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 15, 2014 at 02:23:25AM +0300, Janne Kanniainen wrote:
> > Hi!
> 
> Hi.
> 
> >> --- /dev/null
> >> +++ b/Documentation/ABI/testing/sysfs-class-hid-driver-gt683r
> >> @@ -0,0 +1,10 @@
> >> +What:                /sys/class/hidraw/<hidraw>/device/state
> >> +Date:                Jun 2014
> >> +KernelVersion:       3.15
> >> +Contact:     Janne Kanniainen <janne.kanniainen@gmail.com>
> >> +Description:
> >> +             Set the mode of LEDs
> >> +
> >> +             0 - normal
> >> +             1 - audio
> >> +             2 - breathing
> >
> > THat's some strange interface. Don't we normally use led triggers
> > for this?
> 
> I can implement it that way, if you all think that it is correct way.
> What do Jiri and Johan thinks of it?
> 
> > And the mode of the LED should really be in /sys/class/leds, not in
> > hidraw somewhere...
> 
> The problem is that all panels can only be in one mode at the time.
> For example front panel can't be in breathing mode while side panel is
> in normal mode.

As Janne explained above, it's really an attribute of the parent device
and not the individual LEDs. The latter could still use the software
timer trigger to blink independently.

Johan
