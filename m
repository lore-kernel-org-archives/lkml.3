Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089AbaHUJ7m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 05:59:42 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:40032 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbaHUJ7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 05:59:41 -0400
Date: Thu, 21 Aug 2014 11:59:36 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Gyungoh Yoo <gyungoh@gmail.com>, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, grant.likely@linaro.org, sameo@linux.intel.com,
        jack.yoo@skyworksinc.com, jason@lakedaemon.net,
        heiko.stuebner@bqreaders.com, florian.vaussard@epfl.ch, andrew@lunn.ch,
        silvio.fricke@gmail.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Adding Skyworks SKY81452 MFD driver
Message-ID: <20140821095935.GB21848@ulmo>
References: <1407488899-31065-1-git-send-email-jack.yoo@skyworksinc.com>
 <20140821094502.GV4266@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i0/AhcQY5QxfSsSZ"
Content-Disposition: inline
In-Reply-To: <20140821094502.GV4266@lee--X1>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--i0/AhcQY5QxfSsSZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 21, 2014 at 10:45:02AM +0100, Lee Jones wrote:
[...]
> > diff --git a/drivers/mfd/sky81452.c b/drivers/mfd/sky81452.c
[...]
> > + * This program is free software; you can redistribute it and/or modif=
y it
> > + * under the terms of the GNU General Public License as published by t=
he
> > + * Free Software Foundation; either version 2, or (at your option) any
> > + * later version.
[...]
> > +	{ }
> > +};
> > +MODULE_DEVICE_TABLE(i2c, sky81452_ids);
> > +
> > +#ifdef CONFIG_OF
> > +static const struct of_device_id sky81452_of_match[] =3D {
> > +	{ .compatible =3D "skyworks,sky81452", },
> > +	{ }
> > +};
> > +MODULE_DEVICE_TABLE(of, sky81452_of_match);
> > +#endif
>=20
> You can drop the #differy the compiler should sort that out on the
> back of of_match_ptr().

It won't, unfortunately. If !OF, then of_match_ptr(x) will evaluate to
NULL, therefore sky81452_of_match will become unreferenced and cause the
compiler to output a warning. I guess it could be made __maybe_unused,
but I don't see that as much of an advantage over the #ifdef.

> > +static struct i2c_driver sky81452_driver =3D {
> > +	.driver =3D {
> > +		.name =3D "sky81452",
> > +		.of_match_table =3D of_match_ptr(sky81452_of_match),
> > +	},
> > +	.probe =3D sky81452_probe,
> > +	.remove =3D sky81452_remove,
> > +	.id_table =3D sky81452_ids,
> > +};
> > +
> > +module_i2c_driver(sky81452_driver);
> > +
> > +MODULE_DESCRIPTION("Skyworks SKY81452 MFD driver");
> > +MODULE_AUTHOR("Gyungoh Yoo <jack.yoo@skyworksinc.com>");
> > +MODULE_LICENSE("GPL");
>=20
> I think you want v2.

The header comment says "... version 2, or (at your option) any later
version.", so I think "GPL" is the right one here.

Thierry

--i0/AhcQY5QxfSsSZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT9cMHAAoJEN0jrNd/PrOh1nAP/ibwCyZ6zwTGfsPiSfM0gcLu
SL/6aOX8o87x+KWy/Vu46IszjbYNVQMfcgqe2kIoFF9Wp9K49Q3dYex+RcRDIvKp
XKNZl6BCeh9Rrn3pWp1lH3uL6MOI03uQr53El34ugH2tScTheMgc/kFGvqWz34Wz
IBtMq7LIF66pEJXGq5oi77rA/n45Im8LPSmb/PbXGAUh4J9Pk0fvDGrApRqXLaIo
Vwmw4S8CH8MtxuC4fzaPbxHAjh/xVPyDsUVRevAOxHyeoKA5189zv+hG45Aq1Mp8
TyIUyNkOAPIOXANmtFWc7TbVHBRoOJ5ISjFLzVNWxO4WuoCozYhrXC6//1p7ZS3k
UBgK0YEOgs3RPBEraoHmTosHcdFrIoo0ofTfefx+nR4UxS8k4zXTehGz1vzKCKYQ
LIkcrx5o7+zVz1/ESKe939UGgftPturQQ7tBjZGw6aBd8Q2IMI97xNLhqc4RX3xx
xw7OhvHlCmTSqw6jvZch/kZvc9Og8us+kZBcUEKYlTpOLkFB90yPQmRa94q3S0P4
Lx8CVUiy9nGjsWQQE38RF095ngGmDpICVCmF/Zw/vm9Fhj3YhxWpnquK/dJDw6sZ
2A4RWuFyEf5d9M71YniEAMuf78lJQpuTpizHiESUqqR2JVuI29azz7FUnKl7ik/C
ChFWSn7eMxD1wajAyzuz
=szSf
-----END PGP SIGNATURE-----

--i0/AhcQY5QxfSsSZ--
