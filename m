Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab3IHLZk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 07:25:40 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:49931 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546Ab3IHLZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 07:25:39 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Ben Skeggs <skeggsb@gmail.com>
Subject: Re: [PATCH] nouveau: fix reclocking on nv40
Date: Sun, 8 Sep 2013 13:25:35 +0200
User-Agent: KMail/1.13.7 (Linux/3.11.0-1+synaptics-generic; KDE/4.11.0; x86_64; ; )
Cc: Ben Skeggs <bskeggs@redhat.com>, Martin Peres <martin.peres@labri.fr>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
References: <520DFD9F.1070006@labri.fr> <201308190859.32696@pali> <CACAvsv5a5JVZa=yFi7zy=zpHtFBCig+K8n-G9LOHN1vnKr94Dg@mail.gmail.com>
In-Reply-To: <CACAvsv5a5JVZa=yFi7zy=zpHtFBCig+K8n-G9LOHN1vnKr94Dg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1732858.UoKDIRgjvv";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201309081325.36159@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1732858.UoKDIRgjvv
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 21 August 2013 02:24:01 Ben Skeggs wrote:
> On Mon, Aug 19, 2013 at 4:59 PM, Pali Roh=C3=A1r=20
<pali.rohar@gmail.com> wrote:
> > On Friday 16 August 2013 14:57:07 Pali Roh=C3=A1r wrote:
> >> In commit 77145f1cbdf8d28b46ff8070ca749bad821e0774 was
> >> introduced error which cause that reclocking on nv40 not
> >> working anymore. There is missing assigment of return value
> >> from pll_calc to ret.
> >>=20
> >> Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> >> Signed-off-by: Martin Peres <martin.peres@labri.fr>
> >> ---
> >>=20
> >>  drivers/gpu/drm/nouveau/nv40_pm.c |    2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>=20
> >> diff --git a/drivers/gpu/drm/nouveau/nv40_pm.c
> >> b/drivers/gpu/drm/nouveau/nv40_pm.c index 3af5bcd..625f80d
> >> 100644
> >> --- a/drivers/gpu/drm/nouveau/nv40_pm.c
> >> +++ b/drivers/gpu/drm/nouveau/nv40_pm.c
> >> @@ -131,7 +131,7 @@ nv40_calc_pll(struct drm_device *dev,
> >> u32 reg, struct nvbios_pll *pll, if (clk <
> >> pll->vco1.max_freq)
> >>=20
> >>               pll->vco2.max_freq =3D 0;
> >>=20
> >> -     pclk->pll_calc(pclk, pll, clk, &coef);
> >> +     ret =3D pclk->pll_calc(pclk, pll, clk, &coef);
> >>=20
> >>       if (ret =3D=3D 0)
> >>      =20
> >>               return -ERANGE;
> >=20
> > Hello, it is possible to include this patch in 3.11?
> > Or it is too late now and need to wait for 3.12?
>=20
> I've picked up the patch and will submit it in my next
> 3.11-fixes pull request.
>=20
> Thanks,
> Ben.
>=20

Hello, now I see that patch is in 3.11, thanks! Ben, what do you=20
think, can be this patch backported to older kernels?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1732858.UoKDIRgjvv
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlIsXrAACgkQi/DJPQPkQ1LAwwCgn2SBZ/RPRiE0ZaAzns+mH/gB
Q2IAoJqMMREj8APyciYKmvgbF4M8SE1F
=SyQX
-----END PGP SIGNATURE-----

--nextPart1732858.UoKDIRgjvv--
