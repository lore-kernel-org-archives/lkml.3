Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936273AbaH1CVL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 22:21:11 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:45697 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932284AbaH1CVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 22:21:07 -0400
Date: Wed, 27 Aug 2014 21:20:53 -0500
From: Felipe Balbi <balbi@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: <kishon@ti.com>, <balbi@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 1/5] usb: phy: twl4030-usb: Remove unused irq_enabled
Message-ID: <20140828022051.GB5273@saruman.home>
Reply-To: <balbi@ti.com>
References: <1409182091-31191-1-git-send-email-tony@atomide.com>
 <1409182091-31191-2-git-send-email-tony@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Clx92ZfkiYIKRjnr"
Content-Disposition: inline
In-Reply-To: <1409182091-31191-2-git-send-email-tony@atomide.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Clx92ZfkiYIKRjnr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Aug 27, 2014 at 04:28:07PM -0700, Tony Lindgren wrote:
> It's not being used any longer.
>=20
> Signed-off-by: Tony Lindgren <tony@atomide.com>
> ---
>  drivers/phy/phy-twl4030-usb.c     | 2 --
>  drivers/usb/phy/phy-twl6030-usb.c | 2 --
>  2 files changed, 4 deletions(-)
>=20
> diff --git a/drivers/phy/phy-twl4030-usb.c b/drivers/phy/phy-twl4030-usb.c
> index 9cd33a4..bc28ecc 100644
> --- a/drivers/phy/phy-twl4030-usb.c
> +++ b/drivers/phy/phy-twl4030-usb.c
> @@ -164,7 +164,6 @@ struct twl4030_usb {
>  	enum omap_musb_vbus_id_status linkstat;
>  	bool			vbus_supplied;
>  	u8			asleep;
> -	bool			irq_enabled;
> =20
>  	struct delayed_work	id_workaround_work;
>  };
> @@ -755,7 +754,6 @@ static int twl4030_usb_probe(struct platform_device *=
pdev)
>  	 * set_host() and/or set_peripheral() ... OTG_capable boards
>  	 * need both handles, otherwise just one suffices.
>  	 */
> -	twl->irq_enabled =3D true;
>  	status =3D devm_request_threaded_irq(twl->dev, twl->irq, NULL,
>  			twl4030_usb_irq, IRQF_TRIGGER_FALLING |
>  			IRQF_TRIGGER_RISING | IRQF_ONESHOT, "twl4030_usb", twl);

can you split this into two patches ? drivers/phy will be taken by
Kishon and drivers/usb/phy by me. another possibility is that I get an
Acked-by from Kishon and I can take $subject as is.

--=20
balbi

--Clx92ZfkiYIKRjnr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT/pIDAAoJEIaOsuA1yqRErO0P/RoHxd35SH6to1xRaFl5V4wq
FiOuPtTmWtls0W7lVm4dvfU+FETILmdMgQz/EPSGtofKq9hEGYzvcOnp0pL5JIRx
HP1MlaO3gkUomwy9Ejehvw2oX48HYsPrs2GNcLIvjqFCxHYJjtVeOWpffn11I3MR
Y5CyjlBEgcQqZKfxmcrAZAHqSpxCe3YDBilUGlK+iSaiCBr61mhc7HfNFcv9BA+E
VQVbBu0En+vtuSjiwp/VJOPgMMFQPZ1jSEYLN8R+neHYyG6jlzp8mTEUCxYfD7Pk
LNkNoQdBx4YiOIHmjQ3QliMI8AbT6fdn3Cja3ItRDAmtJASaQK8K4vABFYP/+TkO
cnJ4MdRdcAmO6eBx3d4Jl+C2r/2Uf6tpUKbstzkhARnADYvO7r9EvXhMaqarz+Jr
4gMnMkES0yoIpSuxgHtgaah5TlbaKIsx2hmcDu0kBe8JHa5yeebOYlbidbrG+8VY
I64REtAfVr3WIZno+QUq7atN0OAyB6K4995X5amCwiCQQh3YDePw8trcg7bQtV0H
FfwapPn+uHCdWkPJWFKMiJEZLuFXw6Y2vmvuZfkdXkx9+EEzWQQKruI/ZJHDrHOh
58ukG5BCtkqnSyLtdqOW241d2mC7C05rtHpZPaHIaqZHCDqJvLJqOHK/DfNikLjF
b7iWpws1zDsQPULeh73P
=PWJi
-----END PGP SIGNATURE-----

--Clx92ZfkiYIKRjnr--
