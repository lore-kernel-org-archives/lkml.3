Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759303Ab3HORqc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 13:46:32 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:45226 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694Ab3HORqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 13:46:30 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Martin Peres <martin.peres@labri.fr>
Subject: Re: [PATCH] nouveau reclocking on nv40 not working since 77145f1cbdf8d28b46ff8070ca749bad821e0774
Date: Thu, 15 Aug 2013 19:46:26 +0200
User-Agent: KMail/1.13.7 (Linux/3.11.0-rc5+synaptics-generic; KDE/4.10.5; x86_64; ; )
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>
References: <23735105.M9MNGeX3Gc@pali>
In-Reply-To: <23735105.M9MNGeX3Gc@pali>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3461774.5Qds9QIifz";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201308151946.26609@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3461774.5Qds9QIifz
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tuesday 13 August 2013 11:28:01 Pali Roh=C3=A1r wrote:
> Hello,
>=20
> in commit 77145f1cbdf8d28b46ff8070ca749bad821e0774 was
> introduced error which cause that on my Nvidia 6600GT card
> reclocking not working anymore. There is missing assigment of
> return value from pll_calc to ret.
>=20
> After this patch reclocking on my card working fine again.
> Above broken commit was introduced in kernel 3.7, so consider
> backporting this patch to older kernels too.
>=20
> Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
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

Martin, can you look at another problem with my graphics card?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart3461774.5Qds9QIifz
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlINE/IACgkQi/DJPQPkQ1ICFwCdEC7n5JCHe3Do2yrFoS2/trjg
XDsAnieUvIrcV0f3otsIKfmQ/jttevn8
=QhZt
-----END PGP SIGNATURE-----

--nextPart3461774.5Qds9QIifz--
