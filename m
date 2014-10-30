Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760251AbaJ3Olp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 10:41:45 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:50272 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759934AbaJ3Olo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 10:41:44 -0400
X-Originating-IP: 83.155.44.161
Message-ID: <1414680060.2406.51.camel@hadess.net>
Subject: Re: A desktop environment[1] kernel wishlist
From: Bastien Nocera <hadess@hadess.net>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: John Stultz <john.stultz@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 30 Oct 2014 15:41:00 +0100
In-Reply-To: <20141028225740.2cd0ea5f@alan.etchedpixels.co.uk>
References: <1413881397.30379.7.camel@hadess.net>
	 <CANcMJZA=7FNNCrMpz-mC4FaJMKi8hEhqGtO_bv7iJdWVC_GpWA@mail.gmail.com>
	 <1413911644.30379.12.camel@hadess.net>
	 <CALAqxLURBHdrprCZzUiXdO6M7sjbwawxyDQpoG1-HWRGBvaMjg@mail.gmail.com>
	 <1413914978.30379.14.camel@hadess.net>
	 <CALAqxLX2Q-2RBF1zY6JAWrqNiqBFG3vxUwUSLVS3qXpgSOb9xA@mail.gmail.com>
	 <1414419579.30379.49.camel@hadess.net>
	 <CALAqxLXyaL55JuDuHAcWX0PEdem-jpVxK0rbJaNrBbBJ3rQY5Q@mail.gmail.com>
	 <20141028225740.2cd0ea5f@alan.etchedpixels.co.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7 (3.12.7-1.fc21) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-28 at 22:57 +0000, One Thousand Gnomes wrote:
> > If the firmware eats that button (which I hope it wouldn't, but I
> > probably should know better then to expect sane behavior), how does
> > the kernel know anything more?
> 
> The firmware is generally going to do whatever it believes is "correct",
> which may nor may not be determined by what the hardware itself does
> (if wakeup is a GPIO off the controller then it'll be determined by the
> widget the other end what is eaten)
>  
> > button). If those button presses don't reliably get communicated, I
> > think that's a better problem to solve in the kernel.
> 
> You'd have to solve it in the firmware.

Not if the kernel can tell us that the event occurred and when.

> > But the other part of why I'm pushing back is that on future hardware,
> > we may not have a "suspend" mode, and systems may just be in a deep
> > idle, with selected interrupts disabled 
> 
> Nothing future about this. Some ARM devices have had that kind of mindset
> for a long time, some x86 platforms can run that way but don't currently
> do so under Linux (eg Baytrail/T). On those x86 platforms 'suspend' and
> 'resume' are in fact entirely Linux constructs to fake legacy behaviour
> on top of an ultra low power idle.
> 
> If you are planning for the future then I wouldn't be too hooked on ideas
> like "suspend", "lid switches" or assumptions that a "closed" device
> should be kept suspended. It's a broken model. It's bad enough that
> systemd tries to do magic hackery to fake this up and gets it wrong in
> some case (despite making a very good effort) without propogating the mess
> further.
> 
> - S3 has already gone away on some Intel SoC devices

And I think I have one of those devices, an Intel Baytrail tablet.

> - Suspend/Resume on such machines are a Linux fake to keep legacy code
>   happy

Do you have a link to how this is implemented currently?

> - In such an environment your "wakeup" model changes entirely because you
>   drop into deep idle whever there isn't stuff annoying the CPU
>   regularly. With the right kinds of video and audio that could even mean
>   doing it between keypresses (feature parity approaching 1980s 8bit
>   laptops ;-) )
> 
> Instead think long term that
> 
> - There may be no such thing as suspend or resume, just make your code
>   very well behaved on wakeup events, and closing unneeded
>   devices/resources whenever it can.
> - On/off is an extreme action rarely taken (feature parity with 1970s
>   VAXen ;-) )
> - The "blob with a lid" model of construction is no longer useful. Even a
>   keyboarded device is quite likely have a removable keyboard.

Except that what I requested (at least the amended version[1]) would
also work with devices that don't have suspend. And would also work on
the millions of other devices that do have a suspend state, and exist in
the wild.

[1]: Reason for wake-up for each wake-up-able device, along with a
timestamp.

