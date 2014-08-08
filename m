Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009AbaHHH4F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 03:56:05 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:60178 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755517AbaHHH4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 03:56:03 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Fri, 8 Aug 2014 09:54:42 +0200
From: Johan Hovold <johan@kernel.org>
To: Wang YanQing <udknight@gmail.com>
Cc: Johan Hovold <johan@kernel.org>, gregkh@linuxfoundation.org,
        linus.walleij@linaro.org, jhovold@gmail.com, andi@lisas.de,
        dforsi@gmail.com, gnomes@lxorguk.ukuu.org.uk,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Resend Re: [PATCH v6] usb:serial:pl2303: add GPIOs interface on
 PL2303
Message-ID: <20140808075442.GB14553@localhost>
References: <20140729165709.GA3380@udknight>
 <20140804140032.GA25529@localhost>
 <20140804171536.GA2330@udknight>
 <20140805135408.GD25529@localhost>
 <20140807191034.GA6335@udknight>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140807191034.GA6335@udknight>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2014 at 03:10:34AM +0800, Wang YanQing wrote:
> On Tue, Aug 05, 2014 at 03:54:08PM +0200, Johan Hovold wrote:
> > > > I noticed that setting direction to output and setting the gpio high has
> > > > no effect on the read-back value (i.e. I still read back 0) for my
> > > > pl2303hx (note that my device has no easily accessible gpios so I
> > > > haven't verified the actual state of the output pin).
> > > > 
> > > > What happens on your system? Is the read-back value still 0, even when
> > > > the GPIO output is actually high? Should we return the cached value in
> > > > this case?
> > > 
> > > If i set direction to output, then I could control gpio high and low
> > > by set 1 or 0, and the read-back value is 1 or 0 according to high and
> > > low(I test high and low by oscillscope)
> > > 
> > > I test it with my pl2303hx with only two gpios.
> > >
> > > Could you use usbmon to see whether the traffic is right according
> > > to comment in struct pl2303_gpio?
> > 
> > The traffic appears correct judging from the debug output (which I
> > trust). Output-enable is reflected in register 0x81, but the value
> > isn't.
> > 
> > What is the lsusb -v output for your device?
> 
> Bus 001 Device 005: ID 067b:2303 Prolific Technology, Inc. PL2303 Serial Port.

You forgot the verbose flag (-v).
 
> It is strange your device doesn't work, I verify the control method by
> analyze usbmon output from linux host which has VirtualBox running 
> gpio test program, but I don't have right to distribute the gpio test
> program I think, so I can't help you to figure out why it doesn't work 
> for your device.

What do you use the gpio test program for? I thought you verified the
gpios with a scope?

Perhaps mine just does not support GPIOs? I don't know, but that's
partly why I asked for the lsusb output. Apparently there's a bunch of
different versions of these chips out there.

I'll see if I can find time to dissect my converter and try to access
the GPIO pins with the next version of the patch.

> > I suggest you just set the label to pl2303 until we have a valid
> > use-case that requires something more elaborate.
> 
> Ok, but pl2303-gpio maybe a better name?

No, not really. It's a gpio-chip label and is only used in that context
so a "-gpio" suffix adds no information.

Thanks,
Johan
