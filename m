Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939Ab3CFHG5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 02:06:57 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:61339 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069Ab3CFHGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 02:06:55 -0500
Date: Wed, 6 Mar 2013 08:06:32 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: David Airlie <airlied@linux.ie>, Stephen Warren <swarren@wwwdotorg.org>,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/tegra: drop "select DRM_HDMI"
Message-ID: <20130306070632.GB2436@avionic-0098.mockup.avionic-design.de>
References: <1362517656.16460.125.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6sX45UoQRIJXqkqR"
Content-Disposition: inline
In-Reply-To: <1362517656.16460.125.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:yZUbss8dGX/+B+WhA8jU0zsJVjZjD+rrLgFN/uU3M8w
 HqksCpWnT9uH6el5vztG8T7ffz3WNdu5CAS+c5w2dTsNoIOi9f
 IxImldhm0lquksX/LQemF+nLWzFjv2+/QSAN+RqIazovi1IVA2
 aSvWsXuda5+2AfFSl8611x5vrd2ot529h3LulybsOXrpNnl4a8
 53/SyUhtl7p4Dk5Ppy3vjoqdgzUciVfFWt8WdQzfD7kO3vSi0l
 9bG1LGw7rY4KZzl8XSuVIa7tOukrA9edjnVATRnd5R6NAaDgOU
 JTTvTIuFYyVwxsoScs8QFEMMV7QoyL3j3U6AA5rM7KK79pXm42
 AAvqPpl0nO1J9M1rYoiiKzJ/gTanZRkDbZqqb7CfmmTFIxCkaX
 EqPvmM0Sda9e1cuV5qBR+2S5OmPl31kBwFmCNHB4h8d70HU0rN
 wM1Tx
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6sX45UoQRIJXqkqR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 05, 2013 at 10:07:36PM +0100, Paul Bolle wrote:
> Commit ac24c2204a76e5b42aa103bf963ae0eda1b827f3 ("drm/tegra: Use generic
> HDMI infoframe helpers") added "select DRM_HDMI" to the DRM_TEGRA
> Kconfig entry. But there is no Kconfig symbol named DRM_HDMI. The select
> statement for that symbol is a nop. Drop it.
>=20
> What was needed to use HDMI functionality was to select HDMI (which this
> entry already did through depending on DRM) and to include linux/hdmi.h
> (which this commit also did).
>=20
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Untested.=20
>=20
>  drivers/gpu/drm/tegra/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/drivers/gpu/drm/tegra/Kconfig b/drivers/gpu/drm/tegra/Kconfig
> index c92955d..be1daf7 100644
> --- a/drivers/gpu/drm/tegra/Kconfig
> +++ b/drivers/gpu/drm/tegra/Kconfig
> @@ -4,7 +4,6 @@ config DRM_TEGRA
>  	select DRM_KMS_HELPER
>  	select DRM_GEM_CMA_HELPER
>  	select DRM_KMS_CMA_HELPER
> -	select DRM_HDMI
>  	select FB_CFB_FILLRECT
>  	select FB_CFB_COPYAREA
>  	select FB_CFB_IMAGEBLIT

Good catch! I think what happened here is that the DRM HDMI helpers used
to be in a separate file and DRM_HDMI enabled that file to be built. The
helpers were moved into drm_edid.c at some point, though, and the symbol
was dropped and I forgot to remove it from the Tegra DRM Kconfig.

Acked-by: <thierry.reding@avionic-design.de>

--6sX45UoQRIJXqkqR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRNur4AAoJEN0jrNd/PrOhrS0P/j5xa1RlegD3dNcQuRXp2czQ
rXFSblwkzlAn55j+N0JOoF3UwAgO9XKPbW0MvkCebLrJ3yCawKTodm8a/yHjZzIi
ndMEe6FDJY09MpyMA3AW6EfD3Dh6H/VK1BS1sJCSC92txQY0wD0tPKVvq0pQOqiK
aX1ao9AZTVHk/EUlvUaMmWHpgqdqAS7hosatk2h23W0bJpmQyZg2E0F4iYbGHi8n
Ro6Cwa5UGNOr0MFVvOvzg2sEOUuGEKpPycvM77Z8n3C9sn/fRszqVClRyWPczbjP
JusPAOBNIRBHFRhQjilOyZFlqUv/SBIJt1yRBt1bY34UDhTlFFmnP1p3nhhmAahv
DdZTre5zTePqzxaBc6yahQhaFDHEnN05qqa6wHunxvqg5F0dr9YDB70xOAcW0Tqj
G8qSKdIdcmQMMeotHmgkfdYUXc0S7z3qC540zBXfJ+8KO1uFgTZIequ5WiuJW0Xw
IK1I93jSWpXy/Vl6+D+908macUsj7VJcaEKqbu71WBh0/YE3cCml+yCz3nBi7MxK
E9c9XqOIST7kpYr/ZLzXrR6TA0EJPOo6qp4qJuXHWHkvJILclKNXAZ/hp8FADDel
GTdErSBgDLIvMnBKT3v7fBXghuD2fw1ls0BkglguJSX0KFxYIlJ7HLgyJPdeLW6U
HdSFCkEd7gErX4d1iQ63
=8ZUu
-----END PGP SIGNATURE-----

--6sX45UoQRIJXqkqR--
