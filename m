Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175AbaKSOct (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 09:32:49 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:38922 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754921AbaKSOcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 09:32:47 -0500
Date: Wed, 19 Nov 2014 08:32:59 -0600
From: Felipe Balbi <balbi@ti.com>
To: Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>
CC: David Airlie <airlied@linux.ie>, Rob Clark <robdclark@gmail.com>,
        "open list:DRM DRIVERS" <dri-devel@lists.freedesktop.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drm/tilcdc: add missing clk_put in tilcdc_unload()
Message-ID: <20141119143259.GC4029@saruman>
Reply-To: <balbi@ti.com>
References: <1416406400-10564-1-git-send-email-julien.chauveau@neo-technologies.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dkEUBIird37B8yKS"
Content-Disposition: inline
In-Reply-To: <1416406400-10564-1-git-send-email-julien.chauveau@neo-technologies.fr>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--dkEUBIird37B8yKS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 19, 2014 at 03:13:20PM +0100, Julien CHAUVEAU wrote:
> We need to call clk_put on display clock, in the same way as functional c=
lock.
>=20
> Signed-off-by: Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>
> ---
>  drivers/gpu/drm/tilcdc/tilcdc_drv.c | 3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/drivers/gpu/drm/tilcdc/tilcdc_drv.c b/drivers/gpu/drm/tilcdc=
/tilcdc_drv.c
> index 79a34cb..ccc1cdb 100644
> --- a/drivers/gpu/drm/tilcdc/tilcdc_drv.c
> +++ b/drivers/gpu/drm/tilcdc/tilcdc_drv.c
> @@ -136,6 +136,9 @@ static int tilcdc_unload(struct drm_device *dev)
>  			CPUFREQ_TRANSITION_NOTIFIER);
>  #endif
> =20
> +	if (priv->disp_clk)
> +		clk_put(priv->disp_clk);
> +
>  	if (priv->clk)
>  		clk_put(priv->clk);

we should actually remove the priv->$clk check. clk_put() is safe
against NULL pointers.

--=20
balbi

--dkEUBIird37B8yKS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUbKobAAoJEIaOsuA1yqRETYIP/0Pk2BF6k8ezp8ABBEQgoGpk
mSnxd0jSscBVEKznRqK6r4XQDR+VyYfDdc9ZdxanOsvyqp08yiQ7XWIoi6Nnp8M9
cUfJyDRBPaVzOnvMi6lxEf2Y6MAdcWFMBr7rKolMtYVBqmjrk/c0tGxtSvKRlkDz
cL+s+FqtYhw1BHL+FPhIFIrZr2L1Ox/ReRUrm7RSNLn9bJVVyvXAqdaI5QXNlmUS
+zC4YRmJda+wKr9aJdutfig78JeOikMO6+OwNNNdViGu6SvHRs/GPfjVla6oRRyl
WsPiO65a3p23fE76Iwm+bBY9aVe8/UtHUnyMQK8/r+LUPMOzRf5p/DugmSvfXeGX
EDWAVkN3vwntOGQVrKi4UuB7U/csyYBwj6NoR/w2RWWl3aUPH45Ehcc4S6X2nGuy
/Tp0LB69Wkbp8Yq1flSIq96144ZUjLqdVmbQ8/gCFSe8JIHLwpxVRqyrNjhTkFeM
Xrhw05gJyOHcPI80f6VluJrNQ6RNymxQJDpiG8KiD7jJJIEbQQcVLYUefXXyIdcu
tcEO0NHgWQAMyLLm+neXPGSEi/l7JkhCsRgVnK9BiZhoZLCnsNBZcuHSM0swcuiu
hCp5tR/I3eDv8055VIqr90FzNTq+eaJn+pKk68yPfuYSDPRLAHfX0JAPowSdE9wO
Z680muLOcFVVXdj9PXbW
=PEMw
-----END PGP SIGNATURE-----

--dkEUBIird37B8yKS--
