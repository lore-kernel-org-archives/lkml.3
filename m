Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090AbaJPOKG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 10:10:06 -0400
Received: from top.free-electrons.com ([176.31.233.9]:39298 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752143AbaJPOKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 10:10:04 -0400
Date: Thu, 16 Oct 2014 16:05:20 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de, Russell King <linux@arm.linux.org.uk>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v2 14/53] dmaengine: dw: Split device_control
Message-ID: <20141016140520.GL19438@lukather>
References: <1413454672-27400-1-git-send-email-maxime.ripard@free-electrons.com>
 <1413454672-27400-15-git-send-email-maxime.ripard@free-electrons.com>
 <1413458248.2396.15.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Rl6QTk5rIKeAVhSO"
Content-Disposition: inline
In-Reply-To: <1413458248.2396.15.camel@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Rl6QTk5rIKeAVhSO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 16, 2014 at 02:17:28PM +0300, Andy Shevchenko wrote:
> On Thu, 2014-10-16 at 12:17 +0200, Maxime Ripard wrote:
> > Split the device_control callback of the DesignWare DMA driver to make =
use
> > of the newly introduced callbacks, that will eventually be used to retr=
ieve
> > slave capabilities.
>=20
> I will look at the main patches in the series later, but now I would
> like to comment this one.
>=20
> >=20
> > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > ---
> >  drivers/dma/dw/core.c | 92 +++++++++++++++++++++++++++----------------=
--------
> >  1 file changed, 49 insertions(+), 43 deletions(-)
> >=20
> > diff --git a/drivers/dma/dw/core.c b/drivers/dma/dw/core.c
> > index 1af731b83b3f..a3d3a51387c6 100644
> > --- a/drivers/dma/dw/core.c
> > +++ b/drivers/dma/dw/core.c
> > @@ -955,8 +955,7 @@ static inline void convert_burst(u32 *maxburst)
> >  		*maxburst =3D 0;
> >  }
> > =20
> > -static int
> > -set_runtime_config(struct dma_chan *chan, struct dma_slave_config *sco=
nfig)
> > +static int dwc_config(struct dma_chan *chan, struct dma_slave_config *=
sconfig)
>=20
>=20
> >  {
> >  	struct dw_dma_chan *dwc =3D to_dw_dma_chan(chan);
> > =20
> > @@ -977,29 +976,54 @@ set_runtime_config(struct dma_chan *chan, struct =
dma_slave_config *sconfig)
> >  	return 0;
> >  }
> > =20
> > -static inline void dwc_chan_pause(struct dw_dma_chan *dwc)
> > +static inline void dwc_chan_resume(struct dw_dma_chan *dwc)
>=20
> Could we keep the order of functions as previous?

Sure, I'll change that in the next version.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--Rl6QTk5rIKeAVhSO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUP9CgAAoJEBx+YmzsjxAgaNwQAK3ACCN9Zp2AIarhgLaSqLhW
G66W8hCFU6cPmAa5brQykG3BCkNvnFE21ZIH6GcWZDzdj1XaUC+lMZff6Mzx05N/
CqOcBUP6XSJORHLFiO55QoFiCxw8RYwRB/0Ru7S2YyH7mCm0ejQ3EHzkWySVk7WH
H7Ob4OHnGfcrtEFdYoRZH54uCWKv1IEsUpDJyo8CAem8cD7HB/Vu7pAaASv0Gfk3
nOWcbRQmsBKrejHkl7n68ypCDgZ23jlg9HV5AYBr/h3Er7HyYUjeXlQCq8bLusMs
3Lxxyoei0uju1VyViEPBXEJdFLapmrVk8AHuOr4V8KbXinF+hcqZOsfV7cEFzN/d
KWlBsmTJLh38nlxXtpGNYWeN50CtO0mIXDCcf/Yks1kEvDH4LK7t1R2IJhYSspVo
TrwMU1HtEzmWDpwGal7q3oMoDIjgYETiNeTsU1J1Z/ZXSWUk54Gv5grohkoXlsOx
HG9PGNpqAFdF/1pzcmoYq4DlKZBUf/CwQty6ao3CQHAQzwY4cHf2/QR8xU21HTVR
keVS0rWSWtm+YO/EKf3P8T0IPrnnR/auieHkJJ/yYC1ZUW+G5SE1cwD4ADw2H0Ti
4oJWU2hdSRSzFJoVhc/IHEFbAHGpxkH2mlLol7hkNogv87fvcPMvkK5o3ZAMbZux
Q+uK1EalVn5TGEO1Rzhb
=K8aA
-----END PGP SIGNATURE-----

--Rl6QTk5rIKeAVhSO--
