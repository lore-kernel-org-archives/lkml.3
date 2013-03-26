Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332Ab3CZXVO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:21:14 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:43195 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755406Ab3CZXVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 19:21:11 -0400
Date: Tue, 26 Mar 2013 16:21:08 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Tomas Winkler <tomas.winkler@intel.com>, arnd@arndb.de,
        linux-kernel@vger.kernel.org
Subject: Re: [char-misc-next 01/11 V4] mei: bus: Initial MEI Client bus type
 implementation
Message-ID: <20130326232108.GA30620@kroah.com>
References: <1363819469-696-1-git-send-email-tomas.winkler@intel.com>
 <1363819469-696-2-git-send-email-tomas.winkler@intel.com>
 <20130325202855.GA21494@kroah.com>
 <20130326133326.GA19511@zurbaran>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130326133326.GA19511@zurbaran>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 02:33:26PM +0100, Samuel Ortiz wrote:
> > > +/**
> > > + * struct mei_cl_device - MEI device handle
> > > + * An mei_cl_device pointer is returned from mei_add_device()
> > > + * and links MEI bus clients to their actual ME host client pointer.
> > > + * Drivers for MEI devices will get an mei_cl_device pointer
> > > + * when being probed and shall use it for doing ME bus I/O.
> > > + *
> > > + * @dev: linux driver model device pointer
> > > + * @uuid: me client uuid
> > > + * @cl: mei client
> > > + * @priv_data: client private data
> > > + */
> > > +struct mei_cl_device {
> > > +	struct device dev;
> > > +
> > > +	uuid_le uuid;
> > > +	struct mei_cl *cl;
> > > +
> > > +	void *priv_data;
> > > +};
> > 
> > Why is priv_data needed?  What's wrong with the pointer provided to you
> > in struct device?
> mei_cl_device->dev->p->driver_data is used by mei drivers to carry their
> private data around, we define mei_cl_get_clientdata/mei_cl_set_clientdata for
> that and keep the mei_cl_device structure opaque to them.
> mei_cl_device->priv_data is used internally by the drivers/misc/mei/ bus
> related code to carry technology specific pointers. drivers/misc/mei/nfc.c
> uses it to fetch its private data when it gets a mei_cl_device pointer.

Ugh, that looks like a mess, but ok, if you say it is needed, I'll trust
you.

> > > +struct mei_cl_driver {
> > > +	struct device_driver driver;
> > > +	const char *name;
> > 
> > What's wrong with the driver.name field?
> >From your initial comments on patchset v1:
> 
> "
> 	> +static struct mei_bus_driver contact_driver = {
> 	> +     .driver = {
> 	> +                .name = CONTAC_DRIVER_NAME,
> 	> +               },
> 
> 	Can't you put a name field in your mei_bus_driver structure and then
> 	copy it to the version in the driver model?  That's what other bus
> 	drivers do and it makes more sense.
> "
> 
> And you were right, that is indeed what other bus drivers do. Did I
> misunderstand you here ?

No, you are right, sorry for giving conflicting information, it's fine
as-is.

greg k-h
