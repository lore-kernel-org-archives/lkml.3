Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690Ab3CABEL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 20:04:11 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:60273 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab3CABEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 20:04:10 -0500
Date: Fri, 1 Mar 2013 12:04:01 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: linux-next: build failure after merge of the nfsd tree
Message-Id: <20130301120401.bcb4a3c571cb0d2b7af96a4b@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__1_Mar_2013_12_04_01_+1100_s=QuJCLBvy0noIKT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__1_Mar_2013_12_04_01_+1100_s=QuJCLBvy0noIKT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the nfsd tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

net/sunrpc/xprtsock.c:1923:30: error: 'struct rpc_task' has no member named=
 'tk_xprt'

Caused by commit dc107402ae06 ("SUNRPC: make AF_LOCAL connect
synchronous") interacting with commit 77102893ae68 ("SUNRPC: Nuke the
tk_xprt macro") from Linus' tree.

I have no idea how to fix this, so I have used the version of the nfsd
tree from next-20130228 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__1_Mar_2013_12_04_01_+1100_s=QuJCLBvy0noIKT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRL/6BAAoJEECxmPOUX5FETYcP/R9Uwofv3E0CHDl8qTSpl/bu
2YPgKANTZgOOt+hyHRFsNRCSn9tIZQTt/qEFv4hBXcUbyiBM6LY4f/et/BPzl3+F
gzHHwXY89sqi4emH8BufhVPs28PtMUKn/0X9/aQTuWRIiXbvhstb49Sr7PYItUWw
khjujgsVFvCi+UNrsR6A5fq2wZ4dxvssFt0hbMRJVI2khAw7dc9+90n8WbiVBNLP
jaCJKBMXKtM6tye4QRHHnk+2wt8wPLfpUX4tjxM6Ga2Q4Nl1vQ+mlQUh/B+hKC04
ITZcwLyGaLzlcsSd+8UkxYDnrU/goXllO64v/vP0DzvzD1JAXbPh/Lo8I/7o1ROs
Q8XeQo3ZIDcUwExAerQx5p5E5Q+9ozSpSi6IrDCew/y+PgL8BM7aMSdQQXpXdbJm
o0RG1m3L5w2BA0OLWEC0y+pVghdP/Km7OM4YrRxa/8dcFC43FqdbzZJyYRmRlvym
hVojSt2hzaHJJjLsYGYG7JgcbpS2eB6Gs8Du7QP5PCzfLwPGbze0LQem2ZYplj0E
HoRVbN2oz4WqR5bKyFEQ2aaq/mZKWmb5WlA4XNMO4IO++n9vbVxNN0JnPcrA8PHZ
MSAlZCsm+qPYMYLJ/Dk/R677nPLmo1bEP6yypudZ6Q4RG45UliIJ/ul/tN7fVaAA
TR02AYaPZVRx5wMDKFjy
=GhEI
-----END PGP SIGNATURE-----

--Signature=_Fri__1_Mar_2013_12_04_01_+1100_s=QuJCLBvy0noIKT--
