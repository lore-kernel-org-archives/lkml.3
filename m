Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227Ab3FQHNO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 03:13:14 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:44047 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880Ab3FQHNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 03:13:13 -0400
Date: Mon, 17 Jun 2013 17:13:05 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Simon Horman <horms@verge.net.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ulrich Hecht <ulrich.hecht@gmail.com>,
        Bastian Hecht <hechtb@gmail.com>, Paul Mundt <lethal@linux-sh.org>
Subject: linux-next: manual merge of the renesas tree with the sh tree
Message-Id: <20130617171305.d97598f75a42dfba89b3dbd0@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Jun_2013_17_13_05_+1000_+jyu+a8f9Byx2xN="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Jun_2013_17_13_05_+1000_+jyu+a8f9Byx2xN=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Simon,

Today's linux-next merge of the renesas tree got a conflict in
include/linux/serial_sci.h between commit ada80ee7fa60 ("serial: sh-sci:
Add OF support") from the sh tree and commit 24610a30600b ("serial:
sh-sci: HSCIF support") from the renesas tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/serial_sci.h
index 857eec4,d340497..0000000
--- a/include/linux/serial_sci.h
+++ b/include/linux/serial_sci.h
@@@ -18,8 -16,7 +18,9 @@@ enum=20
  	SCBRR_ALGO_3,		/* (((clk * 2) + 16 * bps) / (16 * bps) - 1) */
  	SCBRR_ALGO_4,		/* (((clk * 2) + 16 * bps) / (32 * bps) - 1) */
  	SCBRR_ALGO_5,		/* (((clk * 1000 / 32) / bps) - 1) */
+ 	SCBRR_ALGO_6,		/* HSCIF variable sample rate algorithm */
 +
 +	SCBRR_NR_ALGOS,
  };
 =20
  #define SCSCR_TIE	(1 << 7)

--Signature=_Mon__17_Jun_2013_17_13_05_+1000_+jyu+a8f9Byx2xN=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRvrcGAAoJEECxmPOUX5FErtQP/1owf6eCPPP8QBx1oqym8Zoq
IeTG0dDTm3JHJQ0ur8rDLhDN70nHG+hJsXwgnTRcgwxsMcn7WPqU6/lxp+StEm7A
XQfxthhmLsFDzOabHVGW5QrGyjVxZydlLnq1ImaHMNKim8HIP6klfyIk41qGDOnL
7T3JocovGkJyr5FRyXv5rtBeZgT/U27hmfaXyAc+oLWcDSD9ic5dD9Vtux3P+sUO
Fu/yUqM5f+OEbKyNVpeU40mR/sNKRe5XJIWmi1um9pS9NuoFfDmLh7vlvQ/ybl1r
mkRM4XqfVzP4WIPtYTg6SOQU3GPRwmjA0E/C5Q8GA7qp9VRiK4km5j3NZzgzfjV7
IIp2LXXQTiXJoeZkbiG2AGx3r78/nuDn/jsqQIpkK0fk6pzEsFvGh2rrfdrcb//F
2Eu8m6cUmrFIdQK4lL/bnKjyztvgPLjnZ+Q103BjJeUdV7JdhqijRoEeANcoUhPl
s0eYUEs+e5DwIReNRmFn7tPOU/ZrH29GKSz1gFYGcJd8pco8EnJMUbDu1+2frHUD
f5/eyjgbe9DIRlXvRUIHwqsn69bBTOgMLPk6YpdDZGvTVZLTDJrXbtwM01y1qZE5
hzj0hm+oVEvDVq9Dj/JDNvyR83iN8DDYfaL69FKfSLGy87T7QNcZQFbp5tKyceyl
lyPYhz/1fn/Vv3DHt90u
=bYtj
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Jun_2013_17_13_05_+1000_+jyu+a8f9Byx2xN=--
