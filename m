Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761007Ab3BJDcT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 22:32:19 -0500
Received: from mga03.intel.com ([143.182.124.21]:22113 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756944Ab3BJDcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 22:32:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,636,1355126400"; 
   d="scan'208";a="200721394"
Date: Sun, 10 Feb 2013 04:32:18 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Tomas Winkler <tomas.winkler@intel.com>, arnd@arndb.de,
        linux-kernel@vger.kernel.org
Subject: Re: [char-misc-next 02/11 V2] mei: bus: Implement driver registration
Message-ID: <20130210033218.GH20996@sortiz-mobl>
References: <1360326504-17041-1-git-send-email-tomas.winkler@intel.com>
 <1360326504-17041-3-git-send-email-tomas.winkler@intel.com>
 <20130208235524.GB24127@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130208235524.GB24127@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Fri, Feb 08, 2013 at 03:55:24PM -0800, Greg KH wrote:
> On Fri, Feb 08, 2013 at 02:28:15PM +0200, Tomas Winkler wrote:
> > From: Samuel Ortiz <sameo@linux.intel.com>
> > 
> > Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
> > Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> > Acked-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> >  drivers/misc/mei/bus.c  |   29 +++++++++++++++++++++++++++++
> >  include/linux/mei_bus.h |    3 +++
> >  2 files changed, 32 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
> > index bb96423c..0a5e624 100644
> > --- a/drivers/misc/mei/bus.c
> > +++ b/drivers/misc/mei/bus.c
> > @@ -153,3 +153,32 @@ void mei_remove_device(struct mei_bus_client *client)
> >  	device_unregister(&client->dev);
> >  }
> >  EXPORT_SYMBOL(mei_remove_device);
> > +
> > +int mei_driver_register(struct mei_bus_driver *driver)
> > +{
> > +	int err;
> > +
> > +	/* Can't register until after driver model init */
> > +	if (unlikely(WARN_ON(!mei_bus_type.p)))
> > +		return -EAGAIN;
> 
> No, you really don't know what 'p' is, so don't assume you do.  You have
> fields you can test to see if your driver model is up and registered,
> use them instead.  
Unless I'm missing something, I would actually need to track if the bus type
is registered or not from bus.c. I can't find any field from bus_type that
tells me for sure if my bus is registered or not, except for p.
I actually think I don't need that check anyway. IIRC, this is something I
took from i2c-core.c but in the ME case it's most likely not needed.


> > +	driver->driver.owner = THIS_MODULE;
> 
> Nope, this should be the module that owns the driver, not this one.  It
> needs to be passed in with the call, or as part of the driver structure.
That's right, I'll fix that.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
