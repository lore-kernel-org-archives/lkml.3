Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266Ab3JAUzA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 16:55:00 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:47243 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab3JAUy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 16:54:57 -0400
Date: Tue, 1 Oct 2013 22:53:11 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Tony Lindgren <tony@atomide.com>, Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        openezx-devel@lists.openezx.org, linux-samsung-soc@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/10] pwm-backlight: Use an optional power supply
Message-ID: <20131001205310.GD9201@ulmo.nvidia.com>
References: <1379972467-11243-1-git-send-email-treding@nvidia.com>
 <1379972467-11243-10-git-send-email-treding@nvidia.com>
 <524B17ED.1080806@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qrgsu6vtpU/OV/zm"
Content-Disposition: inline
In-Reply-To: <524B17ED.1080806@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Qrgsu6vtpU/OV/zm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 01, 2013 at 12:43:57PM -0600, Stephen Warren wrote:
> On 09/23/2013 03:41 PM, Thierry Reding wrote:
> > Many backlights require a power supply to work properly. This commit
> > uses a power-supply regulator, if available, to power up and power down
> > the panel.
>=20
> I think that all backlights require a power supply, albeit the supply
> may not be SW-controllable. Hence, shouldn't the regulator be mandatory
> in the binding, yet the driver be defensively coded such that if one
> isn't specified, the driver continues to work?

That has already changed in my local version of this patch.

> > diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight=
/pwm_bl.c
>=20
> > @@ -253,6 +264,16 @@ static int pwm_backlight_probe(struct platform_dev=
ice *pdev)
> >  		}
> >  	}
> > =20
> > +	pb->power_supply =3D devm_regulator_get_optional(&pdev->dev, "power");
>=20
> ... so I think that should be devm_regulator_get(), since the regulator
> isn't really optional.
>=20
> > +	if (IS_ERR(pb->power_supply)) {
> > +		if (PTR_ERR(pb->power_supply) !=3D -ENODEV) {
> > +			ret =3D PTR_ERR(pb->power_supply);
> > +			goto err_gpio;
> > +		}
> > +
> > +		pb->power_supply =3D NULL;
>=20
> If devm_regulator_get_optional() returns an error value or a valid
> value, then I don't think that this driver should transmute error values
> into NULL; NULL might be a perfectly valid regulator value. Related, I
> think the if (pb->power_supply) tests should be replaced with if
> (!IS_ERR(pb->power_supply)) instead.

All of that is already done in my local tree. This actually turns out to
work rather smoothly with the new support for optional regulators. The
regulator core will give you a dummy regulator (assuming it's there
physically but hasn't been wired up in software) that's always on, so
the driver doesn't even have to special case it anymore.

Thierry

--Qrgsu6vtpU/OV/zm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSSzY2AAoJEN0jrNd/PrOhbosQAI8JpuY1LGvyC3O93TMjpk2Y
JicLAk8h13WtQR+o1efNd0XkNJZ3rCX3qSr4aneLVKu0IdppFATnuD4rfd9z+R/u
ZD9Gb5CUBGKFGJWdi2K7awNQff7XWtCtwGRw0B8DXl1fWe6gCwtnvc41OZgRyJcB
icoatpV4xjRrIWYx44WS0uyC3vjhuxOIqMM3/nkfGLpzWySq+awyz4qzXrVP/cN9
Tl6WJtjlozamsq7Gx6ywqUrTiyJdZsPpu8k88f9phDlVMNxJkkehw+uOqqu8C1pt
GEt+6DbeyPxDkgueeWHI20FJeK1wF26xHtpHaY5iy14veH5rSFqqBgtN9/0ONujQ
XfudBxC8ZxF/lMpuTDVoo6O3GaplSNvsmO6iyeG79bvuHxpqE0VQYoiB25V6wG01
mZyuLs5qX2WS8gumzNxJeNJWPO85eKdCPuOd2OKEAMJTQCguruwEfJHuuLUe3tkU
Kqi2H8pGu7SQhYom/CR9wtfMEz3ypHWBo/qoCC/ZCgaA7Q7iUOJMYfUsJYTvwG/u
SOqoFWBeicJXLW1qfeUZ6veksTyDu3gtsx6Rqgbd8ca/B5cK2C99zqsZhyvKKA4U
QNUk0esD29BtCyTVx+UeHNd6YEBPjq9S1wWYGeykx8u7Zxf2onkqAcX13G3ZQ3AD
eKYYhEPMdTQmC+NOt7Uy
=9gdD
-----END PGP SIGNATURE-----

--Qrgsu6vtpU/OV/zm--
