Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864AbaKCKAR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 05:00:17 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41093 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbaKCKAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 05:00:15 -0500
Date: Mon, 3 Nov 2014 11:00:12 +0100
From: Markus Pargmann <mpa@pengutronix.de>
To: Hugh Kang <hugh.kang@lge.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, jonghoon.park@lge.com
Subject: Re: [PATCH] regulator: adding disable options for
 regulator-always-on and regulator-boots-on
Message-ID: <20141103100012.GD24292@pengutronix.de>
References: <1414978003-20437-1-git-send-email-hugh.kang@lge.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="96YOpH+ONegL0A3E"
Content-Disposition: inline
In-Reply-To: <1414978003-20437-1-git-send-email-hugh.kang@lge.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:56:25 up 18 days, 21:10, 56 users,  load average: 0.06, 0.22,
 0.17
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--96YOpH+ONegL0A3E
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Nov 03, 2014 at 10:26:43AM +0900, Hugh Kang wrote:
> From: "hugh.kang" <hugh.kang@lge.com>
>=20
> If a regulator is set by always-on option, the regulator will be set fore=
ver.
> For example, suppose LDO1 is set to always-on at RevA.dts with including =
of a.dtsi. After that
> RevB.dts may wants to include the same a.dtsi but override the LDO1 alway=
s-on option. However,
> currently there is no way to delete the always-on option, even when we ch=
ange the LDO1 option value,
> the always-on setting is still remains.

Why don't you split your devicetrees according to the real hardware and
set the always-on property only for revA?

Regards,

Markus

>=20
> Signed-off-by: hugh.kang <hugh.kang@lge.com>
> ---
>  drivers/regulator/of_regulator.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>=20
> diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regu=
lator.c
> index ee5e67b..4178dbd 100644
> --- a/drivers/regulator/of_regulator.c
> +++ b/drivers/regulator/of_regulator.c
> @@ -52,7 +52,13 @@ static void of_get_regulation_constraints(struct devic=
e_node *np,
>  		constraints->valid_ops_mask |=3D REGULATOR_CHANGE_CURRENT;
> =20
>  	constraints->boot_on =3D of_property_read_bool(np, "regulator-boot-on");
> +	if (of_property_read_bool(np, "regulator-disable-boot-on"))
> +		constraints->boot_on =3D false;
> +
>  	constraints->always_on =3D of_property_read_bool(np, "regulator-always-=
on");
> +	if (of_property_read_bool(np, "regulator-disable-always-on"))
> +		constraints->always_on =3D false;
> +
>  	if (!constraints->always_on) /* status change should be possible. */
>  		constraints->valid_ops_mask |=3D REGULATOR_CHANGE_STATUS;
> =20
> --=20
> 1.8.3.2
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>=20

--=20
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--96YOpH+ONegL0A3E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUV1IsAAoJEEpcgKtcEGQQrNoQALaWNoyQcY8ZfH7DHCfjfF3i
pNdO8d8OAjrsAByoz/Iy9XD6Wzw7gqlRB9/9tzglwdV3tQSsbeu0qxADpOVyv0Aj
PDqpV9ogpuH6uEEE285SeMN6WxESir0fmuJp+5ETWEeeTJJARs/Xlhs2fwi2Zs3b
olkTWw5PTwezqM81ouxDFAU1+3Mg2icm8c62jEQrWYOIJ1/kfzPHhErharfMh/E9
dEUSyih3v0bDwxCNHcsHqWNXF6yub/FBermOQiQEFbY0dvutZH7iuz+eIAoB8SwY
McDmorkidwfz/EEhKwMIBRw9x2xtgTRIdR3MbwsclbCpvSDrRX56s5cOVg9XLCzD
Tk20MjgzxGHzFEzj3oEDBmI7ESmgAcgFL9mKiBvmOJL+Jve8fNb+zt8mjHzh3x8p
w4Duays4zQAhNF+cToKm7QpNHwh3tT/De5aWlsWj5vf02J/sldb+3NUgKITkNA+y
4hpXMK3E0JxWr3J8FD+sT9u+NGhQU2VWhpf9/Q+UqxTaLzsnQLHHVFwM2e/0drzc
9U4HsxJyf4lgTb+e2+hWqqikP0vQM4z0pPT3mv+wpnSG5GokIL5Gzh/BuBcUxx+B
DzvMT9BKL30SiNrFTXK+enm4BNeJ25oedz4Fqoz8rtxvBqIB0p7uDvG0sNh/FiMx
7Ggzw3u3v9YoNBZzH/1V
=8M8d
-----END PGP SIGNATURE-----

--96YOpH+ONegL0A3E--
