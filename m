Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981Ab3JIUD3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 16:03:29 -0400
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:45367
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751986Ab3JIUD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 16:03:26 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VS-5(zz98dI9371I936eI542I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275dhz2dh2a8h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h1155h)
Message-ID: <1381348999.7979.360.camel@snotra.buserror.net>
Subject: Re: RFC: (re-)binding the VFIO platform driver to a platform device
From: Scott Wood <scottwood@freescale.com>
To: Yoder Stuart-B08248 <B08248@freescale.com>
CC: Wood Scott-B07421 <B07421@freescale.com>,
        Kim Phillips <kim.phillips@linaro.org>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "a.motakis@virtualopensystems.com" <a.motakis@virtualopensystems.com>,
        "agraf@suse.de" <agraf@suse.de>,
        Sethi Varun-B16395 <B16395@freescale.com>,
        Bhushan Bharat-R65777 <R65777@freescale.com>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        "santosh.shukla@linaro.org" <santosh.shukla@linaro.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Date: Wed, 9 Oct 2013 15:03:19 -0500
In-Reply-To: <9F6FE96B71CF29479FF1CDC8046E15036DDAB4@039-SN1MPN1-002.039d.mgd.msft.net>
References: <1380738758.12932.43.camel@snotra.buserror.net>
	 <20131002184330.GC5108@cbox> <20131002203735.GA10871@kroah.com>
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
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-09 at 14:44 -0500, Yoder Stuart-B08248 wrote:
> 
> > -----Original Message-----
> > From: Wood Scott-B07421
> > Sent: Wednesday, October 09, 2013 2:22 PM
> > To: Yoder Stuart-B08248
> > Cc: Wood Scott-B07421; Kim Phillips; Christoffer Dall; Alex Williamson;
> > linux-kernel@vger.kernel.org; a.motakis@virtualopensystems.com;
> > agraf@suse.de; Sethi Varun-B16395; Bhushan Bharat-R65777;
> > peter.maydell@linaro.org; santosh.shukla@linaro.org; kvm@vger.kernel.org;
> > gregkh@linuxfoundation.org
> > Subject: Re: RFC: (re-)binding the VFIO platform driver to a platform
> > device
> > 
> > On Wed, 2013-10-09 at 14:02 -0500, Yoder Stuart-B08248 wrote:
> > > Have been thinking about this issue some more.  As Scott mentioned,
> > > 'wildcard' matching for a driver can be fairly done in the platform
> > > bus driver.  We could add a new flag to the platform driver struct:
> > >
> > > diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> > > index 4f8bef3..4d6cf14 100644
> > > --- a/drivers/base/platform.c
> > > +++ b/drivers/base/platform.c
> > > @@ -727,6 +727,10 @@ static int platform_match(struct device *dev,
> > struct device_driver *drv)
> > >         struct platform_device *pdev = to_platform_device(dev);
> > >         struct platform_driver *pdrv = to_platform_driver(drv);
> > >
> > > +       /* the driver matches any device */
> > > +       if (pdrv->match_any)
> > > +               return 1;
> > > +
> > >         /* Attempt an OF style match first */
> > >         if (of_driver_match_device(dev, drv))
> > >                 return 1;
> > >
> > > However, the more problematic issue is that a bus driver has no way to
> > > differentiate from an explicit bind request via sysfs and a bind that
> > > happened through bus probing.
> > 
> > Again, I think the wildcard match should be orthogonal to "don't bind by
> > default" as far as the mechanism goes.
> > 
> > There's already a "bool suppress_bind_attrs" to prevent sysfs
> > bind/unbind.  I suggested a similar flag to mean the oppsosite -- bind
> > *only* through sysfs.  Greg KH was skeptical and wanted to see a patch
> > before any further discussion.
> 
> Ah, think I understand now...yes that works as well, and would be
> less intrustive.   So are you writing a patch? :)

I've been meaning to since the previous round of discussion, but I've
been busy.  Would someone else be able to test it in the context of
using it for VFIO?

> It would be something like this, right?
> 
> diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> index 35fa368..c9a61ea 100644
> --- a/drivers/base/dd.c
> +++ b/drivers/base/dd.c
> @@ -389,7 +389,7 @@ static int __device_attach(struct device_driver *drv, void *data)
>  {
>         struct device *dev = data;
> 
> -       if (!driver_match_device(drv, dev))
> +       if (!drv->explicit_bind_only && !driver_match_device(drv, dev))
>                 return 0;

if (drv->explicit_bind_only || !driver_match_device(drv, dev))
	return 0;

>         return driver_probe_device(drv, dev);
> @@ -450,7 +450,7 @@ static int __driver_attach(struct device *dev, void *data)
>          * is an error.
>          */
> 
> -       if (!driver_match_device(drv, dev))
> +       if (!drv->explicit_bind_only && !driver_match_device(drv, dev))
>                 return 0;

Likewise -- or error out earlier in driver_attach().

Otherwise, that looks about right, for the driver side (though
driver_attach could error out earlier rather than testing it inside the
loop).

The other half of fixing the raciness is to ensure that the device
doesn't get bound back to a non-VFIO driver (e.g. due to a module load
or new_id).  The solution I proposed for that was a similar
explicit-bind-only flag for a device, that the user sets through sysfs
prior to unbinding.  This would also be useful in non-VFIO contexts to
simply say "I don't want to use this device at all".

-Scott



