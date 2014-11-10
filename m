Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309AbaKJI7V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 03:59:21 -0500
Received: from ozlabs.org ([103.22.144.67]:53925 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752250AbaKJI7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 03:59:18 -0500
Date: Mon, 10 Nov 2014 19:59:12 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marian Chereji <marian.chereji@freescale.com>,
        Catalina Mocanu <catalina.mocanu@gmail.com>
Subject: linux-next: manual merge of the akpm-current tree with the tiny
 tree
Message-ID: <20141110195912.324b90ed@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/ReO4V/W0WCh0Nsw_0cZ_y1E"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ReO4V/W0WCh0Nsw_0cZ_y1E
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
lib/Kconfig between commit 3a8aeefbd4e9 ("lib: halfmd4: Make halfmd4.c
optional") from the tiny tree and commit c7f379b518a3 ("lib: Add CRC64
ECMA module") from the akpm-current tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc lib/Kconfig
index b8c97f05140d,2faf7b2de5b3..000000000000
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@@ -186,9 -180,13 +186,16 @@@ config CRC
  	  when they need to do cyclic redundancy check according CRC8
  	  algorithm. Module will be called crc8.
 =20
+ config CRC64_ECMA
+ 	tristate "CRC64 ECMA function"
+ 	help
+ 	  This option provides CRC64 ECMA function. Drivers may select this
+ 	  when they need to do cyclic redundancy check according to the CRC64
+ 	  ECMA algorithm.
+=20
 +config HALFMD4
 +	bool
 +
  config AUDIT_GENERIC
  	bool
  	depends on AUDIT && !AUDIT_ARCH

--Sig_/ReO4V/W0WCh0Nsw_0cZ_y1E
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUYH5kAAoJEMDTa8Ir7ZwVcb0P/RXe9+FfVxlJGTrUP1dnGRBO
/Hgo7EsWy2THs89rakILejn6RZrXgn2O0OwcmAvozUIOXEF9o3on1gE2Pqa6wQPS
WXX4WbrLjUC0OIeNlIU2zJRrh7aKPuTZgZ6jVZDP42vmE+MYWu0sQBjVK2pSPF5o
SdYki33LO1TgK/nRS7EyKbzGIM78OG/bEFWYrLCkHjtbQd/UVLUJuE8gHTvmlqjG
gqc/MqsAYq0dmELP3SMLHV0R9waOS+DkChic39kffIAsSaktA22DJwIphjCngtEH
Iy+C27M83YJaTmeokwvm9D7G0mU5j5jeqJZEZOmY8U81xzAsAvGpOliUvESDnNhH
J+3FUvMN+EmZ9Wg+eiTKHv7wn9VT9JQP0Fk7ReswBSkkaxUMr39VqidfqZRtYUka
Cu4+e3szplp63XLiV/jKK7Pr/gncVsa8DLQzMmmbJCrILOOn0cEu7LJuryWJyRMh
jM7sRTrt7h9RBq1PtEGycuASunqzuhMLsI6FOd9L6QFGFfgo4pVtWfNdmSwkw7VQ
F8rmM+4GGVLxS+UeBUVyDx1uwhCg9VRjpUtRkJ52yeCXPy5mliL5H44M4fXX+mHe
t0VWsUupQ0rBcTF+UjsbzFqOWA46AVR3dfOQcvC2AptN7NisMCziYXT8j92PZn8b
Nif65teGXciUVpxAhkGr
=YFxl
-----END PGP SIGNATURE-----

--Sig_/ReO4V/W0WCh0Nsw_0cZ_y1E--
