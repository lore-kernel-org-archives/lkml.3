Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932094AbaA1QvA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 11:51:00 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:55986 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754645AbaA1Qu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 11:50:58 -0500
Date: Tue, 28 Jan 2014 10:49:37 -0600
From: Felipe Balbi <balbi@ti.com>
To: "xinhui.pan" <xinhuix.pan@intel.com>
CC: <linux-kernel@vger.kernel.org>, <linux-gpio@vger.kernel.org>,
        <david.a.cohen@linux.intel.com>, <linus.walleij@linaro.org>,
        <gnurou@gmail.com>, <yanmin_zhang@linux.intel.com>
Subject: Re: [PATCH] gpio-intel-mid: fix the incorrect return of idle callback
Message-ID: <20140128164937.GA30226@saruman.home>
Reply-To: <balbi@ti.com>
References: <52E76F71.4080304@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ikeVEW9yuYc//A+q"
Content-Disposition: inline
In-Reply-To: <52E76F71.4080304@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 28, 2014 at 04:50:57PM +0800, xinhui.pan wrote:
> From: "xinhui.pan" <xinhuiX.pan@intel.com>
>=20
> intel_gpio_runtime_idle should return correct error code if it do fail.
> make it more correct even though -EBUSY is the most possible return value.
>=20
> Signed-off-by: bo.he <bo.he@intel.com>
> Signed-off-by: xinhui.pan <xinhuiX.pan@intel.com>
> ---
>  drivers/gpio/gpio-intel-mid.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/gpio/gpio-intel-mid.c b/drivers/gpio/gpio-intel-mid.c
> index d1b50ef..05749a3 100644
> --- a/drivers/gpio/gpio-intel-mid.c
> +++ b/drivers/gpio/gpio-intel-mid.c
> @@ -394,7 +394,9 @@ static const struct irq_domain_ops intel_gpio_irq_ops=
 =3D {
> =20
>  static int intel_gpio_runtime_idle(struct device *dev)
>  {
> -	pm_schedule_suspend(dev, 500);
> +	int err =3D pm_schedule_suspend(dev, 500);
> +	if (err)
> +		return err;
>  	return -EBUSY;

wait, is it only me or this would look a lot better as:

static int intel_gpio_runtime_idle(struct device *dev)
{
	return pm_schedule_suspend(dev, 500);
}

cheers

--=20
balbi

--ikeVEW9yuYc//A+q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJS59+hAAoJEIaOsuA1yqREGd0P/0Db9lH3ObkPedJCWHGMIwLy
DRgJi321M2MpJhvjfyw5HELcaXH3NUEmOrhJCnJbBuR8rMD8saOWMKYXo3sd6pxg
zjIYOD4xJ5M6MEFcMWyNbTdiPsh2B6hxOiA260E4hIYqBF4V8xXjzbGdJ7vr7WhL
gsWSqkXbOWTaNeZTDmDl7rTMZ7OBQFHClOgquniNZUZH7JSgCjx8h4xo2rc+Kl8p
vBTlYEnRgce/SAjUx3d6wdqcCaFRM2F9kjhhb8tlGKNVElWmSxzLGVGSm5ceF3zv
F3grfjBvA0gPMqgYtKvLsBoKu81V6P0+11/A4mRPzuPYg4FLgh5vP6a8foxJkYpD
9225SyYjhmuWz81JtlEyn8hCZO6DGhZbhscCNjQHJvxrcu5LlXOdH+hDjMvlk/bG
8AcQ5QEP1IDsHqiAUG9jMT+DIxelxtMgqJAOwqZ2vTNJdn0uXj3NVgHWCKLycRof
pREIhaozMLLMnKfIQKrgf83WVttm+PSnU1wqdJ5bZtAFZqqEEM1Prr2REroVX+GO
+XeJw8MF3qTa33hbmR/SGJhWB5FR8MrcaXhIUyMCcbWSMeymSd80zKnpkq/ByG0C
nL2Ym5qOhONXR4+LEaxY4LtmQrG4xJ6HcNQ2OugpcDY5bkBgUWrXl8/LHWZjwcPe
sysEm6zPw+z+o+SQagQ4
=Z/07
-----END PGP SIGNATURE-----

--ikeVEW9yuYc//A+q--
