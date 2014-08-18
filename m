Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbaHRKIv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 06:08:51 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:35867 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbaHRKIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 06:08:48 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Mon, 18 Aug 2014 12:07:20 +0200
From: Johan Hovold <johan@kernel.org>
To: Wang YanQing <udknight@gmail.com>
Cc: Johan Hovold <johan@kernel.org>, Linus Walleij <linus.walleij@linaro.org>,
        gregkh@linuxfoundation.org, jhovold@gmail.com, andi@lisas.de,
        dforsi@gmail.com, gnomes@lxorguk.ukuu.org.uk,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7] usb:serial:pl2303: add GPIOs interface on PL2303
Message-ID: <20140818100720.GF31755@localhost>
References: <20140809052828.GA28307@udknight>
 <20140812144625.GB9799@localhost>
 <20140817020536.GA2509@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140817020536.GA2509@localhost.localdomain>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 17, 2014 at 10:05:36AM +0800, Wang YanQing wrote:
> Hi Johan Hovold.
> 
> Another two questions.
> 	
> On Tue, Aug 12, 2014 at 04:46:25PM +0200, Johan Hovold wrote:
> > 
> > > +	int (*gpio_startup)(struct usb_serial *serial);
> > > +	void (*gpio_release)(struct usb_serial *serial);
> > 
> > This isn't the right place for this abstraction. Most of the setup code
> > would be common for any device type with GPIOs.
> 
> I assume you mean any pl2303 variant, not any device type, because
> no device in drivers/gpio has common setup code except many of them
> use struct gpio_chip.

Yes, pl2303 type/variant. Specifically, much of the setup code will be
identical even if say the number of gpio differ (2 or 4) depending on
type.

> > Just keep the generic gpio_startup and release from v6, and verify that
> > ngpio > 0. Any further abstraction should only be added once we know how
> > the other types handles GPIOs.
> 
> Instead of assume code works for all situation firstly,  test and write
> code for only one type device, and make code become generic when we find
> it works for others' type.
> 
> I don't known which way is better.

Add support for your device type (HXA). We should verify that it also
works for the non-end-of-life HXD, or we might need to find a way to
detect those two different types of HX and limit it to HXA for now.

If and when someone reverse-engineers a device type with a different
protocol for dealing with GPIOs, that's when you add further abstraction.

> Thanks very much for your patient review !!

You're welcome.

Johan
