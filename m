Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750790Ab3IFFFY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 01:05:24 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:45993 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab3IFFFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 01:05:23 -0400
Date: Fri, 6 Sep 2013 15:05:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sage Weil <sage@newdream.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warning after merge of the ceph tree
Message-Id: <20130906150514.729ab264b41529253d958819@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__6_Sep_2013_15_05_14_+1000_xYX+kQFNqgm2nQfc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__6_Sep_2013_15_05_14_+1000_xYX+kQFNqgm2nQfc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sage,

After merging the ceph tree, today's linux-next build (x86_64
allmodconfig) produced this warning:

In file included from fs/ceph/super.h:4:0,
                 from fs/ceph/cache.c:26:
include/linux/ceph/ceph_debug.h:4:0: warning: "pr_fmt" redefined [enabled b=
y default]
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 ^
In file included from include/linux/kernel.h:13:0,
                 from include/asm-generic/bug.h:13,
                 from arch/x86/include/asm/bug.h:38,
                 from include/linux/bug.h:4,
                 from include/linux/thread_info.h:11,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/wait.h:7,
                 from include/linux/fs.h:6,
                 from include/linux/fscache.h:21,
                 from fs/ceph/cache.c:24:
include/linux/printk.h:206:0: note: this is the location of the previous de=
finition
 #define pr_fmt(fmt) fmt
 ^

Probably introduced by commit cb0963fcf836 ("ceph: use fscache as a local
presisent cache").

pr_fmt needs to be defined before printk.h gets included.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__6_Sep_2013_15_05_14_+1000_xYX+kQFNqgm2nQfc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSKWKOAAoJEECxmPOUX5FEv2YP+wXq9ZyuQpzTxPamkLoU95w9
dkbEQr3Us9jaa0vRtrQZfnRnYcCS2l6kqmaW+cJmEWEw1Hz6ZGq+6cbew2WaubOn
93U9cX7t3oTQo/rnjRAI192oeYugtSH2313pFLFOof2sgakx6ua2lpF75Ek0h/+m
yc3QT3muZ8GgubyAF3EtQWYXvcYtCRFw/FtMITDrNsUm3yfx2NF/dUaMJa6ZfcBT
t1WuuJkS1BLRqnkmZMDXJWactvWJ5FZNzPkUYsCnVkjp2ee4+jJetLCWtp9Pke6m
Mfx+tRNDkPKUlBotjCgEfKpDBIpwW7akUmh1Xj6GTj/OM+V5E4+lQ99/uyhMEz8S
tIwkAO1m85OJRBmpg9AX4uBphItKx1+A+6XUh19Lp805kaZ+w4z4zsUg7kgOEWfG
H2vXrSqrVAdPqHVgEarrlARqCOkA86v2fgixALBj9jmIdxZhvhhh4GRKPqQ782Io
7OzVl40tfac3BPkFS9Wv6sXaxGUPJdZkVJuiV0uRc5Io15MlipDdlRmxliSoflwK
7DkFG67tbYvBDyBGh3C2r1y4P1fKA87BymtvxIBPNt3hbI4cRwT4m4F5pEh5NXUM
OKA0trmghJenRxLraHJwYZhwZo3RpeEiSbL8DSqoO+Z4m1WMgZvSb/RW5Dn72xCb
45JJbFPGVwL+JoGKnoox
=sBjO
-----END PGP SIGNATURE-----

--Signature=_Fri__6_Sep_2013_15_05_14_+1000_xYX+kQFNqgm2nQfc--
