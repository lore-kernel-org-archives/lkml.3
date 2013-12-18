Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140Ab3LRB4x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 20:56:53 -0500
Received: from ozlabs.org ([203.10.76.45]:48079 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949Ab3LRB4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 20:56:52 -0500
Date: Wed, 18 Dec 2013 12:56:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Francesco Fusco <ffusco@redhat.com>,
        Daniel Borkmann <dborkman@redhat.com>, Thomas Graf <tgraf@redhat.com>
Subject: linux-next: build failure after merge of the net-next tree
Message-Id: <20131218125643.8ff140371e1f8c306327d354@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__18_Dec_2013_12_56_43_+1100_i7Gq2pdwQ6mTjpqw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__18_Dec_2013_12_56_43_+1100_i7Gq2pdwQ6mTjpqw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

In file included from include/linux/hashtable.h:12:0,
                 from include/linux/elevator.h:5,
                 from include/linux/blkdev.h:222,
                 from init/do_mounts.h:2,
                 from init/do_mounts_rd.c:21:
include/linux/hash.h:18:22: fatal error: asm/hash.h: No such file or direct=
ory
 #include <asm/hash.h>
                      ^

And many more ...

Caused by commit 71ae8aac3e19 ("lib: introduce arch optimized hash
library").  Presumably this would break any architecture other than
x86 :-(

I have used the net-next tree from next-20131217 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__18_Dec_2013_12_56_43_+1100_i7Gq2pdwQ6mTjpqw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSsQDfAAoJEMDTa8Ir7ZwVHiwP/RHLnxKeWIvlEwMDIi8y35tQ
ykpKL1TmZ71zn+mEXWjTjJCKrCG9Tb8ao9pGShAJn2NBjsALQpuG1G2g953rD6xe
RBHMwqukza7x6l41VNM2yEAKOy0KzhHHgTX9WB4AnHBXRalvMxAlriqS7u/Dqy2W
6iwlFaS70ENVCqyuZ8VHf9eDW1FqF2aw72hjsedY0bB6rOjOjM/Leyux8wnCMSWy
tBdYrXCCKiNbjdj8XoUZ8umVgJs3/m0hgDCjlO+xBdQKkJkXziFofCWAKC2IqraB
PEWsZ/iT6Sw5nZvfvAsX2Au0Gu2VUb9iTaPmblrJO/PEG8myUxc3/6J/zNI2I2MM
bf2765JHm59X6CzOAPcJw1c6bJ/a6ZcPX6z5NgSxNOuuVUByWlygSzHX179NebbG
Tq6qYvmlkYw4X6f3kc5o7JYI0br5AJN362pP4pAD0PmmGi/TR3auJLJKfd/A4YmY
wd77CDqriHDOWy+sVdxFs9UqiKTRTBw4cxrdRn5t3BGxcp3w+znYDjNh4COYPTQr
TPtLeKWnX8prvM5JeqLgMWbRBCtdfcAubGxk0m6zgfJUE6QR02QZysA8xL1/+bxN
BuorVM1oIt37gNy4iTyGEYbjpJbMG5poqXFGto0SXani8Q365IrkesZhuWF+Ch+h
Pe4/ExVVjCu5MAVPox2/
=D1OX
-----END PGP SIGNATURE-----

--Signature=_Wed__18_Dec_2013_12_56_43_+1100_i7Gq2pdwQ6mTjpqw--
