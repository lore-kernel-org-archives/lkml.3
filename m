Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650AbbA1UtI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:49:08 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:48111 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964830AbbA1Usz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:48:55 -0500
Date: Wed, 28 Jan 2015 16:24:54 +0100
From: Johan Hovold <johan@kernel.org>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Johan Hovold <johan@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 3.14 02/77] gpio: sysfs: fix gpio device-attribute leak
Message-ID: <20150128152454.GB2433@localhost>
References: <20150128012745.971137091@linuxfoundation.org>
 <20150128012746.043195070@linuxfoundation.org>
 <20150128143008.GC4685@charon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150128143008.GC4685@charon>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 02:30:08PM +0000, Luis Henriques wrote:
> On Tue, Jan 27, 2015 at 05:26:40PM -0800, Greg Kroah-Hartman wrote:

> > @@ -994,6 +991,8 @@ void gpiod_unexport(struct gpio_desc *de
> >  
> >  		dev = class_find_device(&gpio_class, NULL, desc, match_export);
> >  		if (dev) {
> > +			device_remove_file(dev, &dev_attr_edge);
> > +			device_remove_file(dev, &dev_attr_direction);
> >  			gpio_setup_irq(desc, dev, 0);
> >  			clear_bit(FLAG_EXPORT, &desc->flags);
> >  		} else
> > 
> 
> I believe there's a mistake in this backport: the changes to the
> gpiod_unexport() function are being applied to the wrong code block;
> they should be in:
> 
> 	if (dev) {
> 		device_unregister(dev);
> 		put_device(dev);
> 	}
> 
> The backport to the 3.10 kernel have the same problem.

You're right, thanks for catching this.

I'll send a v2.

Johan
