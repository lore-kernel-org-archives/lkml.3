Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751330Ab3GXEmp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 00:42:45 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:54655 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab3GXEmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 00:42:44 -0400
Date: Wed, 24 Jul 2013 14:42:32 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: linux-next: build failure after merge of the tty tree
Message-Id: <20130724144232.86d30134a8bc829b5172a5c2@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__24_Jul_2013_14_42_32_+1000_ThXOq6ueziuduz+8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__24_Jul_2013_14_42_32_+1000_ThXOq6ueziuduz+8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the tty tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

drivers/tty/n_tty.c: In function 'n_tty_close':
drivers/tty/n_tty.c:1757:2: error: implicit declaration of function 'vfree'=
 [-Werror=3Dimplicit-function-declaration]
  vfree(ldata);
  ^
drivers/tty/n_tty.c: In function 'n_tty_open':
drivers/tty/n_tty.c:1776:2: error: implicit declaration of function 'vmallo=
c' [-Werror=3Dimplicit-function-declaration]
  ldata =3D vmalloc(sizeof(*ldata));
  ^
drivers/tty/n_tty.c:1776:8: warning: assignment makes pointer from integer =
without a cast [enabled by default]
  ldata =3D vmalloc(sizeof(*ldata));
        ^

Caused by commit 20bafb3d23d1 ("n_tty: Move buffers into n_tty_data").
Forgot to include linux/vmalloc.h?

I have used the tty tree from next-20130723 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__24_Jul_2013_14_42_32_+1000_ThXOq6ueziuduz+8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR71s9AAoJEECxmPOUX5FErG4P/j8SsbcPUbrlJiGX+I7pHR+A
uJhHRGCJkzFZxkn9dSwOaaMc9ny7aGk34Mk68lGpkE0HbBVp26iiwvSgkMqPX11Q
TnR94NdL7ZcvWO22lOe0nGim8UHEwIDDMTxbYD+qRFIws09cIETnv5dtKFrCzkIV
/00llRY4WkO6En7fYmidCX5G4jpmRX/Rgk52Ru8s8+Vs2dvkbYOesOWR3HT8dLid
Ljc0X6l78fYs9/9viYAofLO6bhxuwi10xEnclPOS8EzUw8xz9CCrabe/6OSpfqcz
vG8zS5f1vnx2YXote4ZYpGlrEiMMgvsUxzMQVU9wrLhLP9MKbia7M9vVGMKU2yiG
mc2iaJFk7nEWdF3THUQWG/wXTkuEfaZSO35WySDuRfq2+OffZ9B2UpA1CbrFOlWU
QgxHtkTs/fv5fN3ZJgPqYZZ3BFJtOZdFThjOCtcNldxHlqWQEMGwVd1SC3zDrRed
AyFbzFnU3PRies3Zagyb0uaUH6dPXjKmoNqbnhZYpc4OSu+UCyvsASIeg0ebKqop
5yH3j1kAImqrfwHXMjY0sx7iK0SIglIxCPdNd5psQ6QxOLVzNgKfwCXgCb9IP54u
lvfl5D41Q/gPat0zSsvznDDTDKMpMxQUR+h5sh6GdjWfoMa4H8QaU3ihmj82ggje
4ZNZsYa8hPkYg+TtgSQ0
=r2TD
-----END PGP SIGNATURE-----

--Signature=_Wed__24_Jul_2013_14_42_32_+1000_ThXOq6ueziuduz+8--
