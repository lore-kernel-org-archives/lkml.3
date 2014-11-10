Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533AbaKJEYg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 23:24:36 -0500
Received: from ozlabs.org ([103.22.144.67]:39548 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115AbaKJEYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 23:24:35 -0500
Date: Mon, 10 Nov 2014 15:24:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: linux-next: manual merge of the driver-core tree with the mfd tree
Message-ID: <20141110152426.7f1f3da8@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/hTRvx14PAw0EFhC/4dqCaRI"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/hTRvx14PAw0EFhC/4dqCaRI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
drivers/mfd/syscon.c between commit d4ad08b424c1 ("mfd: syscon:
Decouple syscon interface from platform devices") from the mfd tree and
commit 78a835416ad6 ("mfd: drop owner assignment from
platform_drivers") from the driver-core tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/mfd/syscon.c
index 72373b113885,e85c052b302c..000000000000
--- a/drivers/mfd/syscon.c
+++ b/drivers/mfd/syscon.c
@@@ -219,7 -166,7 +219,6 @@@ static const struct platform_device_id=20
  static struct platform_driver syscon_driver =3D {
  	.driver =3D {
  		.name =3D "syscon",
- 		.owner =3D THIS_MODULE,
 -		.of_match_table =3D of_syscon_match,
  	},
  	.probe		=3D syscon_probe,
  	.id_table	=3D syscon_ids,

--Sig_/hTRvx14PAw0EFhC/4dqCaRI
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUYD3+AAoJEMDTa8Ir7ZwVugsP/iQxvDIRpMxJJtorOsBMy4cM
e4CrIWeFqgrHc1CsnuvrAp19xtvudUQyZTvpBXnSNoKYC6ldTcP6vaLqk9ZZ9CDY
NIc8DGul5L+G5A9U35YtOWybmRdliuBxUjl0Rz8tld+1IuyD7iN0WFzAdWDesHts
nH6gxENHo32qkzQIslFQHfWmQA1j6flJHpkyY0x8x0P+QmMRjExaaAPDyWZXHyqi
4+JAGhLVfP7ykiRiJFvZNUFn6iRXBnTke/m0SN6/1ALsOrZDiWQ9irjnQ8WMAV2v
1xLvs4aN61Y+gsXfC44goihDz0sWJaqC9Ck1EMPkB0n+IcK54V118XUzgZ96DCP4
8TxaDrN3mNkdW36XAHUL1fCeyqvWM8gGZEoDIhy0Sp2eIH1kFENvmHr/r1E65TJu
5t3BHUjdIEbL25CUD+cMFCuBjh39xSEeaq22TWid46DIHDiE2ongdDceXFT1u4CR
+2S4kSdDbHPwLIA1K6XZddsbzc+HcvKJpR1m3qmYDpB9hEaZeagYFuAAE2sma6Lk
Xnx6VBinBjV38PQ86SDvA0gCIbIsKIsIH/0UYATcN3Jx5MvWVI6UVlhMB28vmQEc
AnpyomGyhVNvTVjwIlql4dFa79Ow1mbQ2Eb1Zgaf8hBFp8cLA/WHEaA/m1XNf73M
2i2rLQ/xtg8My1/JUfEv
=KRYz
-----END PGP SIGNATURE-----

--Sig_/hTRvx14PAw0EFhC/4dqCaRI--
