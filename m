Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147Ab3DHEhL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 00:37:11 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:44561 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985Ab3DHEhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 00:37:09 -0400
Date: Mon, 8 Apr 2013 14:36:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jingoo Han <jg1.han@samsung.com>
Subject: linux-next: manual merge of the omap_dss2 tree with Linus' tree
Message-Id: <20130408143623.bbf18647b96df42b8b8ec6a0@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__8_Apr_2013_14_36_23_+1000_Y__T1eWGENzZ/7D5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__8_Apr_2013_14_36_23_+1000_Y__T1eWGENzZ/7D5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tomi,

Today's linux-next merge of the omap_dss2 tree got a conflict in
drivers/video/fbmon.c between commit 477fc03f5baa ("fbmon: use
VESA_DMT_VSYNC_HIGH to fix typo") from Linus' tree and commit
06a3307975aa ("videomode: combine videomode dmt_flags and data_flags")
from the omap_dss2 tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

diff --cc drivers/video/fbmon.c
index 7f67099,e5cc2fd..0000000
--- a/drivers/video/fbmon.c
+++ b/drivers/video/fbmon.c
@@@ -1398,13 -1398,13 +1398,13 @@@ int fb_videomode_from_videomode(const s
 =20
  	fbmode->sync =3D 0;
  	fbmode->vmode =3D 0;
- 	if (vm->dmt_flags & VESA_DMT_HSYNC_HIGH)
+ 	if (vm->flags & DISPLAY_FLAGS_HSYNC_HIGH)
  		fbmode->sync |=3D FB_SYNC_HOR_HIGH_ACT;
- 	if (vm->dmt_flags & VESA_DMT_VSYNC_HIGH)
 -	if (vm->flags & DISPLAY_FLAGS_HSYNC_HIGH)
++	if (vm->flags & DISPLAY_FLAGS_VSYNC_HIGH)
  		fbmode->sync |=3D FB_SYNC_VERT_HIGH_ACT;
- 	if (vm->data_flags & DISPLAY_FLAGS_INTERLACED)
+ 	if (vm->flags & DISPLAY_FLAGS_INTERLACED)
  		fbmode->vmode |=3D FB_VMODE_INTERLACED;
- 	if (vm->data_flags & DISPLAY_FLAGS_DOUBLESCAN)
+ 	if (vm->flags & DISPLAY_FLAGS_DOUBLESCAN)
  		fbmode->vmode |=3D FB_VMODE_DOUBLE;
  	fbmode->flag =3D 0;
 =20
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__8_Apr_2013_14_36_23_+1000_Y__T1eWGENzZ/7D5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRYklHAAoJEECxmPOUX5FEHykQAIrb6AAW3C6XqAXI/ImYLAqY
WMkju//k7eYiS+w0jARnF1r6ytGyVYVRc6Niy5bOUGFEd8CvkePBsiSsnTuLIXZt
kSBdYtC0m07bdzFdz904BmrnePuC3Od9jFNSfw/IuQnLLJUhLp5YqyybSwecd9Pe
SQQViL8Vygo83F7hrhHVF4S1fb5oxTErWmnJAQPCzs22ZAvfNXbV8DuUW1SSwIxD
TlMLBnwKN9H5jbvGjnJa+c+CmRHsBi/BhH52NbpwwYuJWiPThxi3Hof5vLdCCBfz
nz2uN7uNyG+taoAeFo5lbe4Q2Hgax6I7TJmFqJ8iw4BoYP4YOJI6NRz6oD/i3YRL
OOKhHUhO9MikabOwlA3SSFXyTFc3gGhQ7WWZqt/0QvFOGii65tgr7rpQz099+SrZ
wFQNnR/WvHH1DuwWtmCeHOUFCH2Asv/dRWroUbqxC4rYlbSh2XGJdybIIO+AiRGe
p57VbqorCGt3U6efpMsCdA1zbAS9EZy0LjAd9O9i0cIEG4Nv8ZMvthj+gUlHdto3
Q7HUN6hIYImNZ8v3AnHnY4PKYGVl415EhXRcGUIcYbkmZKyosJWkPVlmh6QScJgl
Kdf8GrwF1Jlo92bnO3pf/LjvOR4ilYTBEfyOaweWrnKFED3B2Wehh8tOOE93Ewrm
QG1Jll3zIyhgHRyNMsoq
=nLRv
-----END PGP SIGNATURE-----

--Signature=_Mon__8_Apr_2013_14_36_23_+1000_Y__T1eWGENzZ/7D5--
