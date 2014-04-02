Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161070AbaDBWeA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 18:34:00 -0400
Received: from ozlabs.org ([203.10.76.45]:36138 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030593AbaDBWd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 18:33:59 -0400
Date: Thu, 3 Apr 2014 09:33:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Linus <torvalds@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the tip tree with the omap_dss2
 tree
Message-Id: <20140403093351.12729ea091dba0fe6570823c@canb.auug.org.au>
In-Reply-To: <20140304161320.2d76810bf6bd8c6eb554b564@canb.auug.org.au>
References: <20140304161320.2d76810bf6bd8c6eb554b564@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__3_Apr_2014_09_33_51_+1100_1jFOf_L1cylAIGqh"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__3_Apr_2014_09_33_51_+1100_1jFOf_L1cylAIGqh
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

H all,

On Tue, 4 Mar 2014 16:13:20 +1100 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> Today's linux-next merge of the tip tree got conflicts in
> drivers/video/Kconfig, drivers/video/Makefile and drivers/video/sgivwfb.c
> between commit 08667731d1d4 ("video: move fbdev to drivers/video/fbdev")
> from the omap_dss2 tree and commit c5f9ee3d665a ("x86, platforms: Remove
> SGI Visual Workstation") from the tip tree.
>=20
> I removed drivers/video/fbdev/sgivwfb.c and added the following merge
> fix patch and can carry the fix as necessary (no action is required).

This resolution is now needed when the omap_dss2 tree is merged with
Linus' tree.

> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 4 Mar 2014 16:11:12 +1100
> Subject: [PATCH] video: fbdev: fix up fro removal of SGI Visual Workstati=
on
>=20
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/video/fbdev/Kconfig  | 11 +----------
>  drivers/video/fbdev/Makefile |  1 -
>  2 files changed, 1 insertion(+), 11 deletions(-)
>=20
> diff --git a/drivers/video/fbdev/Kconfig b/drivers/video/fbdev/Kconfig
> index 31c3f3ddfd38..6b1984c7f4e7 100644
> --- a/drivers/video/fbdev/Kconfig
> +++ b/drivers/video/fbdev/Kconfig
> @@ -765,18 +765,9 @@ config FB_HGA
>  	  As this card technology is at least 25 years old,
>  	  most people will answer N here.
> =20
> -config FB_SGIVW
> -	tristate "SGI Visual Workstation framebuffer support"
> -	depends on FB && X86_VISWS
> -	select FB_CFB_FILLRECT
> -	select FB_CFB_COPYAREA
> -	select FB_CFB_IMAGEBLIT
> -	help
> -	  SGI Visual Workstation support for framebuffer graphics.
> -
>  config FB_GBE
>  	bool "SGI Graphics Backend frame buffer support"
> -	depends on (FB =3D y) && (SGI_IP32 || X86_VISWS)
> +	depends on (FB =3D y) && SGI_IP32
>  	select FB_CFB_FILLRECT
>  	select FB_CFB_COPYAREA
>  	select FB_CFB_IMAGEBLIT
> diff --git a/drivers/video/fbdev/Makefile b/drivers/video/fbdev/Makefile
> index 6ef2c66110e3..0284f2a12538 100644
> --- a/drivers/video/fbdev/Makefile
> +++ b/drivers/video/fbdev/Makefile
> @@ -55,7 +55,6 @@ obj-$(CONFIG_FB_CG14)             +=3D cg14.o sbuslib.o
>  obj-$(CONFIG_FB_P9100)            +=3D p9100.o sbuslib.o
>  obj-$(CONFIG_FB_TCX)              +=3D tcx.o sbuslib.o
>  obj-$(CONFIG_FB_LEO)              +=3D leo.o sbuslib.o
> -obj-$(CONFIG_FB_SGIVW)            +=3D sgivwfb.o
>  obj-$(CONFIG_FB_ACORN)            +=3D acornfb.o
>  obj-$(CONFIG_FB_ATARI)            +=3D atafb.o c2p_iplan2.o atafb_mfb.o \
>                                       atafb_iplan2p2.o atafb_iplan2p4.o a=
tafb_iplan2p8.o

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__3_Apr_2014_09_33_51_+1100_1jFOf_L1cylAIGqh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTPJBUAAoJEMDTa8Ir7ZwVoAoP/0nE+jZWts8GkM5Xukv9PB3b
fcsm2lwJIdftWRQQ6CieyZZMb7oJJCyAoKbsLVbMcpUDMUxBOimNyHUDI1y3XZJ4
4LloZqXk22OMJtS9bswkpGqHelYbCk53+h3VCA1+a2+3/aiu95yzaXsVlNl7YFNs
wRIC168ty2oYB6ouX1WJVNdtRxgfBXYsbrBqsexR6OGz7c9qdtBiZK0zu9CYcWZR
IxLtfNIxiC4M4+5qxCDHQ46W8FhJD0Qlvyc3KWKQT8suF2+LYz/BGQS3XRdEHjh0
WUU75U49vX9claZ7wWCsjWSXXd8fv9XRzaf3LrfKHPu1gh4BrsLak5sxmeMIKGll
AYAgvPnmNiLDxODZwEcSyAFhJq2QDJCA0J44ax7H1wQCfZsvhm1EQsgLeDOVdx7N
cBEyigzbQCFB8LX+vGhmYqXLICYlaOOyDDWmd5k4Dh9hgrdpd5vTMa2XzvWcrWKh
EK9kd83iwb12zUnZlgZ4kQWzawzbau4AkQVnhXmqts87cZLf0HBTzPaw63nqx0ko
RlNRFLwq39CZHSO387DYsncTt/w7tyuSt1kDdqdtyfsg2iP5UgAK562JTg6kyS3T
VYptgYH4TcbTgpdJx3xo3uO2DMW7GSiupu/uaxoyPG2W5N4125RtoEDstpI7HkdI
Y3zoO1OuaDgCu0p/YbVz
=fe/k
-----END PGP SIGNATURE-----

--Signature=_Thu__3_Apr_2014_09_33_51_+1100_1jFOf_L1cylAIGqh--
