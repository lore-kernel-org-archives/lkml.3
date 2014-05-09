Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbaEIJyN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 05:54:13 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:49880 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674AbaEIJyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 05:54:12 -0400
Message-ID: <536CA5BC.8080106@ti.com>
Date: Fri, 9 May 2014 12:54:04 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Fabian Frederick <fabf@skynet.be>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] drivers/video/fbdev/core/fbmem.c: remove positive
 test on unsigned values
References: <20140425221511.1c8dc66551123166c7f27a9c@skynet.be>
In-Reply-To: <20140425221511.1c8dc66551123166c7f27a9c@skynet.be>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="X1DRJjknNHdx0TQEEFf54Gp07acdxB3dS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--X1DRJjknNHdx0TQEEFf54Gp07acdxB3dS
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 25/04/14 23:15, Fabian Frederick wrote:
> fb_image.dx, fb_image.dy and fbconf2bmap.framebuffer are __u32
>=20
> Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
> Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  drivers/video/fbdev/core/fbmem.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/video/fbdev/core/fbmem.c b/drivers/video/fbdev/cor=
e/fbmem.c
> index b6d5008..583896e 100644
> --- a/drivers/video/fbdev/core/fbmem.c
> +++ b/drivers/video/fbdev/core/fbmem.c
> @@ -433,7 +433,7 @@ static void fb_do_show_logo(struct fb_info *info, s=
truct fb_image *image,
>  			image->dx +=3D image->width + 8;
>  		}
>  	} else if (rotate =3D=3D FB_ROTATE_UD) {
> -		for (x =3D 0; x < num && image->dx >=3D 0; x++) {
> +		for (x =3D 0; x < num; x++) {
>  			info->fbops->fb_imageblit(info, image);
>  			image->dx -=3D image->width + 8;
>  		}
> @@ -445,7 +445,7 @@ static void fb_do_show_logo(struct fb_info *info, s=
truct fb_image *image,
>  			image->dy +=3D image->height + 8;
>  		}
>  	} else if (rotate =3D=3D FB_ROTATE_CCW) {
> -		for (x =3D 0; x < num && image->dy >=3D 0; x++) {
> +		for (x =3D 0; x < num; x++) {
>  			info->fbops->fb_imageblit(info, image);
>  			image->dy -=3D image->height + 8;
>  		}
> @@ -1179,7 +1179,7 @@ static long do_fb_ioctl(struct fb_info *info, uns=
igned int cmd,
>  			return -EFAULT;
>  		if (con2fb.console < 1 || con2fb.console > MAX_NR_CONSOLES)
>  			return -EINVAL;
> -		if (con2fb.framebuffer < 0 || con2fb.framebuffer >=3D FB_MAX)
> +		if (con2fb.framebuffer >=3D FB_MAX)
>  			return -EINVAL;
>  		if (!registered_fb[con2fb.framebuffer])
>  			request_module("fb%d", con2fb.framebuffer);
>=20

Looks fine to me. Queued for 3.16.

 Tomi



--X1DRJjknNHdx0TQEEFf54Gp07acdxB3dS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTbKW8AAoJEPo9qoy8lh71itQP/038F7D5FChnxKb3u6rOsX6G
vuOGTF8tVYz3nTQDb547NaRFlgQunoon/EnlL6+6HhkdqHZ8a5af1zL78n30Z4Jq
lElldkHDcWttnskuwQzFxBlFGqOfFAzPM58ckpU3fwcSFuQZGGh7VOcnPcfjC54D
pNJJK3PvyZFae0cV86aSqW+Xg5HE5/KytTCAvasyTO6jVxOso1idmHywyIvX6Cbw
H4qztSblt4vRQ+EchBqdbWmU8NRCBRxhPQaBbLWyAAPbsVQchxZpN+JlBF+QS/la
5yLOPr6XgQ90wRmnW0fi81M4uZ+fyqxmHTeBuXGOt6/rdJLOl1v9JkmW/LI4qSu2
rjwclnScX0YP30S7Fu9tsRHi+EuiimONJJlCCMYxLZ5DUS4QnPJ0FAEYi6HD1v3s
NFW5+zDV2Rv8nWzjt79zelLSJlLamqGL649Y9+kDIEo/tu59liyghLdF8GsegIql
5uI8SWOdq4nef9kgR3lrbvH4KLirQA6d7e9mkCxZfDmQsqzNfjhZxpqGvVCX4O3i
16gd8ETD1VQwVKcIJKfMidgZpQNfEFRDPAAS/lZ4/iCmTSRyKCDPF0RIXC2xAqK/
DWlkDQeKeHuTCH5+hXjz6zCJN74CjrqZl1ECfi+QApi/omylxg0ijY27GTJIRWAn
hzX/YJqGXD4/YyYoI9Zr
=VRkQ
-----END PGP SIGNATURE-----

--X1DRJjknNHdx0TQEEFf54Gp07acdxB3dS--
