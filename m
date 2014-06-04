Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbaFDOt0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 10:49:26 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:35569 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbaFDOtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 10:49:25 -0400
Date: Wed, 4 Jun 2014 16:46:39 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: =?utf-8?Q?Rapha=C3=ABl?= Poggi <poggi.raph@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-pwm@vger.kernel.org
Subject: Re: pwm: atmel: problem when disable pwm
Message-ID: <20140604144639.GI28484@ulmo>
References: <CACqcpZDziJs7QUKVYwio=La5LyRzBd+xeeRW=dPFcPzw0Wrn5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="y96v7rNg6HAoELs5"
Content-Disposition: inline
In-Reply-To: <CACqcpZDziJs7QUKVYwio=La5LyRzBd+xeeRW=dPFcPzw0Wrn5Q@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--y96v7rNg6HAoELs5
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Adding in the linux-pwm mailing list.

On Wed, Jun 04, 2014 at 02:56:13PM +0200, Rapha=C3=ABl Poggi wrote:
> Hello,
>=20
> I'm using the pwm-atmel driver to control led, but i'm facing a problem.
>=20
> When writing "echo 0 > /sys/class/leds/d1/brightness" (to switch off
> the led) sometimes the led stayed active.
>=20
> After investigation I think this problem is due to this function:
>=20
> static void atmel_pwm_disable(struct pwm_chip *chip, struct pwm_device *p=
wm)
> {
>     struct atmel_pwm_chip *atmel_pwm =3D to_atmel_pwm_chip(chip);
>=20
>     atmel_pwm_writel(atmel_pwm, PWM_DIS, 1 << pwm->hwpwm);
>=20
>     clk_disable(atmel_pwm->clk);
> }
>=20
> By disable the pwm channel, I think the duty cycle "0" has not been
> update, and the channel is disable and stayed in active state (high or
> low depending of polarity).

This sounds like a bug that could be fixed by this commit:

	916030db4399 pwm: atmel: correct CDTY calculation

What version of the kernel are you seeing this problem with? The above
commit was first added in v3.15-rc1, so maybe try that or any later
version to see if that fixes it.

Thierry

--y96v7rNg6HAoELs5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTjzFPAAoJEN0jrNd/PrOhFwYP/jilqQOr3F9spUHB4AwtN8F4
97kAO9/pUda4tAmGxjtHkDskhc8T//g12IpThz9HTmX+BdvxB7he/syy8iAeA5b5
jjwdxnQ2QeQ89I9C7pyQOyMPMGW3VP+0hk1OMmGT6tImk2ZRZHJH6RGMRpGY1ovp
1l3/L/VhBET7QDNi8dheAVCjeSBQZL51PX1h1e7b9Im+ttbiB9wL46B4kQsI1J5S
qrOmHkJ7PxfBcJ5ghf1M64LNLnFj+aDMitrBuSBDAXCIfe1ikZliB4e2nfHCkO1C
93n/dkzYAIwutrg5kHPwuPvXY/VfFpeZO6gPEN86Vdw8Q7lVo1KPTN2KCZQrJDyp
/imFgkor8NGe1ZU9bRXMQRCcR/o1AUg8NPYUwKavi8baa0uIjT0+yF+eeLICujsz
0xhn0PJgso6h6rebLquHnCa3i4Z2N69f7Nh3XHFLCUyF/KkXWBx3GUTAtJhsd06N
QFi/mKmwci5Lnz2XEti3A/S/TArIz2BaCGWYkIGGBFxL6+fJ6Y4lJ/Pzsz4ys6Fz
oKxxx+xpmnjPB2OIhJJ9/Yem0eDTHMwck7hEPserjqhHU8/SeRgx9N1YGdYZcSPY
Z5OPcgUMfN4fhieHRgBhCyRCdnB70e0KTD8zqKM2KxCfk50ek3vYWFoh+UPPuAhT
h+nVYTUXfEg6pP36PCos
=M8dI
-----END PGP SIGNATURE-----

--y96v7rNg6HAoELs5--
