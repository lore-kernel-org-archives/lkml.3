Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445AbaJNSTR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 14:19:17 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:49199 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755375AbaJNSTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 14:19:14 -0400
Date: Tue, 14 Oct 2014 13:19:01 -0500
From: Felipe Balbi <balbi@ti.com>
To: David Cohen <david.a.cohen@linux.intel.com>
CC: <linus.walleij@linaro.org>, <linux-gpio@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <balbi@ti.com>,
        <stable@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: Re: [PATCH v2] pinctrl: baytrail: show output gpio state correctly
 on Intel Baytrail
Message-ID: <20141014181901.GD18747@saruman>
Reply-To: <balbi@ti.com>
References: <1413224639-21552-1-git-send-email-david.a.cohen@linux.intel.com>
 <1413309277-32485-1-git-send-email-david.a.cohen@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="g7w8+K/95kPelPD2"
Content-Disposition: inline
In-Reply-To: <1413309277-32485-1-git-send-email-david.a.cohen@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--g7w8+K/95kPelPD2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 14, 2014 at 10:54:37AM -0700, David Cohen wrote:
> Even if a gpio pin is set to output, we still need to set INPUT_EN
> functionality (by clearing INPUT_EN bit) to be able to read the pin's
> level.
>=20
> E.g. without this change, we'll always read low level state from sysfs.
>=20
> Cc: <stable@vger.kernel.org> # v3.14+
> Cc: Mathias Nyman <mathias.nyman@linux.intel.com>
> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>

Reviewed-by: Felipe Balbi <balbi@ti.com>

> ---
>=20
> v1 to v2: improved patch's body description as requested by Felipe Balbi
> ---
>=20
>  drivers/pinctrl/pinctrl-baytrail.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/pinctrl/pinctrl-baytrail.c b/drivers/pinctrl/pinctrl=
-baytrail.c
> index e12e5b07f6d7..c23d8ded936d 100644
> --- a/drivers/pinctrl/pinctrl-baytrail.c
> +++ b/drivers/pinctrl/pinctrl-baytrail.c
> @@ -318,7 +318,7 @@ static int byt_gpio_direction_output(struct gpio_chip=
 *chip,
>  		"Potential Error: Setting GPIO with direct_irq_en to output");
> =20
>  	reg_val =3D readl(reg) | BYT_DIR_MASK;
> -	reg_val &=3D ~BYT_OUTPUT_EN;
> +	reg_val &=3D ~(BYT_OUTPUT_EN | BYT_INPUT_EN);
> =20
>  	if (value)
>  		writel(reg_val | BYT_LEVEL, reg);
> --=20
> 2.1.0
>=20

--=20
balbi

--g7w8+K/95kPelPD2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUPWkVAAoJEIaOsuA1yqREX/gP/2ZVnuFrAXQ+MankSxtZ8/uB
AeiuUBN9DG0JqQ1FNQ0/5Ve4iYEx8o2CRdsco7zxWXfYhiUD01ghORFyvDbfRH3D
0GirFxWsJHvpBayL8qBm7CBgxMGVjzO9SFpq8zP38MT84wRZAc5ZOzxDESZEw0rf
vR8MDpucsoLjZerjcegpTFqRf/fW+lHSHOyN0TimQbeLAJP0iDjkEChalecaCY9p
ibXeby7V9YA/wVUviBdGJx3btMPBu2m51nxjN4kbzcthQdHL29j0A103hu3Zrom1
a+tMDjYa/fhPNMfRsf1ZpDWnk3ntdjFkaw4E+jHP3S0suCjKktZfcCep2F+KOeNG
EiikqOu6Z5toxF1y72rhF5aWhYb47PziwlkGaCNOuqstUD8XaX6JqqfKOb1iSWp1
Ayi4r8NJ8hNOrLZtj5eb6UB1b7EqK45nUDQuIMgtPpyMXd+WL5v8r4zLqsWdZ6WO
n53x/S5gc0V2uUcQpdeXd/RBeQtOH+kB0Un9qqdrgSp3QaOjNigg8CmIA+K3h3uh
5iTd2ZEzsD3TU5QM/5ZZE1drUmHn81V56EV0kVIBXj6rma9IzoFHzWU0FXinZOdR
qym0/Y//osM4ctPDeKKbdRManwFki05MHbYlH6g990Oc+IXfEK/99mcBP7lvSo41
Ozoqida1T5T2TU+z3jr9
=4zHm
-----END PGP SIGNATURE-----

--g7w8+K/95kPelPD2--
