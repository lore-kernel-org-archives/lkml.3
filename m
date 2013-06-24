Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262Ab3FXBf4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 21:35:56 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:39014 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab3FXBfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 21:35:55 -0400
Date: Mon, 24 Jun 2013 11:35:40 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the vfs tree
Message-Id: <20130624113540.dd2911f4d0a4732635eb2aa7@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__24_Jun_2013_11_35_40_+1000_OP7SqkoCGkBqHOM2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Jun_2013_11_35_40_+1000_OP7SqkoCGkBqHOM2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

After merging the vfs tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

In file included from arch/powerpc/xmon/xmon.c:41:0:
arch/powerpc/include/asm/spu.h:245:43: error: 'struct coredump_params' decl=
ared inside parameter list [-Werror]
  int (*coredump_extra_notes_write)(struct coredump_params *cprm);
                                           ^
arch/powerpc/include/asm/spu.h:245:43: error: its scope is only this defini=
tion or declaration, which is probably not what you want [-Werror]

Caused by commit 27e58d7e7e6d ("[needs split] switch to saner coredump
primitives").  Presumably, arch/powerpc/include/asm/spu.h needs to
include linux/binfmts.h or just forward declare "struct coredump_params".

I have used the vfs tree from next-20130621 for today
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__24_Jun_2013_11_35_40_+1000_OP7SqkoCGkBqHOM2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRx6JxAAoJEECxmPOUX5FEAp8QAIo3viwvb2Rx25OGrKmrSD8h
h6YgT2KXzt5dgHri9qyfpdQ2sXtjK53xg7lLde1a6VG4CUaqdWlPOkAwHmaLaaax
MAeJgtU4t5ql4K+i7987zWE4DpgfnWBP5JUv6MWiJBDMuRnDltikH6BHeynELOzt
5jawBXLjvXc25XhjW3gbtiJG1pl0hbb9zlp6EVXgVRwUqZ9CABHcywM2TPGQQOIy
V2ZWh/sR6ujbckIwgx+IjXU4yTdbE8/EB3I3IU+JIrX+HJfmpy3OTz5ty95UfMza
Tfj3WdBPLoBhKeNeu0zK0SBNoGhE7k7tm4h4WkTkZFUyiV2XllgBH+f1ArGKd7v7
X/qEcUzF0rmaBoXFA/zWAjbjXM+8n/oxCJyTPTJM9biL4lUB6o9aa/mfKpoflTdk
Md12CUBdhEa7e9uRKSZz0FrQb57mEHpU7O7ehMOdKjPIdCLye2n+OE+2Qv1J0fnE
vqQJuMOoDLf9lV3hubluiHnFGoPajBZrl9pLTixVe48zCwTe4Ki70dE8IpQ3IWvb
Foty0+n4klvdVnEErbfeiWreOu1jqQZXjnPpq8dV8KxmSs4g4NUm+G2tIWvQ+zXh
AUC+YVepW4EMahZmmuCA20VbT94Bv0maqRK7v4p79Px7NX18ypZwuGdvjHMBjhmH
FLHVx4kcioAuBRz992MQ
=w0mp
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Jun_2013_11_35_40_+1000_OP7SqkoCGkBqHOM2--
