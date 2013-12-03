Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab3LCLMX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 06:12:23 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54922 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529Ab3LCLMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 06:12:20 -0500
Message-ID: <529DBC81.5030805@pengutronix.de>
Date: Tue, 03 Dec 2013 12:12:01 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Chris Ruehl <chris.ruehl@gtsys.com.hk>
CC: peter.chen@freescale.com, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3 v4] usb: chipidea: Reallocate regmap only if lpm is
 detected
References: <1386057710-3848-1-git-send-email-chris.ruehl@gtsys.com.hk>
In-Reply-To: <1386057710-3848-1-git-send-email-chris.ruehl@gtsys.com.hk>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="TgCl74V2hBUa28oexmCPLAlBB4cATjTEI"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--TgCl74V2hBUa28oexmCPLAlBB4cATjTEI
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 12/03/2013 09:01 AM, Chris Ruehl wrote:
> usb: chipidea: Reallocate regmap only if lpm is detected
>=20
> The regmap only needs to reallocate if the hw_read on the CAP register =
shows
> lpm is used. Therefore the if() statement check the change.
>=20
> Signed-off-by: Chris Ruehl <chris.ruehl@gtsys.com.hk>
> Acked-by: Peter Chen <peter.chen@freescale.com>
> ---
>  drivers/usb/chipidea/core.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/usb/chipidea/core.c b/drivers/usb/chipidea/core.c
> index 5d8981c..9a5ef20 100644
> --- a/drivers/usb/chipidea/core.c
> +++ b/drivers/usb/chipidea/core.c
> @@ -208,7 +208,8 @@ static int hw_device_init(struct ci_hdrc *ci, void =
__iomem *base)
>  	reg =3D hw_read(ci, CAP_HCCPARAMS, HCCPARAMS_LEN) >>
>  		__ffs(HCCPARAMS_LEN);
>  	ci->hw_bank.lpm  =3D reg;
> -	hw_alloc_regmap(ci, !!reg);
> +	if (reg)
> +		hw_alloc_regmap(ci, !!reg);
>  	ci->hw_bank.size =3D ci->hw_bank.op - ci->hw_bank.abs;
>  	ci->hw_bank.size +=3D OP_LAST;
>  	ci->hw_bank.size /=3D sizeof(u32);
> @@ -642,6 +643,10 @@ static int ci_hdrc_probe(struct platform_device *p=
dev)
>  			: CI_ROLE_GADGET;
>  	}
> =20
> +	/* only update vbus status for peripheral */
> +	if (ci->role =3D=3D CI_ROLE_GADGET)
> +		ci_handle_vbus_change(ci);
> +

This change seems unrelated to me.

Marc

>  	ret =3D ci_role_start(ci, ci->role);
>  	if (ret) {
>  		dev_err(dev, "can't start %s role\n", ci_role(ci)->name);
>=20


--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--TgCl74V2hBUa28oexmCPLAlBB4cATjTEI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlKdvIIACgkQjTAFq1RaXHO4CgCcDXjl3Og9VLXeknyx5T3PV/s1
/sIAn0Kkbh1w+r3Tnm4atO+3QFZsJeJV
=iMbz
-----END PGP SIGNATURE-----

--TgCl74V2hBUa28oexmCPLAlBB4cATjTEI--
