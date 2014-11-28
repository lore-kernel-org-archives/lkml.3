Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434AbaK1B6p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 20:58:45 -0500
Received: from ozlabs.org ([103.22.144.67]:59840 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051AbaK1B6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 20:58:43 -0500
Date: Fri, 28 Nov 2014 12:58:36 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Michal Marek <mmarek@suse.cz>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Robert Richter <rrichter@cavium.com>,
        Masahiro Yamada <yamada.m@jp.panasonic.com>
Subject: linux-next: manual merge of the kbuild tree with the arm-soc tree
Message-ID: <20141128125836.2736fe99@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/.yJhN57SwRfdhrx1C=2ko38"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/.yJhN57SwRfdhrx1C=2ko38
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Michal,

Today's linux-next merge of the kbuild tree got a conflict in
scripts/Kbuild.include between commit 9fb5e5372208 ("dts, kbuild:
Factor out dtbs install rules to Makefile.dtbinst") from the arm-soc
tree and commit 371fdc77af44 ("kbuild: collect shorthands into
scripts/Kbuild.include") from the kbuild tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc scripts/Kbuild.include
index 5374b1bdf02f,0f909814edfc..000000000000
--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@@ -180,11 -180,17 +180,23 @@@ build :=3D -f $(srctree)/scripts/Makefile
  modbuiltin :=3D -f $(srctree)/scripts/Makefile.modbuiltin obj
 =20
  ###
 +# Shorthand for $(Q)$(MAKE) -f scripts/Makefile.dtbinst obj=3D
 +# Usage:
 +# $(Q)$(MAKE) $(dtbinst)=3Ddir
 +dtbinst :=3D -f $(if $(KBUILD_SRC),$(srctree)/)scripts/Makefile.dtbinst o=
bj
 +
++###
+ # Shorthand for $(Q)$(MAKE) -f scripts/Makefile.clean obj=3D
+ # Usage:
+ # $(Q)$(MAKE) $(clean)=3Ddir
+ clean :=3D -f $(srctree)/scripts/Makefile.clean obj
+=20
+ ###
+ # Shorthand for $(Q)$(MAKE) -rR -f scripts/Makefile.headersinst obj=3D
+ # Usage:
+ # $(Q)$(MAKE) $(hdr-inst)=3Ddir
+ hdr-inst :=3D -rR -f $(srctree)/scripts/Makefile.headersinst obj
+=20
  # Prefix -I with $(srctree) if it is not an absolute path.
  # skip if -I has no parameter
  addtree =3D $(if $(patsubst -I%,%,$(1)), \

--Sig_/.yJhN57SwRfdhrx1C=2ko38
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUd9bRAAoJEMDTa8Ir7ZwVoecP/An6nKRpg8VpWjRgTtvMSUXT
qDrWF3nbszSR6l5yeWHgYJocel+3SN+4QSb7zHujlKZcGc6T72eDFaN7cNjOywuV
l6RXmnYNLkDsWkz63dtRo46ounUG1DwBxKv8IS52QFlbfUYeNifROYd2k2Gr3LCQ
adLP4o3UF3iHqUSS/2ftpw3GChyuZQzg1lukeyLBne3FbPf3dXGdccv3QpvjmUa3
D7L5102vAaPy44WJfrBOqaDKz3R9Eoz26puA9zUrTA1pCqz1bCRb4WVb9e2dACjw
++1+XjODPY9DoJ+v7ZCK0AvjXuEMPghY+SwZE4WA2J/OwUCgwcp0rX6KEbZIp+G/
r2/pgLBd/ODmTgiBnfgzx+Usx238dYinooJyBTViARppP1wdFq9fVBo8sxJsrjy2
/8Xto4Zon7Rmcs84iTywml0nBV/kbMqHRqzSMbrTdA9j883kNVuFUI/xmAKMK8QH
8WazQBTSrtzAdNt11n6P3pFagz/cvahQYS116jbWDJzML+mY/EdwN3HjqHvJ1fv2
A+BXNFVZDHYkSXtwJuu2Q6yptc6Av15AViE4vglJsQG7b13NdY5PYH5GGEIgAY2x
mIHqi6R6UWe7LuKtFnSRlw7tO0ZYYyJjHfrGvcfnXR3Q1af/mgyabDXYm4LR73qx
yL0x3BsENqdZnHYIgSj6
=xASJ
-----END PGP SIGNATURE-----

--Sig_/.yJhN57SwRfdhrx1C=2ko38--
