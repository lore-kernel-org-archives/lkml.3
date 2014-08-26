Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758021AbaHZMiF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 08:38:05 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:35149 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757872AbaHZMiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 08:38:03 -0400
Message-ID: <53FC7FA2.1010201@ti.com>
Date: Tue, 26 Aug 2014 15:37:54 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Ian Abbott <abbotti@mev.co.uk>, <linux-fbdev@vger.kernel.org>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] video: da8xx-fb: preserve display width when changing
 HSYNC
References: <1404395199-5726-1-git-send-email-abbotti@mev.co.uk>
In-Reply-To: <1404395199-5726-1-git-send-email-abbotti@mev.co.uk>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="7RSmutHEFgX4pfSMU5NWQAbPU4P4MbH8l"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--7RSmutHEFgX4pfSMU5NWQAbPU4P4MbH8l
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 03/07/14 16:46, Ian Abbott wrote:
> When looking at this driver for a client, I noticed the code that
> configures the HSYNC pulse clobbers the display width in the same
> register.  It only preserves the MS part of the width in bit 3 and zero=
s
> the LS part of the width in bits 9 to 4.  This doesn't matter during
> initialization as the width is configured afterwards, but subsequent us=
e
> of the FBIPUT_HSYNC ioctl would clobber the width.
>=20
> Preserve bits 9 to 0 of LCD_RASTER_TIMING_0_REG when configuring the
> horizontal sync.
>=20
> Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
> ---
> I haven't tested this change, but it's pretty trivial.
> ---
>  drivers/video/fbdev/da8xx-fb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/video/fbdev/da8xx-fb.c b/drivers/video/fbdev/da8xx=
-fb.c
> index 788f6b3..10c876c 100644
> --- a/drivers/video/fbdev/da8xx-fb.c
> +++ b/drivers/video/fbdev/da8xx-fb.c
> @@ -419,7 +419,7 @@ static void lcd_cfg_horizontal_sync(int back_porch,=
 int pulse_width,
>  {
>  	u32 reg;
> =20
> -	reg =3D lcdc_read(LCD_RASTER_TIMING_0_REG) & 0xf;
> +	reg =3D lcdc_read(LCD_RASTER_TIMING_0_REG) & 0x3ff;
>  	reg |=3D (((back_porch-1) & 0xff) << 24)
>  	    | (((front_porch-1) & 0xff) << 16)
>  	    | (((pulse_width-1) & 0x3f) << 10);
>=20

Thanks, queued for 3.17 fixes.

 Tomi



--7RSmutHEFgX4pfSMU5NWQAbPU4P4MbH8l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT/H+iAAoJEPo9qoy8lh71BjsP/AsAEyfdizCCgIw3EQ+QpzVy
yqgjdB7c1raut8z/8ogyTceno8wZm6Wl+eWlkAJmhauXWU2UvVCllcczi9Av+Ps3
d3WKDnqfgc/qYgcE9lIsFGm4MA7hCEJSYY8EOCuRogXv2PE20qfE906ZiBsiLn6u
MJFqzEzpQPBC9kYecGYiODf4SooTreQ7V/HFgmvkeHpefHiuXc3mjC2Wge9FIPpM
8H5TE45f7B45l2NHNYKnmCArqGnyzy7syBHGIvQkRTmmuLk2PqKuUPr5HlC2Rh79
O5z6Gro5qoPWuxJR/Qh2oe6Vwmi/Vjf8cqlQOiHEyM+yKSbLraJLgqoiMe3z82lU
KoIkcfJAW/l6eXF8Zyfv90V1dkpMjzz/QOIY7kM7U7/Q0/NMYyVQj0RLCTM9LOqW
NEqPmGLGXLIwOVPGNoAWS+i1s1JzqWN+PUE6WpM+9+qqGgm4pfGac8Ycff4+eaa0
upfYX2/sVecrzrH613fDW8zFx9gkF1aeTmI/8zg1hchCWl+1027Nn0s0EkLW/pad
9pA4RWlPm+gNoLEzoG/8xUNFZvuw5cwXi0pqupImzw6ZTm8ULGJ6Y8ZlmGrS52Li
EN02O21gjtPimkSleDtglgu93xr7Uxc6+Zh87sqPJktQJ1AshtWJ7pKnPLTzUmOO
Ylx6RBc1PoU8cJB8bSVB
=4NXw
-----END PGP SIGNATURE-----

--7RSmutHEFgX4pfSMU5NWQAbPU4P4MbH8l--
