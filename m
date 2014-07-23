Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758249AbaGWQVb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 12:21:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56867 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755835AbaGWQVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 12:21:30 -0400
Date: Wed, 23 Jul 2014 09:21:29 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Wang YanQing <udknight@gmail.com>, linus.walleij@linaro.org,
        jhovold@gmail.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] usb:serial:pl2303: add GPIOs interface on PL2303
Message-ID: <20140723162129.GB6871@kroah.com>
References: <20140720063841.GA28059@udknight>
 <20140723170314.23864779@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140723170314.23864779@alan.etchedpixels.co.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 05:03:14PM +0100, One Thousand Gnomes wrote:
> > +		if (gpiochip_remove(&spriv->gpio->gpio_chip))
> > +			dev_err(&serial->interface->dev, "unable to remove gpio_chip?\n");
> > +		kfree(spriv->gpio);
> > +	}
> > +#endif
> >  	kfree(spriv);
> 
> Only other question I have - if I have multiple PL2303HX adapters how
> will I work out which GPIO lines belong to which /dev/ttyUSB* interface ?

sysfs _should_ show you this, as it should point to the "parent" device,
which will be associated with the ttyUSB interface.  Well, both the tty
device and the gpio device will have the same parent, is that good
enough to determine this, or should the gpio device have the tty device
as its parent?

thanks,

greg k-h
