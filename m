Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065Ab3HPHQN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 03:16:13 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:58381 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab3HPHQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 03:16:07 -0400
From: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
To: Martin Peres <martin.peres@labri.fr>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>
Subject: Re: [PATCH] nouveau reclocking on nv40 not working since 77145f1cbdf8d28b46ff8070ca749bad821e0774
Date: Fri, 16 Aug 2013 09:16:03 +0200
Message-ID: <1577797.nVIM0OkmpX@pali>
User-Agent: KMail/4.10.5 (Linux/3.8.0-27-generic; KDE/4.10.5; x86_64; ; )
In-Reply-To: <520D54CA.4050001@labri.fr>
References: <23735105.M9MNGeX3Gc@pali> <201308151946.26609@pali> <520D54CA.4050001@labri.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart4099833.8saH2JuLPR"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart4099833.8saH2JuLPR
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

On Thursday 15 August 2013 18:23:06 Martin Peres wrote:
> On 15/08/2013 13:46, Pali Roh=E1r wrote:
> > On Tuesday 13 August 2013 11:28:01 Pali Roh=E1r wrote:
> >> Hello,
> >>=20
> >> in commit 77145f1cbdf8d28b46ff8070ca749bad821e0774 was
> >> introduced error which cause that on my Nvidia 6600GT card
> >> reclocking not working anymore. There is missing assigment of
> >> return value from pll_calc to ret.
> >>=20
> >> After this patch reclocking on my card working fine again.
> >> Above broken commit was introduced in kernel 3.7, so consider
> >> backporting this patch to older kernels too.
> >>=20
> >> Signed-off-by: Pali Roh=E1r <pali.rohar@gmail.com>
> >>=20
> >> diff --git a/drivers/gpu/drm/nouveau/nv40_pm.c
> >> b/drivers/gpu/drm/nouveau/nv40_pm.c index 3af5bcd..625f80d
> >> 100644
> >> --- a/drivers/gpu/drm/nouveau/nv40_pm.c
> >> +++ b/drivers/gpu/drm/nouveau/nv40_pm.c
> >> @@ -131,7 +131,7 @@ nv40_calc_pll(struct drm_device *dev, u32
> >> reg, struct nvbios_pll *pll, if (clk < pll->vco1.max_freq)
> >>=20
> >>   =09=09pll->vco2.max_freq =3D 0;
> >>=20
> >> -=09pclk->pll_calc(pclk, pll, clk, &coef);
> >> +=09ret =3D pclk->pll_calc(pclk, pll, clk, &coef);
> >>=20
> >>   =09if (ret =3D=3D 0)
> >>   =09
> >>   =09=09return -ERANGE;
> >=20
> > Martin, can you look at another problem with my graphics card?
>=20
> As I told you before, I'm away from my computers, so I cannot test th=
e
> patch. However,
> this one seems quite obvious and should be pushed. Thanks.

Yes, look at that diff of that problematic commit and you will see that=
 ret=20
here is missing. It is possible to push this patch to 3.11?

--=20
Pali Roh=E1r
pali.rohar@gmail.com


--nextPart4099833.8saH2JuLPR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlIN0bMACgkQi/DJPQPkQ1IEVQCfZbLg0wC4okb5dE7CAywfeEYc
NeIAoJrhWc220Rv+OAwFrA5oRlwEZEZm
=gEsr
-----END PGP SIGNATURE-----

--nextPart4099833.8saH2JuLPR--

