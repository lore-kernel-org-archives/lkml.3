Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751140Ab3HSG7j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 02:59:39 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:36797 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039Ab3HSG7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 02:59:38 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Ben Skeggs <bskeggs@redhat.com>
Subject: Re: [PATCH] nouveau: fix reclocking on nv40
Date: Mon, 19 Aug 2013 08:59:32 +0200
User-Agent: KMail/1.13.7 (Linux/3.11.0-rc5+synaptics-generic; KDE/4.11.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        David Airlie <airlied@linux.ie>, Martin Peres <martin.peres@labri.fr>
References: <520DFD9F.1070006@labri.fr> <1376657827-8105-1-git-send-email-pali.rohar@gmail.com>
In-Reply-To: <1376657827-8105-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1501245.0Vcxz5UO9T";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201308190859.32696@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1501245.0Vcxz5UO9T
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Friday 16 August 2013 14:57:07 Pali Roh=C3=A1r wrote:
> In commit 77145f1cbdf8d28b46ff8070ca749bad821e0774 was
> introduced error which cause that reclocking on nv40 not
> working anymore. There is missing assigment of return value
> from pll_calc to ret.
>=20
> Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> Signed-off-by: Martin Peres <martin.peres@labri.fr>
> ---
>  drivers/gpu/drm/nouveau/nv40_pm.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/gpu/drm/nouveau/nv40_pm.c
> b/drivers/gpu/drm/nouveau/nv40_pm.c index 3af5bcd..625f80d
> 100644
> --- a/drivers/gpu/drm/nouveau/nv40_pm.c
> +++ b/drivers/gpu/drm/nouveau/nv40_pm.c
> @@ -131,7 +131,7 @@ nv40_calc_pll(struct drm_device *dev, u32
> reg, struct nvbios_pll *pll, if (clk < pll->vco1.max_freq)
>  		pll->vco2.max_freq =3D 0;
>=20
> -	pclk->pll_calc(pclk, pll, clk, &coef);
> +	ret =3D pclk->pll_calc(pclk, pll, clk, &coef);
>  	if (ret =3D=3D 0)
>  		return -ERANGE;

Hello, it is possible to include this patch in 3.11?
Or it is too late now and need to wait for 3.12?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1501245.0Vcxz5UO9T
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlIRwlQACgkQi/DJPQPkQ1JndQCdGV95aZJT6e19Y3EZiYwyahOq
dokAoMLE15APJkClcfAD/n9Q/gtEH3EM
=zA4y
-----END PGP SIGNATURE-----

--nextPart1501245.0Vcxz5UO9T--
