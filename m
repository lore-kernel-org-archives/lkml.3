Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932205Ab3IBQKB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 12:10:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47179 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932158Ab3IBQJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 12:09:59 -0400
Date: Mon, 2 Sep 2013 09:12:32 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: oliver+list@schinagl.nl, arnd@arndb.de,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        andy.shevchenko@gmail.com, tomasz.figa@gmail.com,
        Oliver Schinagl <oliver@schinagl.nl>
Subject: Re: [PATCHv6 1/2] ARM: sunxi: Initial support for Allwinner's
 Security ID fuses
Message-ID: <20130902161232.GA23912@kroah.com>
References: <1378035019-9649-1-git-send-email-oliver+list@schinagl.nl>
 <1378035019-9649-2-git-send-email-oliver+list@schinagl.nl>
 <20130902080812.GA2630@lukather>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130902080812.GA2630@lukather>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 02, 2013 at 10:08:12AM +0200, Maxime Ripard wrote:
> > +	platform_set_drvdata(pdev, sid_data);
> > +
> > +	sid_bin_attr.size = sid_data->keysize; /* fixme: this should be properly set by the sysfs bin attr groups later */
> > +	if (device_create_bin_file(&pdev->dev, &sid_bin_attr)) /* fixme: this will need to be removed when using sysfs bin attr groups */
> 
> I'm sorry, this is not really what I had in mind. You still don't
> explain why this is causing a problem, what problem, and why you can't
> use the sysfs groups right from the start.
> 
> What I wanted was a (pretty long, I agree) summing up the whole
> discussion we had.
> 
> Something like:
> 
> /*
>  * Be aware that this will generate a race with userspace. By the time
>  * it gets called, udev has already been notified of the device
>  * addition, and will never be notified that this file has been added.
>  *
>  * It should be properly fixed by having some way to attach a sysfs
>  * attribute group to the device structure before the probe.
>  * Unfortunately, this is both not possible for platform devices at the
>  * moment and not trivial to do, so this will need a proper fix later
>  * on.
>  */
> 
> And just like the comment quoted above, you can remove the useless fixme
> comments you added everywhere.

There's no need for any of this, including the "FIXME" comments.  I know
what the problem is here, and until the driver core changes get merged
upstream in order to fix it, there's no need to worry about "broken"
drivers, as everything is "broken".

I'll just take this as-is and remove the "fixme" comments, ok?

thanks,

greg k-h
