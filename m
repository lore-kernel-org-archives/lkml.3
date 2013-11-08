Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588Ab3KHHIM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 02:08:12 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:47800 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab3KHHIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 02:08:11 -0500
Date: Fri, 8 Nov 2013 18:07:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the userns tree
Message-Id: <20131108180759.12dab53816900b1b58c1ea1b@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__8_Nov_2013_18_07_59_+1100_wNYv58u5cR1bxlPN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__8_Nov_2013_18_07_59_+1100_wNYv58u5cR1bxlPN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

After merging the userns tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

fs/namespace.c: In function 'detach_mounts':
fs/namespace.c:1340:2: error: implicit declaration of function 'br_write_lo=
ck' [-Werror=3Dimplicit-function-declaration]
  br_write_lock(&vfsmount_lock);
  ^
fs/namespace.c:1340:17: error: 'vfsmount_lock' undeclared (first use in thi=
s function)
  br_write_lock(&vfsmount_lock);
                 ^
fs/namespace.c:1340:17: note: each undeclared identifier is reported only o=
nce for each function it appears in
fs/namespace.c:1345:2: error: implicit declaration of function 'br_write_un=
lock' [-Werror=3Dimplicit-function-declaration]
  br_write_unlock(&vfsmount_lock);
  ^

Caused by the interaction between commit d7e58b8abc4f ("vfs: Add a
function to lazily unmount all mounts from any dentry. v3") from the
userns tree and commit 84550b9356af ("RCU'd vfsmounts") from the vfs tree.

I don't know how to fix this up, so I have just dropped the userns tree
for today.  I only dropped that tree because it was the latter of the two
conflicting trees.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__8_Nov_2013_18_07_59_+1100_wNYv58u5cR1bxlPN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSfI3UAAoJEMDTa8Ir7ZwVL9sP/RyIx4Bgz5gVke55WsKNc42T
SI0qdqOtanceP/3pBjtdA37UAkJD8YZgFZE/k5TU6bNHuG+rnhY9B/oVY+IxNaqX
vRV0je3ibChGj5SLWEKjMhiJXyBAGutfDSLXwkwHAjF5Yrq8XNBT+h9pBZ1MiDH+
e/mIvRs2RS0eUpANRRPA2VaVORoHw2DKE09E0UFPuuINy6kLyOjRUoHPQEpX9iZU
E3faTzOogI5iypiwGLw1ZicmP45Xpqz1islBMjamKcPyVUNzjrwgASzbZ81auHkr
OEpDmhdxZpmmhIUrD/I4wC3+uoNbEbt7tprVmpEKD6lWrmg94eSQpLZhoFJ/buyG
K+KccIPrLecOqW3M8lWb+e2lG3ibORhmKi/6Q3kzi1DRv9n8fhGiEXA1uonrxPA7
6/zJ77hoQS05eqo3/DgIOh3JTs1uPQAXTGrqbn3dewEVBkgUjT2xM1rXFVJ5Gk08
1TgF+m6+tpQTAj2t8YKEJJK5fhFtAne0hifx99Hj0jr07KOucCXVksCjWhBOB8p9
Ybn2dDZojQBh8WPUmqAB82U7Wq8oA/Xy3nzUnxXCu/pUj0YVc3doLdOHGDvQ1zmP
7ZtpJjD3XHUEFlreDeUbdh+VCPoDnyUxU/5v+CqozSTsLnOZqCE0S/YfNlrebfSV
057F149Gk5aVSaraB/nL
=78F/
-----END PGP SIGNATURE-----

--Signature=_Fri__8_Nov_2013_18_07_59_+1100_wNYv58u5cR1bxlPN--
