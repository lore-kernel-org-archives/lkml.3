Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171AbaBTMDt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 07:03:49 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40012 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065AbaBTMDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 07:03:46 -0500
Date: Thu, 20 Feb 2014 13:03:40 +0100
From: Markus Pargmann <mpa@pengutronix.de>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@pengutronix.de, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/2] regulator: core: Replace direct ops->disable usage
Message-ID: <20140220120340.GB21048@pengutronix.de>
References: <1392894472-11956-1-git-send-email-mpa@pengutronix.de>
 <1392894472-11956-3-git-send-email-mpa@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rJwd6BRFiFCcLxzm"
Content-Disposition: inline
In-Reply-To: <1392894472-11956-3-git-send-email-mpa@pengutronix.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 13:01:31 up 179 days, 21:32, 54 users,  load average: 0.04, 0.09,
 0.11
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rJwd6BRFiFCcLxzm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 20, 2014 at 12:07:52PM +0100, Markus Pargmann wrote:
> There are many places where ops->disable is called directly. Instead we
> should use _regulator_do_disable() which also handles gpio regulators.
>=20
> Cc: <stable@vger.kernel.org> # 3.10+
> Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
> ---
>  drivers/regulator/core.c | 32 +++++++++++++-------------------
>  1 file changed, 13 insertions(+), 19 deletions(-)
>=20
> diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
> index 017f5cb..a0c916f 100644
> --- a/drivers/regulator/core.c
> +++ b/drivers/regulator/core.c

=2E..

> @@ -3641,12 +3637,10 @@ int regulator_suspend_finish(void)
>  		} else {
>  			if (!have_full_constraints())
>  				goto unlock;
> -			if (!ops->disable)
> -				goto unlock;
>  			if (!_regulator_is_enabled(rdev))
>  				goto unlock;
> =20
> -			error =3D ops->disable(rdev);
> +			error =3D _regulator_do_disable(rdev);

ops is unused and creates a compile warning. I will resend later with
the 'ops' variable removed from the function.

Regards,

Markus

--=20
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--rJwd6BRFiFCcLxzm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTBe8cAAoJEEpcgKtcEGQQHTQQALmqnj80O6LZ5jBx9ps3BWVo
e5Hws6D9ivCupkbkCS+Vm2tld+pUo+3uH1DYCzDS2ibFeNa0JVXWbz1kuJqqENKk
CaVCIrvc/HHPXfKrBpZcmrw8jAwbRNIxHwitOOgZP/k8vSjw7s+bc3qgy0gPhyR/
toLpXyYFgR57MnYKDywiyjjF+mZT7o8fe25/cKaqduCPOr36vW13/bXktqAcD376
TfFIjbeVVqK9k1WdQaj6oh+247ydaFEfz1UoFVFb5HJbZWz53RkcRVBnEqCLsslW
XL7XFXtgKwN0GchbdULL9txe8ob06sqpyGsqEl5jBrRD9/bmPVr/+3Dyfrv+Y0u7
CztHfJbA5uMNMVzm/JFjFiUImzGa7QqXt0NT8dDnrXWGuFhtQjXtGcWG2sxCaZJ0
5sD+Ogkqjs1Gh1Q5gnFqYAu0uWpTXDKL82TLr05X/SZWSSnGXzVnKLwohCMjNVvK
1jr1EnIvdpnUDTWqndxPUkyNZQ6NM6urTMjyQQJtnW342sqd025Di9u7km0T+JTQ
ZbXtROsCNVgphKBdaug8yNnuKDuZdrd1zXrnNKPorbjgeX15y/SQFxiY4MoryYx/
MtiOYyJ8yDZOFQBekXZmcZbihJYMDscCCwca3afycGIn3JOK8e+5wVfuPwzoN83U
56hrs0XNl7TM20lQnxFR
=rm8r
-----END PGP SIGNATURE-----

--rJwd6BRFiFCcLxzm--
