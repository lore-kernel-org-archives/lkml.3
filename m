Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138AbaKQJrf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 04:47:35 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:6395 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755AbaKQJrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 04:47:33 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 17 Nov 2014 01:47:21 -0800
Date: Mon, 17 Nov 2014 10:47:15 +0100
From: Thierry Reding <treding@nvidia.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Dave Airlie <airlied@linux.ie>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: manual merge of the drm tree with Linus' tree
Message-ID: <20141117094714.GA20092@ulmo.nvidia.com>
References: <20141117141158.438636fd@canb.auug.org.au>
MIME-Version: 1.0
In-Reply-To: <20141117141158.438636fd@canb.auug.org.au>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [10.2.69.37]
X-ClientProxiedBy: UKMAIL102.nvidia.com (10.26.138.15) To
 UKMAIL101.nvidia.com (10.26.138.13)
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="opJtzjQTFsWo+cga"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 17, 2014 at 02:11:58PM +1100, Stephen Rothwell wrote:
> * PGP Signed by an unknown key
>=20
> Hi Dave,
>=20
> Today's linux-next merge of the drm tree got a conflict in
> drivers/gpu/drm/tegra/dc.c between commit 8ff64c17f3be ("drm/tegra: dc:
> Add missing call to drm_vblank_on()") from Linus' tree and commits
> 205d48edee84 ("drm/tegra: dc: Factor out DC, window and cursor commit")
> and c7679306a923 ("drm/tegra: dc: Universal plane support") from the
> drm tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
>=20
> --=20
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>=20
> diff --cc drivers/gpu/drm/tegra/dc.c
> index 054a79f143ae,b957908aec73..000000000000
> --- a/drivers/gpu/drm/tegra/dc.c
> +++ b/drivers/gpu/drm/tegra/dc.c
> @@@ -751,7 -906,8 +906,8 @@@ static void tegra_crtc_disable(struct d
>   		}
>   	}
>  =20
>  -	drm_vblank_off(drm, dc->pipe);
>  +	drm_crtc_vblank_off(crtc);
> + 	tegra_dc_commit(dc);
>   }
>  =20
>   static bool tegra_crtc_mode_fixup(struct drm_crtc *crtc,
> @@@ -934,15 -1090,9 +1090,9 @@@ static void tegra_crtc_prepare(struct d
>   static void tegra_crtc_commit(struct drm_crtc *crtc)
>   {
>   	struct tegra_dc *dc =3D to_tegra_dc(crtc);
> - 	unsigned long value;
> -=20
> - 	value =3D GENERAL_UPDATE | WIN_A_UPDATE;
> - 	tegra_dc_writel(dc, value, DC_CMD_STATE_CONTROL);
> -=20
> - 	value =3D GENERAL_ACT_REQ | WIN_A_ACT_REQ;
> - 	tegra_dc_writel(dc, value, DC_CMD_STATE_CONTROL);
>  =20
>  -	drm_vblank_post_modeset(crtc->dev, dc->pipe);
>  +	drm_crtc_vblank_on(crtc);
> + 	tegra_dc_commit(dc);
>   }
>  =20
>   static void tegra_crtc_load_lut(struct drm_crtc *crtc)

Looks good.

Thanks,
Thierry

--opJtzjQTFsWo+cga
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUacQiAAoJEN0jrNd/PrOhdiAQALvIBlSEZplno1wHEP3XFcb8
6BuOJyHkpZ9QgBACZmCGi8IiY/GfT++akl3YPyURlRVEd5zGBjV4HQ0Sx0+SPkYE
qnKKQzTXTcK7Z7j7O25yyxfp2S793GZZm137jh4BdJ1WdqaaoI2bgrYS9rEPndpJ
gndY6n7KI3Ih2/a8rB6x4yiQuMV/yODEgbkXaiSMOUyM+jL6DsR4H/xQ+w9ZCqie
UJLjXOIXv3Dn5BCtWlhQGy07VPYluz+YFc9caI73/uZbhIcR0XfPad9fJp25xmH3
5ZeqZq5xfcdvmZlXQ4tA/NMH1gb75v6TDzVr7bN3xcFlbs4I+2MmqyDlZEgd6D30
Gk1WEpeBpOjn6acOvZYbUDB0NZ2hhhft63sXN60fJ5QKr56gRt8RdhegSXgmTV2g
CaNjPr6Q/2kdoj2yt/TKWpFU0U5eOfV3n/LEbtkKQz2c6mOa1q/2llkJIQdiZGt9
BdJCkAb9OVtmspDrVVrWrDVHAz3OOMLZRoCLkZKaymi14U/B+yWBdEddabaBru0e
TUwG+QMU83ZLBfppWx4MLkeXQaF4IoMxK9W4G+KhmFXy+6tosxofkdZVzNfWEDNN
Ev4ukZI1qfrgGni87jD65/HY63YqbTeSGtygnlKCLFQ8SaySFPTiXnsmnzU+StB3
29oNWROkONgeq5FSJc9p
=9drM
-----END PGP SIGNATURE-----

--opJtzjQTFsWo+cga--
