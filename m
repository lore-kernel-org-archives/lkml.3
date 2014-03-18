Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324AbaCRGPP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 02:15:15 -0400
Received: from ozlabs.org ([203.10.76.45]:37477 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923AbaCRGPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 02:15:13 -0400
Date: Tue, 18 Mar 2014 17:15:06 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Uma Sharma <uma.sharma523@gmail.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Antti Palosaari <crope@iki.fi>
Subject: linux-next: manual merge of the staging tree with the v4l-dvb tree
Message-Id: <20140318171506.d94275bb6dcad73899fd39fe@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__18_Mar_2014_17_15_06_+1100_rVIp=+YKCcebiFdT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__18_Mar_2014_17_15_06_+1100_rVIp=+YKCcebiFdT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/media/msi3101/sdr-msi3101.c between commit 3d0c8fa3c5a0
("[media] msi3101: convert to SDR API") from the v4l-dvb tree and commit
6e878c0299c1 ("staging: media/msi3101/sdr-msi3101.c removed warning")
from the staging tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/media/msi3101/sdr-msi3101.c
index 011db2c08014,5a0400fdb98c..000000000000
--- a/drivers/staging/media/msi3101/sdr-msi3101.c
+++ b/drivers/staging/media/msi3101/sdr-msi3101.c
@@@ -132,7 -411,7 +132,7 @@@ struct msi3101_state=20
  	unsigned int vb_full; /* vb is full and packets dropped */
 =20
  	struct urb *urbs[MAX_ISO_BUFS];
- 	int (*convert_stream) (struct msi3101_state *s, u8 *dst, u8 *src,
 -	int (*convert_stream)(struct msi3101_state *s, u32 *dst, u8 *src,
++	int (*convert_stream)(struct msi3101_state *s, u8 *dst, u8 *src,
  			unsigned int src_len);
 =20
  	/* Controls */

--Signature=_Tue__18_Mar_2014_17_15_06_+1100_rVIp=+YKCcebiFdT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTJ+RuAAoJEMDTa8Ir7ZwVBEYQAIlJeM0OYVmSpje56LbIIHqn
lfCXzEHnWwVc7125hL7xmiEc4pA2YCJ5Vp+Tq6LWIBM8jZV/KAbBqtMpckqGPWrq
ZOFNx3X4pV1UWFo+kxNYYZR3Lf8eS0n7yqg9YFV7o01noBeQ2ppYRHCEzmv/wBFB
wWMa6Dp2kFb8D3A41Ya1XjLdTmiRJ1rUadSzGToZEz/tGf57RvteOuPVvMnMvHbQ
82MbBED/go7ooUwJv01xaRGqeA+xoFX9ir5FzK1Nuo1Ri+WO+U7DdjRWIxcJdSgU
CupjxzwRYt29eHqSqaBhhVLdiZG6cvJ/75w9fcVmf5oa0lN95nliLh7XaO/zB0rB
FEwYJgXOLwuXhBB49++b49Y/uLpqKMLdJt/6088I/+ErRcXM5j8uTUVb3MRhgbWY
vhTjFDeDPh02/hr+/1bxT+7IPryy3Oy7/EUzIscJo0GuBFW0IaIVLfYvTShvJcm2
DOrn9toRbQG60pP3l/eiTnbmkBNu1keK9ICfhEuyMFGOTuAA2JF1df1U1HiMb32z
DeMCrxm3sQ7JBrnuKl9ykZURVqUcTqJTJVSbmy/B/gSWi4+gFTnCKQgXUHURxBkA
8poD47+23a7aq1MLMKD7deZJiAYILtFkKsksrb7SdgaZdb+n+/H3muRXxHyUAla7
jHkmZxbzJN/divGqrZKB
=y1qh
-----END PGP SIGNATURE-----

--Signature=_Tue__18_Mar_2014_17_15_06_+1100_rVIp=+YKCcebiFdT--
