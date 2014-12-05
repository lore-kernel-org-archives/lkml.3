Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933587AbaLEDRZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 22:17:25 -0500
Received: from ozlabs.org ([103.22.144.67]:41976 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932378AbaLEDRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 22:17:23 -0500
Date: Fri, 5 Dec 2014 14:17:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Michal Marek <mmarek@suse.cz>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Robert Richter <rrichter@cavium.com>,
        Masahiro Yamada <yamada.m@jp.panasonic.com>
Subject: linux-next: manual merge of the kbuild tree with the arm-soc tree
Message-ID: <20141205141717.24ab3546@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/ea4tOUYU0zXU9tCA+KshEYj"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ea4tOUYU0zXU9tCA+KshEYj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Michal,

Today's linux-next merge of the kbuild tree got a conflict in
scripts/Kbuild.include between commit 9fb5e5372208 ("dts, kbuild:
Factor out dtbs install rules to Makefile.dtbinst") from the arm-soc
tree and commit 1846dfbde3e8 ("kbuild: remove redundant -rR flag of
hdr-inst") from the kbuild tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc scripts/Kbuild.include
index 5374b1bdf02f,353dcf09dd18..000000000000
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
+ # Shorthand for $(Q)$(MAKE) -f scripts/Makefile.headersinst obj=3D
+ # Usage:
+ # $(Q)$(MAKE) $(hdr-inst)=3Ddir
+ hdr-inst :=3D -f $(srctree)/scripts/Makefile.headersinst obj
+=20
  # Prefix -I with $(srctree) if it is not an absolute path.
  # skip if -I has no parameter
  addtree =3D $(if $(patsubst -I%,%,$(1)), \

--Sig_/ea4tOUYU0zXU9tCA+KshEYj
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUgSPCAAoJEMDTa8Ir7ZwVqIkP+wcp8hN71wiw7Q42yL+hp1cL
9Uv/LzsnSsoxnGe6vhicFVaPxmc0A4b2+ZvOC33qNGiRS5iXOLynbhyJjZpYdGqV
j+u1lvD76LbpNNrFjOvKFA/vKhFZ0BLIGAjH/VXeE3/yw2ZHgqYX7+D6ZbCPzm/M
fPMdpHf6970Vf7EVcVbPPCTLISoWqmsitBRRVBEcGlBmS/tL2bu6PARCy2wHc+Ch
/tjtqavFXEQjcq2vFmEaKDsHIilKqqJ3J8qvX9r3/DgqczZM7l8Xf56T4j+DM8Ae
fLacyCn1iIEkR+Knias5MAuFN2XM8G6gYKJkPCz9hm3o0EfAFOsO1VfLnfQbPXLA
zDG0RjgGphs5ypvMn+JObnUtgh3iEYhd4f9v+vwRqMgOg/hK2a2KqhTHy60NzMTl
1Q2dh/zz5a5DzjbdKqbfp75zFZCbgNydjuouPMMXLTWMZP1sfaNJtDs3DILM3NhE
TpjKPpCFS8/765m9r7MqpSW53czSaxrNgocGPn8EnH4ameXOMDhX+g/iYq97cMlS
iRKcBNev6pYD0CErwuaTmA0FEzfaXS2MsY0WRft7NOA62DNUd/3bLZi85fVS17J4
eQ2QbqcVuvAQjpdDswM0ygNvPlKSuh7WHUKZcXEDeU2iqTmqzi0FoYzuQYxcOOiV
b2pJ51TEKryg1Qqrbu2O
=V7MD
-----END PGP SIGNATURE-----

--Sig_/ea4tOUYU0zXU9tCA+KshEYj--
