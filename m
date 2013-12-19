Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab3LSPgw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:36:52 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:51312 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682Ab3LSPgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:36:50 -0500
Date: Thu, 19 Dec 2013 09:36:08 -0600
From: Felipe Balbi <balbi@ti.com>
To: Apelete Seketeli <apelete@seketeli.net>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH v2 2/3] usb: musb: add support for JZ4740 usb device
 controller
Message-ID: <20131219153608.GK3985@saruman.home>
Reply-To: <balbi@ti.com>
References: <1387324561-21578-1-git-send-email-apelete@seketeli.net>
 <1387324561-21578-3-git-send-email-apelete@seketeli.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W/+CTqSGWdiRg+8j"
Content-Disposition: inline
In-Reply-To: <1387324561-21578-3-git-send-email-apelete@seketeli.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--W/+CTqSGWdiRg+8j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 18, 2013 at 12:56:00AM +0100, Apelete Seketeli wrote:
> Add support for Ingenic JZ4740 USB Device Controller through a
> specific musb glue layer.
>=20
> The platform data already available in tree for that USB Device
> Controller was previously used by an out-of-tree USB gadget driver
> which was not relying on the musb driver and was written by Ingenic
> and the Qi-Hardware community.
>=20
> JZ4740 UDC not being OTG compatible and missing some hardware
> registers, this musb glue layer is written from scratch to be used in
> gadget mode only and take silicon design specifics into account.
>=20
> Signed-off-by: Apelete Seketeli <apelete@seketeli.net>
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---
>  arch/mips/include/asm/mach-jz4740/platform.h |    1 +
>  arch/mips/jz4740/board-qi_lb60.c             |    1 +
>  arch/mips/jz4740/platform.c                  |   40 +++--
>  drivers/usb/musb/Kconfig                     |    8 +-
>  drivers/usb/musb/Makefile                    |    1 +
>  drivers/usb/musb/jz4740.c                    |  201 ++++++++++++++++++++=
++++++

you can split this patch. drivers part has no dependency on arch part.

> diff --git a/drivers/usb/musb/Kconfig b/drivers/usb/musb/Kconfig
> index 57dfc0c..a45ed15 100644
> --- a/drivers/usb/musb/Kconfig
> +++ b/drivers/usb/musb/Kconfig
> @@ -93,6 +93,12 @@ config USB_MUSB_BLACKFIN
>  config USB_MUSB_UX500
>  	tristate "Ux500 platforms"
> =20
> +config USB_MUSB_JZ4740
> +	tristate "JZ4740"
> +	depends on MACH_JZ4740

add || COMPILE_TEST

--=20
balbi

--W/+CTqSGWdiRg+8j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSsxJnAAoJEIaOsuA1yqRErk4QAJNIB6sWnnR/KWpMYDP26QUp
LJbopzv06gitC6xoSaKomoHv0DH8gc0+1yYAkHoli/GDnS1Powhh7sUTyCamY55D
pbw4FpctG+cp5GAQ9w0/6YsV+/aiSchkkLemWvnTBpBWJZsdlDDu0WBJ9w2M3fzS
TyZFZAoK3P+GZqAkd74DYvlr2u7f+70qdt7DJ21BcUkxCCC62smj+vBcn7EzLMFY
+ByDYsVTI8AtgaXWyPw/2SUYRXpqH6cJAlDPK5coD/0R8S3Z1Nk7H16eg+USyY/m
Q2KELd1F6J08RGp8oTwDwBAmzG42qr/RhKuyIovC+o15oOjgJSCrQeQTSU09ohqe
sE69jAkI+RwvpE3Wz5fqyDfhcKEO/oCa9ErRPmLtOLpm6cAiW919/6Z2lyUB0JN8
N9l31FU5PJAMS51hz3JwdjByulb0SCJHgi8aWOfR4Z1XEMDoOQMq/GWlAlXIxQZf
qR3ZqlRmWCZ4IIWV4tfEi6LnBkzWokD/VR41qxoVBSLHJHdD5BEwrw4SqTkfp3C4
bZ2LPzzLW8EwuwHdHhFcmNeBDbZnzBkxwK5ETTfXkp0/iQ435uCubWGDqV5aL/gz
LVOX4Uz7W6RB+Qu0YIArP5aTMLrVmCXP0mW2tmJNDw8MCgmVi9FvC7iEB7l/W1/a
e6vPKaztYneFXKz78qGs
=O0Pu
-----END PGP SIGNATURE-----

--W/+CTqSGWdiRg+8j--
