Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751593AbaHHSrS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 14:47:18 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:49091 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbaHHSrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 14:47:15 -0400
Date: Sat, 9 Aug 2014 02:46:56 +0800
From: Wang YanQing <udknight@gmail.com>
To: Johan Hovold <johan@kernel.org>
Cc: gregkh@linuxfoundation.org, linus.walleij@linaro.org, jhovold@gmail.com,
        andi@lisas.de, dforsi@gmail.com, gnomes@lxorguk.ukuu.org.uk,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Resend Re: [PATCH v6] usb:serial:pl2303: add GPIOs interface on
 PL2303
Message-ID: <20140808184655.GA20958@udknight>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140808075442.GB14553@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2014 at 09:54:42AM +0200, Johan Hovold wrote:
> On Fri, Aug 08, 2014 at 03:10:34AM +0800, Wang YanQing wrote:
> > On Tue, Aug 05, 2014 at 03:54:08PM +0200, Johan Hovold wrote:
> > > > > I noticed that setting direction to output and setting the gpio high has
> > > > > no effect on the read-back value (i.e. I still read back 0) for my
> > > > > pl2303hx (note that my device has no easily accessible gpios so I
> > > > > haven't verified the actual state of the output pin).
> > > > > 
> > > > > What happens on your system? Is the read-back value still 0, even when
> > > > > the GPIO output is actually high? Should we return the cached value in
> > > > > this case?
> > > > 
> > > > If i set direction to output, then I could control gpio high and low
> > > > by set 1 or 0, and the read-back value is 1 or 0 according to high and
> > > > low(I test high and low by oscillscope)
> > > > 
> > > > I test it with my pl2303hx with only two gpios.
> > > >
> > > > Could you use usbmon to see whether the traffic is right according
> > > > to comment in struct pl2303_gpio?
> > > 
> > > The traffic appears correct judging from the debug output (which I
> > > trust). Output-enable is reflected in register 0x81, but the value
> > > isn't.
> > > 
> > > What is the lsusb -v output for your device?
> > 
> > Bus 001 Device 005: ID 067b:2303 Prolific Technology, Inc. PL2303 Serial Port.
> 
> You forgot the verbose flag (-v).
Sorry, below is output with -v:
Bus 002 Device 004: ID 067b:2303 Prolific Technology, Inc. PL2303 Serial Port
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x067b Prolific Technology, Inc.
  idProduct          0x2303 PL2303 Serial Port
  bcdDevice            3.00
  iManufacturer           1 Prolific Technology Inc.
  iProduct                2 USB-Serial Controller
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           39
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              100mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0 
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x000a  1x 10 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
Device Status:     0x0000
  (Bus Powered)
>  
> > It is strange your device doesn't work, I verify the control method by
> > analyze usbmon output from linux host which has VirtualBox running 
> > gpio test program, but I don't have right to distribute the gpio test
> > program I think, so I can't help you to figure out why it doesn't work 
> > for your device.
> 
> What do you use the gpio test program for? I thought you verified the
> gpios with a scope?

Yes, I verified gpios with a scope.

"
You must allocate the buffer dynamically as some platforms cannot do DMA to the stack.
"
Thanks very much for point out it, could you clarify it? 
I want to know the reason.

I am working on next version patch and hope it could be finished this weekend. :)

Thanks again.
