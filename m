Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763459Ab3IEHzN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 03:55:13 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:33508 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756186Ab3IEHzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 03:55:10 -0400
Date: Thu, 5 Sep 2013 17:55:03 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Herrmann <dh.herrmann@gmail.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fbdev <linux-fbdev@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [GIT PULL] fbdev changes for 3.12
Message-Id: <20130905175503.a4320c0f875712bc68c32cf7@canb.auug.org.au>
In-Reply-To: <CANq1E4Rd2eEaNnX8b3WAQcQX-T4+fR-4OMAtoSaAp9XwdGLpSg@mail.gmail.com>
References: <5228294E.8050401@ti.com>
	<CANq1E4Rd2eEaNnX8b3WAQcQX-T4+fR-4OMAtoSaAp9XwdGLpSg@mail.gmail.com>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__5_Sep_2013_17_55_03_+1000_DkWT_zNrFd3ZK5Xr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__5_Sep_2013_17_55_03_+1000_DkWT_zNrFd3ZK5Xr
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Thu, 5 Sep 2013 09:48:18 +0200 David Herrmann <dh.herrmann@gmail.com> wr=
ote:
>
> On Thu, Sep 5, 2013 at 8:48 AM, Tomi Valkeinen <tomi.valkeinen@ti.com> wr=
ote:
> >
> > Here are the fbdev changes for 3.12.
> >
> > There's a conflict in drivers/video/simplefb.c, which you can resolve b=
y using
> > the version in your tree.
>=20
> No, both need to be merged. The current version lacks support for
> ABGR8888. The fbdev tree lacks the DRM format, which should be:
>   { "a8b8g8r8", 32, {0, 8}, {8, 8}, {16, 8}, {24, 8}, DRM_FORMAT_ABGR8888=
 }
>=20
> > I guess the simplefb changes were taken through Ingo's tree because the=
 series
> > includes x86 arch changes, but it would have been nice to see the patch=
es in
> > the linux-next...
>=20
> simplefb was in linux-next. I also acked the fixup from Stephen. See
> this commit from a pre-3.12 -next tree:
>   http://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/=
include/linux/platform_data/simplefb.h?id=3D44ed8fb588e517a2ef917c6757ee11e=
e47348978

In case it is not obvious, this is the extra merge fix patch I have been
carrying (after using the version of drivers/video/simplefb.c from the
tip tree - which is already in your tree):

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 14 Aug 2013 14:29:27 +1000
Subject: [PATCH] simplefb: merge conflict fix

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/linux/platform_data/simplefb.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/platform_data/simplefb.h b/include/linux/platfor=
m_data/simplefb.h
index 53774b0..c395d4c 100644
--- a/include/linux/platform_data/simplefb.h
+++ b/include/linux/platform_data/simplefb.h
@@ -27,6 +27,7 @@
 	{ "a8r8g8b8", 32, {16, 8}, {8, 8}, {0, 8}, {24, 8}, DRM_FORMAT_ARGB8888 }=
, \
 	{ "x2r10g10b10", 32, {20, 10}, {10, 10}, {0, 10}, {0, 0}, DRM_FORMAT_XRGB=
2101010 }, \
 	{ "a2r10g10b10", 32, {20, 10}, {10, 10}, {0, 10}, {30, 2}, DRM_FORMAT_ARG=
B2101010 }, \
+	{ "a8b8g8r8", 32, {0, 8}, {8, 8}, {16, 8}, {24, 8}, DRM_FORMAT_ABGR8888 }=
, \
 }
=20
 /*
--=20
1.8.4.rc0

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__5_Sep_2013_17_55_03_+1000_DkWT_zNrFd3ZK5Xr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSKDjbAAoJEECxmPOUX5FEMQoP+gNCVmcwKfOq8BiRUxq1zbuR
BC1texYN3FvI1osleoUei6waFoCkBgpSwPww+zl1nTV+T1VDvPZz8Xh/BH3Qlw+x
G99ka8129UAD6/8T02hl6J2LHOw7CLeB2RPVlUXrp1BCCBwE92V+j/6mEcR2z1Tb
TK0G1jxi1ls68ywEsRmeUE96521dedo/+jYvHJrx/h4B7j89gHNt/VmtMUGuVG5l
Tb5ebvB53Lscs/kGpg9SOtlIBG2BDGADrDFNt+CTcVA6fVpo4GyC5ENxs14oHQDc
MFnKiirrOh3eYblnHzVLaIyoE0ULK1Kp4D0UY3pJOReJgdtq+icQl3wcT5E+tiVV
ii6tQkf/xYt3CJj0h1te2gVfnT8+loLTou9iPNCgQ/uSEPbsnGtQhy2K8iYH7uz/
fbHbu1FIekJzhkBpPgWdxss79aeKAeEC4eZyqDCIVng2ZGS3RSlDZo5D+llcHaWl
/Z66Eoi106wsI8kkKecrVcKSgC/g/3QHPf0se3YFOO2jWqKUF+9uhFz5H1WiIyow
ytq+Ka7e3+edDo7BAWlXaXLJAtfB2Q6dlgl/G5XgoJsgjRJAR2rEkeE/Sg7/zQvV
fjqhchbzzIGSfWfcGSDVa+ysq6KIGCkjnVVAhS7cp1A91sSeaQWdCnpRVsAY028n
pB9h8wPKPLmbc3HjgohJ
=DZbE
-----END PGP SIGNATURE-----

--Signature=_Thu__5_Sep_2013_17_55_03_+1000_DkWT_zNrFd3ZK5Xr--
