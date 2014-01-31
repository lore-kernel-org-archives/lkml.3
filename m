Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933013AbaAaVd5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 16:33:57 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:57897 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754343AbaAaVdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 16:33:55 -0500
Date: Fri, 31 Jan 2014 15:32:05 -0600
From: Felipe Balbi <balbi@ti.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        <linux-pm@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, Kevin Hilman <khilman@linaro.org>,
        Tero Kristo <t-kristo@ti.com>
Subject: Re: [RFC/PATCH] base: platform: add generic clock handling for
 platform-bus
Message-ID: <20140131213205.GB2502@saruman.home>
Reply-To: <balbi@ti.com>
References: <1391191965-31102-1-git-send-email-balbi@ti.com>
 <20140131200434.GR27282@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="f2QGlHpHGjS2mn6Y"
Content-Disposition: inline
In-Reply-To: <20140131200434.GR27282@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f2QGlHpHGjS2mn6Y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jan 31, 2014 at 08:04:35PM +0000, Russell King - ARM Linux wrote:
> On Fri, Jan 31, 2014 at 12:12:45PM -0600, Felipe Balbi wrote:
> > diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> > index 3a94b79..86aeb5b 100644
> > --- a/drivers/base/platform.c
> > +++ b/drivers/base/platform.c
> > @@ -484,6 +484,21 @@ static int platform_drv_probe(struct device *_dev)
> >  	if (ACPI_HANDLE(_dev))
> >  		acpi_dev_pm_attach(_dev, true);
> > =20
> > +	dev->fck =3D devm_clk_get(_dev, "fck");
> > +	dev->ick =3D devm_clk_get(_dev, "ick");
> > +
> > +	if (!IS_ERR(dev->fck))
> > +		clk_prepare_enable(dev->fck);
> > +	else
> > +		dev->fck =3D NULL;
> > +
> > +	if (!IS_ERR(dev->ick))
> > +		clk_prepare_enable(dev->ick);
> > +	else
> > +		dev->ick =3D NULL;
>=20
> If people are going to continue doing this (converting error values to
> NULL) can we please have a check in devm_clk_get() which prevents it
> returning NULL if the implementation happens to do so?
>=20
> It's either that or we force all users to conform to the API which
> specifies that the error values are defined by IS_ERR() returning
> true and everything else must be considered as a potential valid return.

The idea here was just to avoid IS_ERR() checks every time we want to
enable/disable a clock since clk API already copes with NULL pointers.

This also helps with the fact that platform_bus is also used with
platforms which don't have (or otherwise don't need) any clock control
whatsoever, thus made it optional.

If everybody prefers duplication of IS_ERR() all over the place, that's
fine too.

--=20
balbi

--f2QGlHpHGjS2mn6Y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJS7BZVAAoJEIaOsuA1yqREhGQP/1BOlpNC2Er9AYOagHeDSKws
zr35jW4HUj3Vjzu9ivrqnRZt08pVF0Li/q4xsmG2rQdSsEnqcw50Li8fIvAFa2mQ
2e2ZizpEyac9eVvbXzuBPaWfpVF8OFmLhPVePo/cVATVCW1/jQl5gzz11tmc6LGj
0wN48n03U2zmvmt/eF9T8dUqWmGuv6mbP5yunqw3mwGijDve6i6mRVj+gscfmn8D
jCRJumn9TkZH+7TcVJH4zHtb9jbej5PEIF5uArWeSnF2yC9vlcI+ulGSmU/KNEs9
2ABCkcZh+anG5S41pk2t786dU8ML2pMuKtfb+JIarWPRSs54/uVvLl/qbw9vHvaL
/yEziYt2AOx/6T+VQ9CF1+9oXQ9Nd92/1G/qjsyGJ3Gjt/YRtK+ncIHFoltHVSGa
0WlUzwZ2awfnAHROHLgcPLqB65BnSTFX6N+yEkfqWI7bPYYCvWyfNhNN3VXS/4m7
Tni8zEHFQOJxMpgei1ug3pJZzIM0xkED5UXWbGja/Kn+AiNML8PSW+s4IQps5zPn
q9Baf1zBSQ603AwAeF4hOn0+UcP6zRy9kGMVlO+MsQJb1QvZS+Q7zto0BrFJzSrW
VNoVmrui0Pcol25z00qNjLWousNt4/+A73DF01zuDhoYgL/ZDwyeF+yMV5hMOlVJ
f2ZTNgmsOImwBQnzFHWl
=Whb0
-----END PGP SIGNATURE-----

--f2QGlHpHGjS2mn6Y--
