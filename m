Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214AbaDGLhr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 07:37:47 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:54071 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274AbaDGLhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 07:37:43 -0400
Date: Mon, 7 Apr 2014 13:36:53 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Lothar =?utf-8?Q?Wa=C3=9Fmann?= <LW@KARO-electronics.de>,
        linux-kernel@vger.kernel.org, linux-pwm@vger.kernel.org,
        Shawn Guo <shawn.guo@linaro.org>, Sascha Hauer <kernel@pengutronix.de>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCHv3 1/3] pwm: make the PWM_POLARITY flag in DTB optional
Message-ID: <20140407113652.GE26985@ulmo>
References: <1395235375-12925-1-git-send-email-LW@KARO-electronics.de>
 <1395996540-10999-1-git-send-email-LW@KARO-electronics.de>
 <1395996540-10999-2-git-send-email-LW@KARO-electronics.de>
 <20140402055350.GX17250@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qFgkTsE6LiHkLPZw"
Content-Disposition: inline
In-Reply-To: <20140402055350.GX17250@pengutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qFgkTsE6LiHkLPZw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 02, 2014 at 07:53:50AM +0200, Sascha Hauer wrote:
> On Fri, Mar 28, 2014 at 09:48:58AM +0100, Lothar Wa=C3=9Fmann wrote:
[...]
> > @@ -183,8 +173,11 @@ static void of_pwmchip_add(struct pwm_chip *chip)
> >  		return;
> > =20
> >  	if (!chip->of_xlate) {
> > -		chip->of_xlate =3D of_pwm_simple_xlate;
> > -		chip->of_pwm_n_cells =3D 2;
> > +		chip->of_xlate =3D of_pwm_xlate;
> > +		if (chip->ops->set_polarity)
> > +			chip->of_pwm_n_cells =3D 3;
> > +		else
> > +			chip->of_pwm_n_cells =3D 2;
>=20
> I think the presence of the set_polarity callback shouldn't influence
> the number of cells the parser expects. As commented on 2/2 this doesn't
> actually mean the device actually support polarity inversion.

How so? A driver should only implement .set_polarity() if it supports
changing the polarity.

That said, I agree that the presence of .set_polarity() shouldn't
determine the number of cells. You could have any number of other flags
set via the third cell.

> Also, polarity inversion could still be done in software for hardware
> that doesn't support it.

No. You cannot emulate polarity inversion in software.

Thierry

--qFgkTsE6LiHkLPZw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTQo3UAAoJEN0jrNd/PrOhQNcP/RJV8/Ub9uxHf8c3Z9JvTtAW
5xXXWe97oNT+G+Hfhfb01NcmYKQUvffryGQw7fX9aR7HSU3TyOJXwSRo+imLEz/B
XEHzM4mX3taKVRH8XQsJrcmD1e7U2JhxVqtSv3aFxxT2uMlNp900/G5nGogsSFPi
1N07P/d5yWP+WjriG6IAuaYd5JlfB7Vo24ptUeTiY0AXAWV/u4KMocSr6WemzkvZ
yk2R8pMvOiGc3yjAFW7eh6bMi1enDqfx+HXoIEtk5CIAWBWD0dl4hqEdXoo9P/ZU
cjuxB/ecQoef/aiAGecHDIH0sRrAaS7T/8dbzXZWt/y4AD0tkC0xax0jR2PWCvFd
qE2tovVKPzyDVnxxGlXjRABNbU3SyjpS2GbSLx0lwbcnlVONywHaqFK2nzxZ0f8w
qGVJZmB0O+nTttPqBIAfivr8BrgSEF6z+BQqFKdIn02xWfHlyRNE1Idh+GEuczUt
Xi/bMMX0txFCDLFXrTA0WkO7MakQaJJm1+NM20aP1fW11VXD5c+eNmv0qPJRs90S
kDTHAy/B+lmNGD3hnN6zonP5d9xVuxozTgT5hn14M/PDW7Ym+N3pOmxgbCTJXpzh
iTzdYmjy23C8A8cM0WaOp2qPZ5SzOmx+RCE010eTJH4BQjVL3TCZNXGV41CAttHB
6f/RbHEeybUZcB06EM34
=Ou+i
-----END PGP SIGNATURE-----

--qFgkTsE6LiHkLPZw--
