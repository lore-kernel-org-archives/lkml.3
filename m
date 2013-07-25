Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001Ab3GYUwi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 16:52:38 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:48889 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab3GYUwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 16:52:36 -0400
Date: Thu, 25 Jul 2013 23:52:24 +0300
From: Felipe Balbi <balbi@ti.com>
To: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
CC: "Ivan T. Ivanov" <iivanov@mm-sol.com>, "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: dwc3: core: modify IO memory resource after
 deferred probe completes
Message-ID: <20130725205224.GA12209@radagast>
Reply-To: <balbi@ti.com>
References: <1374769590-14491-1-git-send-email-iivanov@mm-sol.com>
 <A2CA0424C0A6F04399FB9E1CD98E030458DE112E@US01WEMBX2.internal.synopsys.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YZ5djTAD1cGYuMQK"
Content-Disposition: inline
In-Reply-To: <A2CA0424C0A6F04399FB9E1CD98E030458DE112E@US01WEMBX2.internal.synopsys.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jul 25, 2013 at 07:46:58PM +0000, Paul Zimmerman wrote:
> > diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> > index 607bef8..50c833f 100644
> > --- a/drivers/usb/dwc3/core.c
> > +++ b/drivers/usb/dwc3/core.c
> > @@ -384,21 +384,6 @@ static int dwc3_probe(struct platform_device *pdev)
> >  		dev_err(dev, "missing memory resource\n");
> >  		return -ENODEV;
> >  	}
> > -	dwc->xhci_resources[0].start =3D res->start;
> > -	dwc->xhci_resources[0].end =3D dwc->xhci_resources[0].start +
> > -					DWC3_XHCI_REGS_END;
> > -	dwc->xhci_resources[0].flags =3D res->flags;
> > -	dwc->xhci_resources[0].name =3D res->name;
> > -
> > -	res->start +=3D DWC3_GLOBALS_REGS_START;
> > -
> > -	 /*
> > -	  * Request memory region but exclude xHCI regs,
> > -	  * since it will be requested by the xhci-plat driver.
> > -	  */
> > -	regs =3D devm_ioremap_resource(dev, res);
> > -	if (IS_ERR(regs))
> > -		return PTR_ERR(regs);
> >=20
> >  	if (node) {
> >  		dwc->maximum_speed =3D of_usb_get_maximum_speed(node);
> > @@ -452,6 +437,22 @@ static int dwc3_probe(struct platform_device *pdev)
> >  		return -EPROBE_DEFER;
> >  	}
> >=20
> > +	dwc->xhci_resources[0].start =3D res->start;
> > +	dwc->xhci_resources[0].end =3D dwc->xhci_resources[0].start +
> > +					DWC3_XHCI_REGS_END;
> > +	dwc->xhci_resources[0].flags =3D res->flags;
> > +	dwc->xhci_resources[0].name =3D res->name;
> > +
> > +	res->start +=3D DWC3_GLOBALS_REGS_START;
>=20
> Ick. The driver is modifying the struct resource passed to it by the

heh...

> platform code? That seems like a layering violation, and is fragile as
> hell. In addition to this bug, what would happen if the struct resource
> was declared 'const'?

nothing would happen if it was declared const since platform_add_device
makes a copy of what was declared, and that's always non-const.

Also, this is not *modifying* what was passed, just skipping the xHCI
address space so we don't request_mem_region() an area we won't really
handle and prevent xhci-hcd.ko from probing.

--=20
balbi

--YZ5djTAD1cGYuMQK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR8ZAIAAoJEIaOsuA1yqREzZ4QAKr+/5a1UX0ATZuUCb/euihF
tLmrAUjkAIbFruS4zR2xf+KTB98e2BgA27qT+998aHOfQatQd3FbBqMC3rWpbiz4
9CGvXEXw73VCENxHIOKzj50Yd+Zk2AOmcvswCxIeLHe737gZgrvEJdYJU28YMEzK
NwBbKUGLwoJ4VuJDZxM7dWPPNHbZk8pQPaYQBXtmoRen89Ay3ZBqAPXp+n15c5fg
iJy8iMWn0QBxBltoTyxria667eKYlQg/IIkaO3HAzjaiUOIk5x44FHgUcR5ePR+8
5QNihkLhSTtt9fXU36tjslCkxKBrH21ft1hbOi/xcQTKEs1RpYML4IAAach0bmt7
Gtu18Wtt5Mz3dUOs82f3ZIUYKtoDPzMuL6gHtwRC+a6ztqLH4FAC5IKrzJkbj+Ba
AH16xCYQSIjJCyI71S3+P8PIQlvRI97QVBKJhqIXUUw44NbA5IV2Qh1nZekpNfBc
caXr5SuSUn4nAydV354BMzvcElk50791hieJiTHLMNqrF/5A95ZEVKqkCRT4NbSU
iQTFGzeBh/fL4p01LlHFEfK5BkmMBiDmiKXy+7R/EoXID5CJO/0u3wzY761UW9um
fZTLXjsEZD3XUVXGO7iJv5LRh0+ZCcgDEBvzIHFdOITMiR5WL5szwc0+j8BbLhgN
Nkl8TBky5fZBfLOntjBl
=MgHP
-----END PGP SIGNATURE-----

--YZ5djTAD1cGYuMQK--
