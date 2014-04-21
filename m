Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181AbaDUSvg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 14:51:36 -0400
Received: from mout.gmx.net ([212.227.15.15]:51505 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775AbaDUSvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 14:51:33 -0400
Date: Mon, 21 Apr 2014 20:44:39 +0200
From: Christian Engelmayer <cengelma@gmx.at>
To: tim.c.chen@linux.intel.com
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] Cleanup ressource leaks in test_aead_speed()
Message-ID: <20140421204439.7999f1c6@spike>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/6w5g8g+IuHqg1aLNmIkwpza"; protocol="application/pgp-signature"
X-Provags-ID: V03:K0:w4oTe9JEGEUBocD9QBBpvAlQ2KbLB5I5q37tl7AvjpynUPB4PuM
 fboxbBQAOWqMuHj17eO27oxJp93o5R+wepNBRxrq/Ri8SiuuKyTkjFaVUknqIO7oWZhCejQ
 ffx1L/MvevSCgn52F9MN7OYoziAsmJC4seh4x+HBRyQes1rrU1v9L/QoPkFMGHXrkRLkJw8
 z1MKLRK0wMK914nyKsixA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/6w5g8g+IuHqg1aLNmIkwpza
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

This is a cleanup of Coverity ressource leak findings for the quick & dirty
crypto testing module crypto/tcrypt.c.

All 3 changesets address function test_aead_speed() that was introduced in
53f52d7a (crypto: tcrypt - Added speed tests for AEAD crypto alogrithms in
tcrypt test suite)

The series applies against v3.15-rc2 as well as branch master in tree
git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git and is
compile tested only.

Christian Engelmayer (3):
  crypto: Fix potential leak in test_aead_speed() if aad_size is too big
  crypto: Fix potential leak in test_aead_speed() if crypto_alloc_aead() fa=
ils
  crypto: Fix leak of struct aead_request in test_aead_speed()

 crypto/tcrypt.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

--=20
1.9.1

--Sig_/6w5g8g+IuHqg1aLNmIkwpza
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTVWcXAAoJEKssnEpaPQKEhoYP/iO8O8yYBmWB+5S30QjXDMYN
RowxWQregKplXPrS8zrNGI3+K8eI5pgRq8sGx2Or8T8oneAQeVOT+2XE3S7+OFjZ
4creShbrGZTvhyVULymTiQe8oPB5fJ/QaSFJBquGGQGp1ILH8q165BktKidL01TQ
LXak8x9EphNW+7guI1iXpQv3xIvKRzKqPzegqkrKl0lSVmihk2a9VI4/XVh1M7Rn
7YwIjddiOFNIN177+u4dkXkClJh0NiXix6su7mOJamJOeprcI2S+q/XCZrqP2zyz
8/nA2NhOP4orABTWAudOQP9AU8X2SY9Gt3H5AuMmCBfxsYQIqJ1hff8jc20Sh8t/
iY2dDM0CdZaaMd5eAm3+UCeGNyrNFTc7rZ8ZtBr3DRhNOdQzAoTqqY7FjgSInUR5
MvAh1yMfo02+wuAAR40hoqI6Gvle98/4vJjO4KbP3Qs3ewtLIZGnUa4ISjEZFWQs
xFONfZyMoClQm0gaI7F680YbdaB+nB7v/olRwQ7n+SIeuhjqXW8JOfVk2Upcc3fr
N88Y0B+fHNXv0eYt+yzPOet2Cm31LToi84qEF7miIijyHDRbZQHrEDGbKlDJ8FQL
RX9X12cm8iGI2Is49j/WG0uAjWrt90YvNEPqR/4jIBZEt7ey2RwA9dirqmAbWW7y
zZvP677mwYEJ9l7dtSiA
=Gz9K
-----END PGP SIGNATURE-----

--Sig_/6w5g8g+IuHqg1aLNmIkwpza--
