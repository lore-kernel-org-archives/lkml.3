Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965436AbaH0Xi2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 19:38:28 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:48331 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965338AbaH0Xi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 19:38:26 -0400
Date: Thu, 28 Aug 2014 07:38:10 +0800
From: Wang YanQing <udknight@gmail.com>
To: Johan Hovold <johan@kernel.org>
Cc: gregkh@linuxfoundation.org, linus.walleij@linaro.org, jhovold@gmail.com,
        andi@lisas.de, dforsi@gmail.com, gnomes@lxorguk.ukuu.org.uk,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Resend Re: [PATCH v6] usb:serial:pl2303: add GPIOs interface on
 PL2303
Message-ID: <20140827233810.GA418@localhost.localdomain>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	Johan Hovold <johan@kernel.org>, gregkh@linuxfoundation.org,
	linus.walleij@linaro.org, jhovold@gmail.com, andi@lisas.de,
	dforsi@gmail.com, gnomes@lxorguk.ukuu.org.uk,
	linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20140729165709.GA3380@udknight>
 <20140804140032.GA25529@localhost>
 <20140804171536.GA2330@udknight>
 <20140805135408.GD25529@localhost>
 <20140807191034.GA6335@udknight>
 <20140808075442.GB14553@localhost>
 <20140808184655.GA20958@udknight>
 <20140812140259.GA9799@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140812140259.GA9799@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 04:02:59PM +0200, Johan Hovold wrote:
> On Sat, Aug 09, 2014 at 02:46:56AM +0800, Wang YanQing wrote:
> > On Fri, Aug 08, 2014 at 09:54:42AM +0200, Johan Hovold wrote:
> > > On Fri, Aug 08, 2014 at 03:10:34AM +0800, Wang YanQing wrote:
> > > > On Tue, Aug 05, 2014 at 03:54:08PM +0200, Johan Hovold wrote:
> > > > > > > I noticed that setting direction to output and setting the gpio high has
> > > > > > > no effect on the read-back value (i.e. I still read back 0) for my
> > > > > > > pl2303hx (note that my device has no easily accessible gpios so I
> > > > > > > haven't verified the actual state of the output pin).
> > > > > > > 
> > > > > > > What happens on your system? Is the read-back value still 0, even when
> > > > > > > the GPIO output is actually high? Should we return the cached value in
> > > > > > > this case?
> > > > > > 
> > > > > > If i set direction to output, then I could control gpio high and low
> > > > > > by set 1 or 0, and the read-back value is 1 or 0 according to high and
> > > > > > low(I test high and low by oscillscope)
> > > > > > 
> > > > > > I test it with my pl2303hx with only two gpios.
> > > > > >
> > > > > > Could you use usbmon to see whether the traffic is right according
> > > > > > to comment in struct pl2303_gpio?
> > > > > 
> > > > > The traffic appears correct judging from the debug output (which I
> > > > > trust). Output-enable is reflected in register 0x81, but the value
> > > > > isn't.
> > > > > 
> > > > > What is the lsusb -v output for your device?
> > > > 
> > > > Bus 001 Device 005: ID 067b:2303 Prolific Technology, Inc. PL2303 Serial Port.
> > > 
> > > You forgot the verbose flag (-v).
> > Sorry, below is output with -v:
> > Bus 002 Device 004: ID 067b:2303 Prolific Technology, Inc. PL2303 Serial Port
> > Device Descriptor:
> >   bLength                18
> >   bDescriptorType         1
> >   bcdUSB               1.10
> >   bDeviceClass            0 (Defined at Interface level)
> >   bDeviceSubClass         0 
> >   bDeviceProtocol         0 
> >   bMaxPacketSize0        64
> >   idVendor           0x067b Prolific Technology, Inc.
> >   idProduct          0x2303 PL2303 Serial Port
> >   bcdDevice            3.00
> 
> You seem to have an HX device, whereas mine is an HXD (rev D) with
> bcdDevice 4.00. That could account for the different behaviour of the
> GPIO state/value register.
> 
> How did you figure out which registers to use? Were you sniffing the
> traffic of some driver for some other OS? And does your device only have
> two GPIOs and not four like the HX rev D?

After I found I need to use GPIOs in pl2303, I found below patch in Internet firstly:
http://comments.gmane.org/gmane.linux.usb.general/65066

Then I verified the protocol by sniffing the traffic of some driver for some other
OS running in virtualbox, and host OS is linux:)

Prolific has pl2303 gpio test program (.exe) for windows, maybe you could find it
from Internet. It support HXA and HXD, I use it to test two gpios in my pl2303HXA, 
and analyze output of usbmon.

Yes, my device only have two GPIOs.
> <snip>
> 
> > > > It is strange your device doesn't work, I verify the control method by
> > > > analyze usbmon output from linux host which has VirtualBox running 
> > > > gpio test program, but I don't have right to distribute the gpio test
> > > > program I think, so I can't help you to figure out why it doesn't work 
> > > > for your device.
> > > 
> > > What do you use the gpio test program for? I thought you verified the
> > > gpios with a scope?
> > 
> > Yes, I verified gpios with a scope.
> > 
> > "
> > You must allocate the buffer dynamically as some platforms cannot do
> > DMA to the stack.
> > "
> > Thanks very much for point out it, could you clarify it? 
> > I want to know the reason.
> 
> The memory where the stack resides might not be available for DMA, and
> even if it is, there could still be problems with cache coherency.

It is still vague:
stack memory maybe resident higher place than normal memory,
but I don't think kmalloc could be immune from this problem, unless
we use GFP_DMA?
