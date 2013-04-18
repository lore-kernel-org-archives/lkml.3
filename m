Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056Ab3DRHuP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 03:50:15 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:57394 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982Ab3DRHuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 03:50:13 -0400
Date: Thu, 18 Apr 2013 17:49:57 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Bolle <pebolle@tiscali.nl>, James Hogan <james.hogan@imgtec.com>
Subject: linux-next: manual merge of the ppc-temp tree with the metag tree
Message-Id: <20130418174957.90176c7a0a6b95d3cb30a5a4@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__18_Apr_2013_17_49_57_+1000_Z+HerTYRCOwE7F9y"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__18_Apr_2013_17_49_57_+1000_Z+HerTYRCOwE7F9y
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Michael,

Today's linux-next merge of the ppc-temp tree got a conflict in
arch/metag/mm/Kconfig between commit 2b8660ed3bfe ("memblock: Kill
ARCH_POPULATES_NODE_MAP once more") from the metag tree and commit
45b02f8d94e3 ("memblock: kill "config MAX_ACTIVE_REGIONS"") from the
ppc-temp tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/metag/mm/Kconfig
index 794f26a,ccf2576..0000000
--- a/arch/metag/mm/Kconfig
+++ b/arch/metag/mm/Kconfig
@@@ -93,11 -93,9 +93,6 @@@ config ARCH_SPARSEMEM_ENABL
  config ARCH_SPARSEMEM_DEFAULT
  	def_bool y
 =20
- config MAX_ACTIVE_REGIONS
- 	int
- 	default "2" if SPARSEMEM
- 	default "1"
-=20
 -config ARCH_POPULATES_NODE_MAP
 -	def_bool y
 -
  config ARCH_SELECT_MEMORY_MODEL
  	def_bool y
 =20

--Signature=_Thu__18_Apr_2013_17_49_57_+1000_Z+HerTYRCOwE7F9y
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRb6WlAAoJEECxmPOUX5FEiLcP/1Iki+Dyh0p5FT74CXQWQomM
76311xhkknGd4pY5l+gVQTfiT/GKsYziY2d6Ymy7mLC6UXLkhJ6NH430Kk2BbZHc
cufSH1o0G4DOmNaZamIx6ZbsJn2UsV8YS79XGY+Jw9Z/wYAmWM66TEH7hpEe38Ru
c7d59sEsaa1JQT8fNaeqvdEMgNmKzxuPdvuEhfxfNuxhjMOvs4kO41zfs+pVqcXJ
ZhOz2fvTtcwBeh2ql5Ey5u6K5aZ4C951l1EyOYGO8PzQ7JdGISdhV/0ammeG0/JT
2N3T9RgcEPPSGlwZjALMgYHWREH7Es94pp2ArpHC1hLSZ4BeI5oWwAlV1Ncn8uk4
7wPmfVMy28xIyddHwEQdTL1k8lDU/stE/xidZTLy7f4S226FjUBKo2CdMOQESvAr
I4p7XZnkUiF4aYKy4fL5tRTMIhIl4idTlgS9StyLIkiLB1+b8fVL/9yAMMV2liWq
Nc5muTcMxHciRwFxBFXzgNUgHw7jenrKI8Xa2f6O7jLY3VoWYUdcv6U4kq0GcWex
ZCJ2Fvivgq65wi7KXFQy27hjirRfZD+K3cetOatpmlVLEwItyIhUtyRmfFaoPTWc
7ZLCrj7HENDUUMW9xrbhx60D0OWHHZIKeShrFbgxlAiLHY60uOySLJY6IyXoValB
84QeOBnx0lF/ETva3ySG
=2sxa
-----END PGP SIGNATURE-----

--Signature=_Thu__18_Apr_2013_17_49_57_+1000_Z+HerTYRCOwE7F9y--
