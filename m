Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465AbaHGTK5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 15:10:57 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:36969 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbaHGTK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 15:10:56 -0400
Date: Fri, 8 Aug 2014 03:10:34 +0800
From: Wang YanQing <udknight@gmail.com>
To: Johan Hovold <johan@kernel.org>
Cc: gregkh@linuxfoundation.org, linus.walleij@linaro.org, jhovold@gmail.com,
        andi@lisas.de, dforsi@gmail.com, gnomes@lxorguk.ukuu.org.uk,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Resend Re: [PATCH v6] usb:serial:pl2303: add GPIOs interface on
 PL2303
Message-ID: <20140807191034.GA6335@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	Johan Hovold <johan@kernel.org>, gregkh@linuxfoundation.org,
	linus.walleij@linaro.org, jhovold@gmail.com, andi@lisas.de,
	dforsi@gmail.com, gnomes@lxorguk.ukuu.org.uk,
	linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20140729165709.GA3380@udknight>
 <20140804140032.GA25529@localhost>
 <20140804171536.GA2330@udknight>
 <20140805135408.GD25529@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140805135408.GD25529@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2014 at 03:54:08PM +0200, Johan Hovold wrote:
> > > I noticed that setting direction to output and setting the gpio high has
> > > no effect on the read-back value (i.e. I still read back 0) for my
> > > pl2303hx (note that my device has no easily accessible gpios so I
> > > haven't verified the actual state of the output pin).
> > > 
> > > What happens on your system? Is the read-back value still 0, even when
> > > the GPIO output is actually high? Should we return the cached value in
> > > this case?
> > 
> > If i set direction to output, then I could control gpio high and low
> > by set 1 or 0, and the read-back value is 1 or 0 according to high and
> > low(I test high and low by oscillscope)
> > 
> > I test it with my pl2303hx with only two gpios.
> >
> > Could you use usbmon to see whether the traffic is right according
> > to comment in struct pl2303_gpio?
> 
> The traffic appears correct judging from the debug output (which I
> trust). Output-enable is reflected in register 0x81, but the value
> isn't.
> 
> What is the lsusb -v output for your device?

Bus 001 Device 005: ID 067b:2303 Prolific Technology, Inc. PL2303 Serial Port.

It is strange your device doesn't work, I verify the control method by
analyze usbmon output from linux host which has VirtualBox running 
gpio test program, but I don't have right to distribute the gpio test
program I think, so I can't help you to figure out why it doesn't work 
for your device.

> I suggest you just set the label to pl2303 until we have a valid
> use-case that requires something more elaborate.

Ok, but pl2303-gpio maybe a better name?

Thanks.
