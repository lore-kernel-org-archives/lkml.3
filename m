Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751471AbaHMHKI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 03:10:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42121 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbaHMHKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 03:10:00 -0400
Date: Wed, 13 Aug 2014 15:09:18 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Johan Hovold <johan@kernel.org>
Cc: Hannes Petermaier <Hannes.Petermaier@br-automation.com>, andi@lisas.de,
        dforsi@gmail.com, gnomes@lxorguk.ukuu.org.uk, jhovold@gmail.com,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-kernel-owner@vger.kernel.org, linux-usb@vger.kernel.org,
        Wang YanQing <udknight@gmail.com>
Subject: Re: [PATCH v7] usb:serial:pl2303: add GPIOs interface on PL2303
Message-ID: <20140813070918.GA12747@kroah.com>
References: <20140809052828.GA28307@udknight>
 <20140812144625.GB9799@localhost>
 <OF3463CFCF.9AED608B-ONC1257D33.002239D7-C1257D33.002297E8@br-automation.com>
 <20140813070509.GA26836@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140813070509.GA26836@localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 09:05:09AM +0200, Johan Hovold wrote:
> On Wed, Aug 13, 2014 at 08:17:50AM +0200, Hannes Petermaier wrote:
> > > > 
> > > > Known issue:
> > > > If gpios are in use(export to userspace through sysfs interface, etc),
> > > > then call pl2303_release(unplug usb-serial convertor, modprobe -r, 
> > etc),
> > > > will cause trouble, so we need to make sure there is no gpio user 
> > before
> > > > call pl2303_release.
> > > 
> > > This is a real problem that we need to address. gpiolib isn't really
> > > able to handle devices that just disappear. In fact, it's API claims 
> > that
> > > we must not call gpiochip_remove with requested gpios and this is
> > > exactly what you might do in pl2303hx_gpio_release below.
> > > 
> > > As I mentioned earlier, this crashes the kernel when a new gpiochip is
> > > later added (the gpiochip data structures are likely corrupted and we
> > > get a NULL pointer deref in gpiochip_find_base).
> > > 
> > > Linus, any thoughts on this?
> > 
> > Hi,
> > there are several USB to I2C bus adapters and I2C IO-Expanders,
> > how is this handled there ?
> 
> The short answer is: it isn't.
> 
> A few i2c-gpio-expander drivers have teardown callbacks that can be used
> from board files to release any gpios requested there, but this neither
> translates to device tree or is of any help when gpios have been
> exported to user space.

For some reason I thought I saw some patches recently that was trying to
resolve this problem.  So it might get fixed for 3.18...

thanks,

greg k-h
