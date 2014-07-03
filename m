Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481AbaGCE7u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 00:59:50 -0400
Received: from ozlabs.org ([103.22.144.67]:37664 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754629AbaGCE7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 00:59:48 -0400
Date: Thu, 3 Jul 2014 14:59:40 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vivek Goyal <vgoyal@redhat.com>
Subject: linux-next: build failure after merge of the akpm-current tree
Message-ID: <20140703145940.002b7056@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/=ttZzPY9/.AYNox9B.t4pIM"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/=ttZzPY9/.AYNox9B.t4pIM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm-current tree, today's linux-next build (x86_64
allmodconfig) failed like this:

/bin/sh: /scratch/sfr/next/scripts/basic/bin2c: No such file or directory

Presumably caused by commit 572a8e0147f8 ("bin2c: move bin2c in
scripts/basic") and commit 1b4c30351f49 ("purgatory: core purgatory
functionality").  Note that the directory above is the *source*
directory (I build with O=3D...).  bin2c is in my object directory (in
scripts/basicbin2c).

I have added the following patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 3 Jul 2014 14:56:25 +1000
Subject: [PATCH] purgatory: run host built programs from objtree

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/x86/purgatory/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/purgatory/Makefile b/arch/x86/purgatory/Makefile
index e5829ddbca2b..7fde9ee438a4 100644
--- a/arch/x86/purgatory/Makefile
+++ b/arch/x86/purgatory/Makefile
@@ -18,7 +18,7 @@ $(obj)/purgatory.ro: $(PURGATORY_OBJS) FORCE
 targets +=3D kexec-purgatory.c
=20
 quiet_cmd_bin2c =3D BIN2C   $@
-      cmd_bin2c =3D cat $(obj)/purgatory.ro | $(srctree)/scripts/basic/bin=
2c kexec_purgatory > $(obj)/kexec-purgatory.c
+      cmd_bin2c =3D cat $(obj)/purgatory.ro | $(objtree)/scripts/basic/bin=
2c kexec_purgatory > $(obj)/kexec-purgatory.c
=20
 $(obj)/kexec-purgatory.c: $(obj)/purgatory.ro FORCE
 	$(call if_changed,bin2c)
--=20
2.0.0


--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/=ttZzPY9/.AYNox9B.t4pIM
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTtONBAAoJEMDTa8Ir7ZwVKnYP+wYcc1wW0F5w8m7oA5eiiNES
UJ6Uct/EJhUoanP7UobZdpnBqGCgHLeHONxSqMuhdf9Z/nRgdgRQD1kZO/sq7RH1
KedhFZBQHgtOHHlSW4aKQXeQNhcV1Z5fDmGTWJZrmVEtOeD80y606jvgPmoYuCpy
5pWJYJlSziEt52ztFYHv2+DVGZTQkf5X+OnyXyW7w8jdCTG3rzbpVunCrCQFEiFg
/I0rgow7rXgRVxPBud/lVfDZZYYrVm7FuvaEJcx+WqvhY0dvAwxkNXCaK5E7Fssm
UfsbsXf/M/3LPkN+LXRm9o7kKwaoTawk+czfMCVnpg6dVBeGGcPclJuheJxKQ83L
w5IWfM++FVEKYs758Fhxz29av4TR7UCz4hD55d6XMLgOxBrwkVv49rqzONSbx69z
sr9NSXRhYV9xR3kAbI0P/DBQFNGxyiqLydfmNaKUrM30BfEtlGFWleV0/4m39vgY
vvKO+gxB3o1VwNqivFV+n3lbQUWVa56zcMkS4fZcaSrP+WmXuigiO3KdxDgEQqQq
/2iutASJrsjQtmVq5Si8IqjsObk6IPrqFl1kA5JofaOd4X5j/w9M0z8XUf4BwL4W
Rmo1zl86L162Nwsd52VfBMkS2oZLhoR0wh/5iqaqU38nLRBfZBc/Nd68lVhbPPt5
TEUTmBQTzTrtgGYXfUlS
=/6g2
-----END PGP SIGNATURE-----

--Sig_/=ttZzPY9/.AYNox9B.t4pIM--
