Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898AbaJ0QmZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 12:42:25 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52808 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752877AbaJ0QmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 12:42:20 -0400
Date: Mon, 27 Oct 2014 11:41:17 -0500
From: Felipe Balbi <balbi@ti.com>
To: Romain Perier <romain.perier@gmail.com>
CC: <heiko@sntech.de>, <devicetree@vger.kernel.org>, <broonie@kernel.org>,
        <lgirdwood@gmail.com>, <linux-kernel@vger.kernel.org>,
        <grant.likely@linaro.org>, <robh@kernel.org>, <mark.rutland@arm.com>,
        <johan@kernel.org>, <linux-pm@vger.kernel.org>, <linux@roeck-us.net>,
        <lee.jones@linaro.org>, <balbi@ti.com>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <linux@arm.linux.org.uk>,
        <swarren@wwwdotorg.org>, <thierry.reding@gmail.com>,
        <gnurou@gmail.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v2 06/10] mfd: tps65910: Use the standard DT property
 system-power-controller
Message-ID: <20141027164117.GD14253@saruman>
Reply-To: <balbi@ti.com>
References: <1414427215-14380-1-git-send-email-romain.perier@gmail.com>
 <1414427215-14380-6-git-send-email-romain.perier@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J5MfuwkIyy7RmF4Q"
Content-Disposition: inline
In-Reply-To: <1414427215-14380-6-git-send-email-romain.perier@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--J5MfuwkIyy7RmF4Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 27, 2014 at 04:26:51PM +0000, Romain Perier wrote:
> No longer use custom property to define poweroff capability, use the stan=
dard
> DT property instead.
>=20
> Signed-off-by: Romain Perier <romain.perier@gmail.com>
> ---
>  drivers/mfd/tps65910.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
> index 7612d89..a7faff2 100644
> --- a/drivers/mfd/tps65910.c
> +++ b/drivers/mfd/tps65910.c
> @@ -423,8 +423,7 @@ static struct tps65910_board *tps65910_parse_dt(struc=
t i2c_client *client,
> =20
>  	board_info->irq =3D client->irq;
>  	board_info->irq_base =3D -1;
> -	board_info->pm_off =3D of_property_read_bool(np,
> -			"ti,system-power-controller");
> +	board_info->pm_off =3D of_is_system_power_controller();

you didn't build-test this, did you ?

--=20
balbi

--J5MfuwkIyy7RmF4Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUTnWtAAoJEIaOsuA1yqREV/AP/j9Gw17BJgvYFgc3TEk+bn9O
g6L15DZJu3NBBBKGPhFCCgX47ot4BgkZtgWQVY7HZ64rFpHANCKyEeua0QfvaXTZ
VVWmoQ2z3z4Q+7PN6qTUqu38hD/CvzbDcMuMF6taY+P0Jy3IiaGBpV8PPddOeN8R
eqTulq8wKkHV4eFzLRYYgLiFWT4LwEF1zqlALpys5vDuoupz4bqyUsEUvVilCjpb
pHACXWGOjNUQHuTqFBe0kxQpr5iNzNoe6X7z6ZHP/2zezBklomtqcdelh0+IaEFd
hSKjEt4qv3aqQKj40YcgqA2+oCOpYhU+ZWXqgu6O/HBrGwaSHbqvvK4hD/L+3+OK
RJ2eAjdskIbNNQ46xJMiMd0/0mFqFwkU4Hf8m/stJxLE9tkN90U0aYb2V1Q/r5su
m1YxWI779PCAApIkuxPBxweXXIzIit08Iojk4NuSLgnfFdsUK2mSmNP6cpILCEkA
1kUCJXouHYFxFAOcu+Js0P4LAjxFl4CJwcx0Q+7fk2nmgEuB0rNE0jbiS1Hv1WSz
dWUzFn7mAnsfOupFZARpnxmZ4OvqyasvvfSG/thEF+Mbr6aYNt2seY4OGRVHHwNZ
1tgelfFYjI1euTBubhhBpi0Fgt4Rm4YMpU4rnOf3BhOLJdgvLkIgixbSZgBJiqhi
31X1Ked47wo6OnLtbYIC
=1rq7
-----END PGP SIGNATURE-----

--J5MfuwkIyy7RmF4Q--
