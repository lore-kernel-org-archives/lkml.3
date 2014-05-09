Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932241AbaEICHL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 22:07:11 -0400
Received: from ozlabs.org ([103.22.144.67]:35191 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754438AbaEICHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 22:07:08 -0400
Date: Fri, 9 May 2014 12:07:02 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Miller <davem@davemloft.net>,
        "Matthias-Christian Ott" <ott@mirix.org>
Subject: linux-next: manual merge of the crypto tree with Linus' tree
Message-ID: <20140509120702.62c609a3@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/UN1PTG.WZCX3AzXJZIw5msV"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/UN1PTG.WZCX3AzXJZIw5msV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Herbert,

Today's linux-next merge of the crypto tree got a conflict in
crypto/crypto_user.c between commit 90f62cf30a78 ("net: Use
netlink_ns_capable to verify the permisions of netlink messages") from
Linus' tree and commit c568398aa05f ("crypto: user - Allow
CRYPTO_MSG_GETALG without CAP_NET_ADMIN") from the crypto tree.

I fixed it up (I hope - see below) and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc crypto/crypto_user.c
index 43665d0d0905,aa906b8fdd17..000000000000
--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user.c
@@@ -265,6 -265,9 +265,9 @@@ static int crypto_update_alg(struct sk_
  	struct nlattr *priority =3D attrs[CRYPTOCFGA_PRIORITY_VAL];
  	LIST_HEAD(list);
 =20
 -	if (!capable(CAP_NET_ADMIN))
++	if (!netlink_capable(skb, CAP_NET_ADMIN))
+ 		return -EPERM;
+=20
  	if (!null_terminated(p->cru_name) || !null_terminated(p->cru_driver_name=
))
  		return -EINVAL;
 =20
@@@ -295,6 -298,9 +298,9 @@@ static int crypto_del_alg(struct sk_buf
  	struct crypto_alg *alg;
  	struct crypto_user_alg *p =3D nlmsg_data(nlh);
 =20
 -	if (!capable(CAP_NET_ADMIN))
++	if (!netlink_capable(skb, CAP_NET_ADMIN))
+ 		return -EPERM;
+=20
  	if (!null_terminated(p->cru_name) || !null_terminated(p->cru_driver_name=
))
  		return -EINVAL;
 =20
@@@ -379,6 -385,9 +385,9 @@@ static int crypto_add_alg(struct sk_buf
  	struct crypto_user_alg *p =3D nlmsg_data(nlh);
  	struct nlattr *priority =3D attrs[CRYPTOCFGA_PRIORITY_VAL];
 =20
 -	if (!capable(CAP_NET_ADMIN))
++	if (!netlink_capable(skb, CAP_NET_ADMIN))
+ 		return -EPERM;
+=20
  	if (!null_terminated(p->cru_name) || !null_terminated(p->cru_driver_name=
))
  		return -EINVAL;
 =20

--Sig_/UN1PTG.WZCX3AzXJZIw5msV
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTbDhKAAoJEMDTa8Ir7ZwVxisP/3KgAvS38uuB+P9MbG1giINP
TPm+G9Bl5YLLu9SowZJpapXjv6cR+h1r6tN9VTfP/4WyLszOlO8dzgi7PiwxL0Yx
K2eaHp7lHYjb6LoaRYRToca2MEeFYgFlF8XsoR1st9+0Bago8uyfJW/1Vn8tAVqe
t2eTulyy+tua8E4AJhsEkiQj4pfbA4IBFu2uY3GuhahYDYv2mjDKPW8EYp0aPwqX
twAU9NyiegDSeepnQ1W0qctWmsamlTk7iuaweBqztg9lDiLYGzJ2gOE6ABfPyU8a
IpiBdu/YIXwbQqlU5PPtlkU++FYTe1ewXEOqWMV78yryu6oOwwhs54HeFSUhxdgM
YNqsa46esjz5b05G1rLlfa3x0Sa7vGXRXqI9ZvWxZbij1GMfBq78uEWdQzzI9i14
Mg5pQpkEOcQHDtRisIIZ+k0vIXMGvj/1IRZeVjyBgVPxiQNcybpgIItYCVIhPN0g
e1vP3JrhFMcvbgyG99u1bPwIMbKhrNasKPcvjOC9Xa7zm/dIelsj5tvccOUwrqR2
XeH62vJFyfcguupbJWxk0dvemc77Dxs2JFo/G0PbttdzIDx0sZUg+HDgGzKlFIz0
sIK4E/tM6PyqcOH9CZGqHgvF903At5piHNZLa3mrmKJ20HLKkRkNd/YFWCJtMD7T
cUnIhJ0LuQ3aXk7liGI+
=gbZ1
-----END PGP SIGNATURE-----

--Sig_/UN1PTG.WZCX3AzXJZIw5msV--
