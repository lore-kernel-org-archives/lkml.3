Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588AbaIVIje (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 04:39:34 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:34090 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880AbaIVIjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 04:39:33 -0400
Date: Mon, 22 Sep 2014 10:39:30 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        linux-kernel@vger.kernel.org,
        =?utf-8?B?U3TDqXBoYW5l?= Marchesin <marcheu@chromium.org>
Subject: Re: [PATCH] drm/panel: update innolux n116bge timings
Message-ID: <20140922083929.GG1470@ulmo>
References: <1409626606-15225-1-git-send-email-djkurtz@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PyMzGVE0NRonI6bs"
Content-Disposition: inline
In-Reply-To: <1409626606-15225-1-git-send-email-djkurtz@chromium.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PyMzGVE0NRonI6bs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 02, 2014 at 10:56:46AM +0800, Daniel Kurtz wrote:
> There are several different models of N116BGE.  According to the commit
> that added innolux_n116bge_mode [0], this N116BGE is for the eDP variety.
>=20
> [0] commit 0a2288c06aab73c966e82045c8f20b0e713baf2a
>  Author: Thierry Reding <treding@nvidia.com>
>  Date:   Thu Jul 3 14:02:59 2014 +0200
>=20
>    drm/panel: simple: Add Innolux N116BGE panel support
>=20
> The clock and htotal values from add by that patch are out of spec accord=
ing to
> the datasheets I have seen for the eDP N116BGE (-EA2 and -EB2).

Does out of spec imply that these timings aren't working for you?

> This patch changes the values to the "Typ" values on the datasheet.

The original patch was based on -E42 of the datasheet. But I can run
some tests to see if the timings in this patch work on the panel that I
have. If so I guess the easiest would be to apply this.

It shouldn't matter all that much since the panel has EDID if I remember
correctly. The modes parsed from EDID should take precedence over the
fixed mode. If they don't then that's a bug.

Thierry

>=20
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> ---
>=20
> Thierry,
>=20
> It is possible that your timings were correct for the panel you are using=
 on
> the norrin reference board.  In that case I'm happy to upload a new patch
> that creates a new panel entry.  However, I'm pretty sure we are using the
> same N116BGE.
>=20
>  drivers/gpu/drm/panel/panel-simple.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel=
/panel-simple.c
> index 4ce1db0..776764a 100644
> --- a/drivers/gpu/drm/panel/panel-simple.c
> +++ b/drivers/gpu/drm/panel/panel-simple.c
> @@ -519,15 +519,15 @@ static const struct panel_desc foxlink_fl500wvr00_a=
0t =3D {
>  };
> =20
>  static const struct drm_display_mode innolux_n116bge_mode =3D {
> -	.clock =3D 71000,
> +	.clock =3D 76420,
>  	.hdisplay =3D 1366,
> -	.hsync_start =3D 1366 + 64,
> -	.hsync_end =3D 1366 + 64 + 6,
> -	.htotal =3D 1366 + 64 + 6 + 64,
> +	.hsync_start =3D 1366 + 136,
> +	.hsync_end =3D 1366 + 136 + 30,
> +	.htotal =3D 1366 + 136 + 30 + 60,
>  	.vdisplay =3D 768,
>  	.vsync_start =3D 768 + 8,
> -	.vsync_end =3D 768 + 8 + 4,
> -	.vtotal =3D 768 + 8 + 4 + 8,
> +	.vsync_end =3D 768 + 8 + 12,
> +	.vtotal =3D 768 + 8 + 12 + 12,
>  	.vrefresh =3D 60,
>  	.flags =3D DRM_MODE_FLAG_NHSYNC | DRM_MODE_FLAG_NVSYNC,
>  };
> --=20
> 2.1.0.rc2.206.gedb03e5
>=20

--PyMzGVE0NRonI6bs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUH+BBAAoJEN0jrNd/PrOhX4EP/214WlK99vJnEIFweB+x69gW
MT9wqNRjdPOqNjhC5t0oclitPQdnMeG5PiUVS9M/ZRhLePnpOeEsdg0F+j3zWR1C
ccmsCXAfLXLZ5OlaTmFetysyUkvMSCxuCjfOMuwLT8X233OI1wWYlsboRlonEBbG
vKDen4gJHg0k8YG1owm54+IzbwPzHQKMk40TcWndiAReI4x/Uqxd3NmTsoc+ucS5
kuTQgyoqtj7ustNt1jmx8lhZ8Bcmdt8IDfF/y/0N6Lin6V+MqGZ5yqlth08IaJHE
/NHdDIlZrToxOOwufX7tnIVTZhJ6l3pgPmdOgDOKMa4/mgW9UZO7NSrNzV7udGr1
3ofYH78Ua5SAT0bN/9bK5P1iU1IGnUTUinXC1A1ktvHGsN4RZeAevuz8UzSU2Nky
35FOdz86lYWNtPYcx0omKucc04Ahx7VL23oMpktMSWvIfp5sjb+jRnuPtNQsGKsb
brslV/tF5zIOpIFBVL/qStNaauwyxLVVYQHHiJoIsGy940R7WtXNOB6TuMW6jFVS
O2n6aZveYAIbZVf7xmkln1HdqsnGeF1GEYs67ZLYlOeI50eY6ZnJ9l904hDR2M6y
5Cy0G8sWqguvwtkQAhXIaVwlNEr5YYL+0XcCBEdXQ6N74DOCuw0gCn5mp+gRWpGk
kSX0tX+np8i7dRVhzAtQ
=bsSU
-----END PGP SIGNATURE-----

--PyMzGVE0NRonI6bs--
