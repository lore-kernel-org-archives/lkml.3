Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932526Ab3GQQRz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 12:17:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48849 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932120Ab3GQQRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 12:17:53 -0400
Date: Wed, 17 Jul 2013 09:17:58 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Oliver Schinagl <oliver+list@schinagl.nl>, linux-sunxi@googlegroups.com,
        arnd@arndb.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, andy.shevchenko@gmail.com,
        linux@arm.linux.org.uk, linus.walleij@linaro.org,
        Oliver Schinagl <oliver@schinagl.nl>
Subject: Re: [linux-sunxi] Re: [PATCH 1/2] Initial support for Allwinner's
 Security ID fuses
Message-ID: <20130717161758.GA9822@kroah.com>
References: <20130624181509.GA8847@kroah.com>
 <51C8B84C.3020200@schinagl.nl>
 <20130624214615.GA17604@kroah.com>
 <51CAA709.4060801@schinagl.nl>
 <20130626175144.GC2222@kroah.com>
 <51D674BF.9030207@schinagl.nl>
 <20130706193646.GB9778@kroah.com>
 <51E466A3.4010503@schinagl.nl>
 <20130716064107.GA10868@kroah.com>
 <20130717114650.GN3125@lukather>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130717114650.GN3125@lukather>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 01:46:50PM +0200, Maxime Ripard wrote:
> On Mon, Jul 15, 2013 at 11:41:07PM -0700, Greg KH wrote:
> > On Mon, Jul 15, 2013 at 11:16:19PM +0200, Oliver Schinagl wrote:
> > > So using these new patches for binary attributes, how can I pass data 
> > > between my driver and the sysfs files using a platform_driver? Or are 
> > > other 'hacks' needed and using the .groups attribute from 
> > > platform_driver->device_driver->groups is really the wrong approach.
> > > 
> > > I did ask around and still haven't figured it out so far, so I do 
> > > apologize if you feel I'm wasting your precious time.
> > 
> > How is the platform device not the same thing that was passed to your
> > probe function?
> 
> One thing I don't get here is why it should be set in the
> platform_driver structure. From my understanding of the device model,
> and since what Oliver is trying to do is exposing a few bytes of memory
> to sysfs, shouldn't the sysfs file be attached to the device instead?

It will be created by the driver core for any device attached to the
driver automatically.

> I mean, here, the sysfs file will be created under something like
> .../drivers/sunxi-sid/eeprom. What happens when you have several
> instances of that driver loaded? I'd expect it to have several sysfs
> files created, one for each instance. So to me, it should be in the
> device structure, not the driver one.

You can't have multiple drivers with the same name loaded (or the same
module loaded multiple times.)  You can have multiple devices for a
single driver, which is what we do all the time.

> Couldn't that be also the reason of Oliver's NULL pointer? If the kobj
> is attached to the platform_driver and not to the platform_device, it
> should definitely get nasty when we try to cast it and retrieve data
> from it (and that would match the different pointers stuff as well.)

No, he's getting a kobject that looks quite different at probe that is
different from when the file callback happens, something is odd here...

greg k-h
