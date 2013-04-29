Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772Ab3D2BYp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Apr 2013 21:24:45 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55507 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756586Ab3D2BYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Apr 2013 21:24:44 -0400
Date: Mon, 29 Apr 2013 11:24:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chuck Lever <chuck.lever@oracle.com>, Simo Sorce <simo@redhat.com>,
        Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: linux-next: build failure after merge of the nfsd tree
Message-Id: <20130429112434.dcc80cfce804beeacc68793a@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__29_Apr_2013_11_24_34_+1000_sgX0M30+kJRdxXme"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__29_Apr_2013_11_24_34_+1000_sgX0M30+kJRdxXme
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi J.,

After merging the nfsd tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

net/sunrpc/auth_gss/svcauth_gss.c: In function 'gss_proxy_save_rsc':
net/sunrpc/auth_gss/svcauth_gss.c:1182:3: error: implicit declaration of fu=
nction 'gss_mech_get_by_OID' [-Werror=3Dimplicit-function-declaration]

Caused byc ommit 030d794bf498 ("SUNRPC: Use gssproxy upcall for server
RPCGSS authentication").  gss_mech_get_by_OID() made static to
net/sunrpc/auth_gss/gss_mech_switch.c by commit 9568c5e9a61d ("SUNRPC:
Introduce rpcauth_get_pseudoflavor()") in the nfs tree (part of the nfs
tree that you did not merge).

I don't know how to fix this, so I have used the nfsd tree from
next-20130426 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__29_Apr_2013_11_24_34_+1000_sgX0M30+kJRdxXme
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRfcvSAAoJEECxmPOUX5FEjJwP/0Vq2kAnv/o6Hl0FBsQIBv3l
/DPFJRxvqvisIS9t/KFC526vHHhCDz4JyNc+kXT8Mpp2nqJDe/Teim/HoH7ZbKSQ
NLfq0RLBvFAaltF8PJKOC9oh71ZIpW52tvV6MdLMc/d630wGBhj4TakUxOH1+5Xm
kzyLZH474fZopiYx8xMHg8yAvaNJ+cO6fXkW+GbR/CN+3qga/IV6MgJNK1yUxhc5
x3vj3q3F3pMayRmwl6u5PjAAHLZA4Pe1DYFsP7hYt5dB+liX+BQvXk9QLlCD3wX+
8x0EkthEXCnE3RtTV4rBWKZtVLnTAQrnqCIgrfvm1GxU/vtS02XDoPIRU2AMoXG+
lGzSmdIWl0zZsOKYEXOwjfiNS2BUsc2ifKGZfOVQqWNZB2T0EIYod/C+8SHzOmZQ
Z6cIRlp1esTcdTCXI0dyXS4F60KN2j2lYH2F5iCwvcABRhKbG09Tw62pYQXY/Bng
LDMKnqDvARK1UZjPoJFyYZZD2Bh20BFfNKiGu87gyCdRaUHSrQmDVb3NKmNHHsNj
8HQkGTfbk9vSPifNhK2g8ss0L96lBrL0is3Kk4tXQGoQel7JstlO5q3/AOLRcI4d
gkV9IdL5zyasFfd1ofQlo+tLnISLSTBL9CmY6c60IAuwMKtZy9W3kNbsm3EuCieR
/Yr2qTHbjsaij2ax/0Ja
=69sz
-----END PGP SIGNATURE-----

--Signature=_Mon__29_Apr_2013_11_24_34_+1000_sgX0M30+kJRdxXme--
