Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562AbbAWIOy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 03:14:54 -0500
Received: from mga11.intel.com ([192.55.52.93]:58482 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031AbbAWIOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 03:14:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,453,1418112000"; 
   d="scan'208";a="641460949"
Date: Fri, 23 Jan 2015 10:12:41 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        Baolu Lu <baolu.lu@linux.intel.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] phy: ulpi: add driver for TI TUSB1210
Message-ID: <20150123081241.GB30522@kuha.fi.intel.com>
References: <1421745502-169447-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1421745502-169447-4-git-send-email-heikki.krogerus@linux.intel.com>
 <20150120154539.GB8988@saruman>
 <20150121091749.GB22716@kuha.fi.intel.com>
 <20150122204925.GF22288@saruman.tx.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150122204925.GF22288@saruman.tx.rr.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jan 22, 2015 at 02:49:25PM -0600, Felipe Balbi wrote:
> On Wed, Jan 21, 2015 at 11:17:49AM +0200, Heikki Krogerus wrote:
> > > > +	/* Store initial eye diagram optimisation value */
> > > > +	ret = ulpi_read(ulpi, ULPI_EXT_VENDOR_SPECIFIC);
> > > 
> > > do they *all* use this register for eye diagram optimization or is this
> > > something that Intel decided to do ?
> > > 
> > > (sorry, don't know much about tusb1210 other than it sucks like hell :-)
> > 
> > All I know that somebody needs to save the value. The ones using this
> > PHY who don't need to save it can most likely live without the driver.
> 
> right, but what I mean is: is it mandatory that Eye diagram
> configuration be stored in *this* register? Or is it more like a scratch
> register which Intel just happens to be using for Eye diagram data ?

The eye diagram tuning is in that register. Here's the spec:
http://www.ti.com/lit/ds/symlink/tusb1210.pdf

I'll add definition for the register (which is colourfully named
"VENDOR_SPECIFIC2").

> > > > +	if (ret < 0)
> > > > +		return ret;
> > > > +
> > > > +	tusb->ctx[0] = ret;
> > > > +
> > > > +	tusb->phy = ulpi_phy_create(ulpi, &phy_ops);
> > > > +	if (IS_ERR(tusb->phy))
> > > > +		return PTR_ERR(tusb->phy);
> > > > +
> > > > +	tusb->ulpi = ulpi;
> > > > +
> > > > +	phy_set_drvdata(tusb->phy, tusb);
> > > > +	dev_set_drvdata(&ulpi->dev, tusb);
> > > > +	return 0;
> > > > +}
> > > > +
> > > > +static void tusb1210_remove(struct ulpi *ulpi)
> > > > +{
> > > > +	struct tusb1210 *tusb = dev_get_drvdata(&ulpi->dev);
> > > 
> > > completely unrelated to $subject, but we might want to have a
> > > ulpi_{set,get}_drvdata() at some point.
> > 
> > Makes sense.
> > 
> > > In fact, we might decide to add an entire ULPI bus, eventually, though
> > > I'm still considering if there's any benefit to that.
> > 
> > I don't think I understand this comment? ULPI bus is what I'm
> > introducing in this set (the first patch in it)?
> 
> I mean introducing a real struct bus ulpi_bus_type :-) With match,
> probe, remove, etc.

I'm already doing that. Please check the first patch in this set:
"phy: add bus for USB ULPI PHYs".


Cheers,

-- 
heikki
