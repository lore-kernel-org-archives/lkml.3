Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911Ab3JJP1Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:27:25 -0400
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:52855
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753980Ab3JJP1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:27:23 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -6
X-BigFish: VS-6(zz98dI9371I936eI148cI542I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bh8275dhz2dh2a8h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h1155h)
Message-ID: <1381418830.7979.405.camel@snotra.buserror.net>
Subject: Re: RFC: (re-)binding the VFIO platform driver to a platform device
From: Scott Wood <scottwood@freescale.com>
To: Bhushan Bharat-R65777 <R65777@freescale.com>
CC: Kim Phillips <kim.phillips@linaro.org>,
        Wood Scott-B07421 <B07421@freescale.com>,
        Yoder Stuart-B08248 <B08248@freescale.com>,
        "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "a.motakis@virtualopensystems.com" <a.motakis@virtualopensystems.com>,
        "agraf@suse.de" <agraf@suse.de>,
        Sethi Varun-B16395 <B16395@freescale.com>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        "santosh.shukla@linaro.org" <santosh.shukla@linaro.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Date: Thu, 10 Oct 2013 10:27:10 -0500
In-Reply-To: <6A3DF150A5B70D4F9B66A25E3F7C888D071AEED6@039-SN2MPN1-012.039d.mgd.msft.net>
References: <1380738758.12932.43.camel@snotra.buserror.net>
	 <20131002184330.GC5108@cbox>	<20131002203735.GA10871@kroah.com>
	 <1380748121.12932.89.camel@snotra.buserror.net>
	 <20131002211631.GA11914@kroah.com>
	 <1380749715.12932.109.camel@snotra.buserror.net>
	 <20131002234009.GA27714@kroah.com>
	 <1380825207.12932.151.camel@snotra.buserror.net>
	 <20131003185434.GA26123@kroah.com>
	 <1380827494.12932.161.camel@snotra.buserror.net>
	 <20131003203226.GB27336@kroah.com>
	 <9F6FE96B71CF29479FF1CDC8046E15036DDA62@039-SN1MPN1-002.039d.mgd.msft.net>
	 <1381346507.7979.334.camel@snotra.buserror.net>
	 <9F6FE96B71CF29479FF1CDC8046E15036DDAB4@039-SN1MPN1-002.039d.mgd.msft.net>
	 <1381348999.7979.360.camel@snotra.buserror.net>
	 <20131009220537.21e36770a44cf43a99a62247@linaro.org>
	 <6A3DF150A5B70D4F9B66A25E3F7C888D071AEED6@039-SN2MPN1-012.039d.mgd.msft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-10-10 at 03:01 -0500, Bhushan Bharat-R65777 wrote:
> 
> > -----Original Message-----
> > From: kvm-owner@vger.kernel.org [mailto:kvm-owner@vger.kernel.org] On Behalf Of
> > Kim Phillips
> > Sent: Thursday, October 10, 2013 8:36 AM
> > To: Wood Scott-B07421
> > Cc: Yoder Stuart-B08248; Wood Scott-B07421; christoffer.dall@linaro.org;
> > alex.williamson@redhat.com; linux-kernel@vger.kernel.org;
> > a.motakis@virtualopensystems.com; agraf@suse.de; Sethi Varun-B16395; Bhushan
> > Bharat-R65777; peter.maydell@linaro.org; santosh.shukla@linaro.org;
> > kvm@vger.kernel.org; gregkh@linuxfoundation.org
> > Subject: Re: RFC: (re-)binding the VFIO platform driver to a platform device
> > 
> > On Wed, 9 Oct 2013 15:03:19 -0500
> > Scott Wood <scottwood@freescale.com> wrote:
> > 
> > > On Wed, 2013-10-09 at 14:44 -0500, Yoder Stuart-B08248 wrote:
> > > > > From: Wood Scott-B07421
> > > > > Sent: Wednesday, October 09, 2013 2:22 PM
> > > > >
> > > > > On Wed, 2013-10-09 at 14:02 -0500, Yoder Stuart-B08248 wrote:
> > > > > > Have been thinking about this issue some more.  As Scott
> > > > > > mentioned,
> > 
> > thanks for bringing this up again.
> > 
> > > > > There's already a "bool suppress_bind_attrs" to prevent sysfs
> > > > > bind/unbind.  I suggested a similar flag to mean the oppsosite --
> > > > > bind
> > > > > *only* through sysfs.  Greg KH was skeptical and wanted to see a
> > > > > patch before any further discussion.
> > > >
> > > > Ah, think I understand now...yes that works as well, and would be
> > > > less intrustive.   So are you writing a patch? :)
> > >
> > > I've been meaning to since the previous round of discussion, but I've
> > > been busy.  Would someone else be able to test it in the context of
> > > using it for VFIO?
> > 
> > yes - see below.
> > 
> > > Otherwise, that looks about right, for the driver side (though
> > > driver_attach could error out earlier rather than testing it inside
> > > the loop).
> > 
> > I've made the changes you suggested and tested the resulting diff below on an
> > arndale board.  I successfully performed the following sequence of commands
> > after first changing the i2c@12C80000 node in the device tree to be exclusively
> > compatible with "vfio":

This is not the intended usage.  Leave the device tree alone, add a
wildcard option to platform_match() and use it in VFIO, and set
drv->sysfs_bind_only in VFIO.

> > diff --git a/drivers/base/bus.c b/drivers/base/bus.c index 73f6c29..da81442
> > 100644
> > --- a/drivers/base/bus.c
> > +++ b/drivers/base/bus.c
> > @@ -201,7 +201,8 @@ static ssize_t bind_store(struct device_driver *drv, const
> > char *buf,
> >  	int err = -ENODEV;
> > 
> >  	dev = bus_find_device_by_name(bus, NULL, buf);
> > -	if (dev && dev->driver == NULL && driver_match_device(drv, dev)) {
> > +	if (dev && dev->driver == NULL && (drv->sysfs_bind_only ||
> > +					   driver_match_device(drv, dev))) {
> 
> Should not we check 
>       if (dev && dev->driver == NULL &&
>           (device->explicit_bind_only && drv->explicit_bind_only) ||
>           driver_match_device(drv, dev)))

device->sysfs_bind_only would be a separate patch.

As for drv->sysfs_bind_only, that does not override
driver_match_device().  Wildcard matches are separate and are handled by
individual bus match functions.  This function does not need to be
changed at all for drv->sysfs_bind_only.

-Scott



