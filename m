Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759686AbaCUGqJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 02:46:09 -0400
Received: from ozlabs.org ([203.10.76.45]:59260 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753331AbaCUGqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 02:46:07 -0400
Date: Fri, 21 Mar 2014 17:45:55 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mark Salter <msalter@redhat.com>
Subject: linux-next: manual merge of the akpm tree with the tip tree
Message-Id: <20140321174555.c6df4e9a1fcd20e606813f35@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__21_Mar_2014_17_45_55_+1100_IgMWU8i1qHs7dwvQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__21_Mar_2014_17_45_55_+1100_IgMWU8i1qHs7dwvQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
arch/x86/include/asm/Kbuild between commit 073d8224d299 ("arch: Remove
stub cputime.h headers") from the tip tree and commit "x86: use generic
early_ioremap" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/include/asm/Kbuild
index 4acddc43ee0c,c98cd05d1cdf..000000000000
--- a/arch/x86/include/asm/Kbuild
+++ b/arch/x86/include/asm/Kbuild
@@@ -5,5 -5,5 +5,6 @@@ genhdr-y +=3D unistd_64.
  genhdr-y +=3D unistd_x32.h
 =20
  generic-y +=3D clkdev.h
 +generic-y +=3D cputime.h
+ generic-y +=3D early_ioremap.h
  generic-y +=3D mcs_spinlock.h

--Signature=_Fri__21_Mar_2014_17_45_55_+1100_IgMWU8i1qHs7dwvQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTK+AsAAoJEMDTa8Ir7ZwVmYIP/jcvQq0En3LmnwBd6Jw9eLYr
f7P1OSikDnkRu/1XrbL4qlEptbe6FR4BZxuh0RPs5i11jVoSNUHF8e5e619KHoMh
87bfx+RRertPnkzEdffUNxvLChycsZ0cSU6EMfrU0WpPN0RF/YBWLmKzr1s8XXsG
ZY+nLhgkaJ3Vm3dZlUrFx1T2QmyUdsRraDra7nv6t5FhYmuRfIeTjcdUP2FPTn/U
i5ZVEotnqzMU8NNIQ+i0NtLEI6h+N5EG5xJu7SRKz5baU3jY7Tv4uLJL6Rw1cb5X
a2/LUZpJOkV7q20ZIHsytoEd2tofBWA1kxpy3KR7wpMBQeCHkl0Nh+9ioZCzwX9z
QglGPT9Attg7lnex+2Gs+nl5ku1jUown0n1vNa2bro4AHmC1b9bPqEDn+WM/DLt4
8trEHapsifvKjEu/r2UDQK2gr8xM0usykZe12d1B1BNW51MAv3ofAg9hmlajccA6
W7oAPWQlVBWdlZ2xF1rNqwCZ4/aGWWjvztouhJTPzZ8AHY1nEw+dNUIEUKfAlwB6
W2stB6tt2fJOvkfTU10fz2hTFGN+boq3x7CTxEeJ/gviOIRjy1a2IHFABKWNWVJc
pgtDWUnkdbhTp1KOc0WUSOxAA07zEyK4NG8HRjYiVStPAEv3mg+gB2sYR1sk/GUe
XKwImFZ7YPHaVc4SN8Ca
=y8L0
-----END PGP SIGNATURE-----

--Signature=_Fri__21_Mar_2014_17_45_55_+1100_IgMWU8i1qHs7dwvQ--
