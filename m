Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757206AbbAZXqI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 18:46:08 -0500
Received: from ozlabs.org ([103.22.144.67]:38715 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753431AbbAZXqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 18:46:05 -0500
Date: Tue, 27 Jan 2015 10:45:58 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@kernel.org>, Will Deacon <will.deacon@arm.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: linux-next: manual merge of the arm64 tree with Linus' tree
Message-ID: <20150127104558.003abf61@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/zacKz=pAtT62+HJVu9U8EM1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/zacKz=pAtT62+HJVu9U8EM1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Catalin,

Today's linux-next merge of the arm64 tree got a conflict in
arch/arm64/mm/dump.c between commit 284be28565ef ("arm64: dump: Fix
implicit inclusion of definition for PCI_IOBASE") from Linus' tree and
commit 764011ca8247 ("arm64: mm: dump: add missing includes") from the
arm64 tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm64/mm/dump.c
index d54dc9ac4b70,bbc5a29ecaaf..000000000000
--- a/arch/arm64/mm/dump.c
+++ b/arch/arm64/mm/dump.c
@@@ -14,8 -14,9 +14,10 @@@
   * of the License.
   */
  #include <linux/debugfs.h>
+ #include <linux/errno.h>
  #include <linux/fs.h>
+ #include <linux/init.h>
 +#include <linux/io.h>
  #include <linux/mm.h>
  #include <linux/sched.h>
  #include <linux/seq_file.h>

--Sig_/zacKz=pAtT62+HJVu9U8EM1
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUxtG7AAoJEMDTa8Ir7ZwVclsP/RvJ24Jo0LcdQNz+rTk39srG
xPf5iQ/yr9CzcHWm2l0/NU33HRLiN0re9Tqu0tNma7cfMcLvhcIcwzOzxTMFvRCW
HWsVn7V2ZLQ6XRau8ysYr2NBKStBD7CDEKHPpoYERrjHttwQ+QU21TFalBXIc2bX
XZHhSymPW+eaEeg4301A6+ZSOYdl5nltVlfl7EXr29tmAEhy5lHklrZFWmonj0uD
45cULoSEZD1hskb6IrUgsEzsxL2y9ojkmfeZ/bBAcmqe+JI5ED7lMJc4kLI+I0Ub
Z6kRUAhwTvUbUt8mRgMaVrq3fk4ViPK1S1vwZVc1b1SuzBUKGEMh3B3dynLXl8nq
0ZAWFXi5P2J/9Q3Eoe2KBoxEWwUXPhKn6Jh01RYl3tmNma2EFK2eos7wxkkdFB/l
4UYjfOtiYiEwrzliajkJ2hqUR3ZzBAITOsr/u5h4bCvGXZ3dAFA0AnXc2FvG6Pf2
/dQ9dhzpzpIaWCEH/SB953Y8zHCSryv14UUiR/VknpqlVqXkEfIGloR5a1OGLGdA
EyUfFNvVRHy6A11FVflXpTdLRPUlc97vLydMCPKxDkHRBFw2dtW3BhUqNtJDdeDP
ThSz67biroPko3EZHGYv1Bb57vbVS6ZI+0kMPLI3COkJq3z0wkdJcmunXGdDBpqV
QCvAmnRVuvMv2HGOpQyK
=hW7z
-----END PGP SIGNATURE-----

--Sig_/zacKz=pAtT62+HJVu9U8EM1--
