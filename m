Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757753AbaFTUPF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 16:15:05 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:34031 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805AbaFTUPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 16:15:01 -0400
Date: Fri, 20 Jun 2014 22:14:57 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Alban Bedel <alban.bedel@avionic-design.de>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/panel: add support for Innolux N156BGE-L21 panel
Message-ID: <20140620201456.GA28814@mithrandir>
References: <1402585745-28127-1-git-send-email-alban.bedel@avionic-design.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EeQfGwPcQSOJBaQU"
Content-Disposition: inline
In-Reply-To: <1402585745-28127-1-git-send-email-alban.bedel@avionic-design.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 12, 2014 at 05:09:05PM +0200, Alban Bedel wrote:
> This panel is used by the Medcom Wide and supported by the
> simple-panel driver.
>=20
> Signed-off-by: Alban Bedel <alban.bedel@avionic-design.de>
> ---
>  drivers/gpu/drm/panel/panel-simple.c | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
>=20
> diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel=
/panel-simple.c
> index 309f29e..6a361bb 100644
> --- a/drivers/gpu/drm/panel/panel-simple.c
> +++ b/drivers/gpu/drm/panel/panel-simple.c
> @@ -372,6 +372,28 @@ static const struct panel_desc samsung_ltn101nt05 =
=3D {
>  	},
>  };
> =20
> +static const struct drm_display_mode innolux_n156bge_l21_mode =3D {
> +	.clock =3D 69300,
> +	.hdisplay =3D 1366,
> +	.hsync_start =3D 1366,
> +	.hsync_end =3D 1366,
> +	.htotal =3D 1366 + 100,
> +	.vdisplay =3D 768,
> +	.vsync_start =3D 768,
> +	.vsync_end =3D 768,
> +	.vtotal =3D 768 + 20,

The timings here look slightly strange. Typically

	.{h,v}display < .{h,v}sync_start < .{h,v}hsync_end < .{h,v}total

Given your timings above essentially means that the vsync pulse starts
immediately after the last active pixel or line and is of length zero.

> +	.vrefresh =3D 60,
> +};
> +
> +static const struct panel_desc innolux_n156bge_l21 =3D {
> +	.modes =3D &innolux_n156bge_l21_mode,
> +	.num_modes =3D 1,
> +	.size =3D {
> +		.width =3D 1366,
> +		.height =3D 768,

This size is the physical size (in mm) of the active area of the panel.

> +	},
> +};
> +
>  static const struct of_device_id platform_of_match[] =3D {
>  	{
>  		.compatible =3D "auo,b101aw03",
> @@ -389,6 +411,9 @@ static const struct of_device_id platform_of_match[] =
=3D {
>  		.compatible =3D "samsung,ltn101nt05",
>  		.data =3D &samsung_ltn101nt05,
>  	}, {
> +		.compatible =3D "innolux,n156bge-l21",
> +		.data =3D &innolux_n156bge_l21,
> +	}, {

This patch should also be adding a device tree binding document for this
panel.

Thierry

--EeQfGwPcQSOJBaQU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTpJZAAAoJEN0jrNd/PrOhwXAQAMFtUt3QkXHbG2qxJgNNbp+0
7WIFLPIgsTxYBOAWB2LAH9F2n3hA/2R+GWU4uSWIHZbW8bA+yyzUvBYh1PX2t7MY
tpgIfqUJjz07tLsA0fGrmIw8mlCHfCEivOkI7FpkE2oVs4dTowZr012c2hp11dx2
084IuvZINPO/HwXfp78isArqN1JLm1N9Ssoyzaw1LGk2BXPddYDX+FWyUIlyTmDK
BU61USEL3DwxX1RNvgT/RudVP7Flm+QjmpCrBEbVSDqDa+gDnmhPPSrIzh9haeeI
rDY9AoBii9fprhkX/WArl6hucjgn81hYWaZCaui3BX28vmI5lt1WMsXP0ZmUDV6F
EXntfTheEabiZY5Vhv3WR7s31a0IVBdevEa+ZNdEB/c667YL3j4Z5ullKERNZhW5
yEcZWBoaIeSNos0LAfRfynkriOfvckZLNYT8fNU1bUmySsD/qMh0YMAT5eDhpZYe
B1FKJnKkimBPspMChaCCf7OL6j3chKzsftb0mR2KiKqNVhMqYA03/nagQ1KRc0Ah
pfa/BE4IguvSrIJvAuWzkY7qgjiegyiQ42Fto2Os7QVIZBX40GrJrQJHL4z0GzcA
471+VG8Kq8206TnJQycDZrDvCvXE6g7v6VsPHs9IUa9ijgFeKyEHaZCuHHkzlYJD
wlEqyiBEwmN3bDWRjK4B
=yoom
-----END PGP SIGNATURE-----

--EeQfGwPcQSOJBaQU--
