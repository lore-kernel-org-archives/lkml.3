Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613Ab3HMJ2Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 05:28:24 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:61543 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135Ab3HMJ2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 05:28:22 -0400
From: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
To: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>
Subject: [PATCH] nouveau reclocking on nv40 not working since 77145f1cbdf8d28b46ff8070ca749bad821e0774
Date: Tue, 13 Aug 2013 11:28:01 +0200
Message-ID: <23735105.M9MNGeX3Gc@pali>
User-Agent: KMail/4.10.5 (Linux/3.8.0-27-generic; KDE/4.10.5; x86_64; ; )
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3925638.NnLKLMlotZ"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart3925638.NnLKLMlotZ
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

Hello,

in commit 77145f1cbdf8d28b46ff8070ca749bad821e0774 was introduced
error which cause that on my Nvidia 6600GT card reclocking not working
anymore. There is missing assigment of return value from pll_calc to re=
t.

After this patch reclocking on my card working fine again. Above broken=

commit was introduced in kernel 3.7, so consider backporting this patch=

to older kernels too.

Signed-off-by: Pali Roh=E1r <pali.rohar@gmail.com>

diff --git a/drivers/gpu/drm/nouveau/nv40_pm.c b/drivers/gpu/drm/nouvea=
u/nv40_pm.c
index 3af5bcd..625f80d 100644
--- a/drivers/gpu/drm/nouveau/nv40_pm.c
+++ b/drivers/gpu/drm/nouveau/nv40_pm.c
@@ -131,7 +131,7 @@ nv40_calc_pll(struct drm_device *dev, u32 reg, stru=
ct nvbios_pll *pll,
 =09if (clk < pll->vco1.max_freq)
 =09=09pll->vco2.max_freq =3D 0;
=20
-=09pclk->pll_calc(pclk, pll, clk, &coef);
+=09ret =3D pclk->pll_calc(pclk, pll, clk, &coef);
 =09if (ret =3D=3D 0)
 =09=09return -ERANGE;
=20

--=20
Pali Roh=E1r
pali.rohar@gmail.com


--nextPart3925638.NnLKLMlotZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlIJ/CEACgkQi/DJPQPkQ1LFJACglSrBLRcCJ+xl9MHpNKcULMCg
JJ8An3hYtGg33CzMZelMgZeog3WtWmcS
=alB4
-----END PGP SIGNATURE-----

--nextPart3925638.NnLKLMlotZ--

