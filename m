Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbaIWHsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 03:48:17 -0400
Received: from ozlabs.org ([103.22.144.67]:54422 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752957AbaIWHsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 03:48:13 -0400
Date: Tue, 23 Sep 2014 17:48:03 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: linux-next: manual merge of the akpm tree with the tiny tree
Message-ID: <20140923174803.1c20314b@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/.7BX=CEvPP2HJFb2uqOKdkS"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/.7BX=CEvPP2HJFb2uqOKdkS
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in mm/Makefile
between commit d3ac21cacc24 ("mm: Support compiling out madvise and
fadvise") from the tiny tree and commit "mm: replace remap_file_pages()
syscall with emulation" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc mm/Makefile
index f8ed7ab417b1,20ff8c39d064..000000000000
--- a/mm/Makefile
+++ b/mm/Makefile
@@@ -3,7 -3,7 +3,7 @@@
  #
 =20
  mmu-y			:=3D nommu.o
- mmu-$(CONFIG_MMU)	:=3D fremap.o gup.o highmem.o memory.o mincore.o \
 -mmu-$(CONFIG_MMU)	:=3D gup.o highmem.o madvise.o memory.o mincore.o \
++mmu-$(CONFIG_MMU)	:=3D gup.o highmem.o memory.o mincore.o \
  			   mlock.o mmap.o mprotect.o mremap.o msync.o rmap.o \
  			   vmalloc.o pagewalk.o pgtable-generic.o
 =20

--Sig_/.7BX=CEvPP2HJFb2uqOKdkS
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUISW7AAoJEMDTa8Ir7ZwVasAQAJX9SfW1P73K48BghOn7eL/r
4lopmDYcyp20d/VEW3qnOqzEZUfch7kg/Re+itQIzgexvnmNYKaS2kT+d7fB6xRV
75eBtJD3nG17ToRR3puFxjFbfVim3olKrN8Ia8EqRvdK/xOQIIIjM75PT1MiRvXL
zkGVPU4pRpi5JZIXOujLdAKwVR29eE3GKbrB+TWXNv2LXZHa2BYnc7xJv3DlI6XW
7UJAYjJ2YgdjkXHcmKjPQimZDBUPUMUnfWgwaczMnxKgmT52XtNkri6+To2Qng3V
o16otrROKzvNEuPJ5AHMnsCkoWYzGWv505sxlivNM9KCHwik52938EKHDyVZcny9
UqR96bmiH7AxYltItTlEIzQ0ylRfKxriNrzkwOT+TLhftK+q1430C2EeErCsp9yk
D+c/mfA+VoFGI1rOVRRXldjmym38qZpAsTmCK8MpeERx4Nq2nHRWn9XCyvL7f1Qe
Htthi27yoEJWGRBTiOnCS0tzDcPa1qa4f2deQx0RmXGV5H0mDGB9taUwSX98O3gC
c4fe7VCw5O4GAIG6EFPlWbuyAwMiAq+3TVsmUcmjyfLY4aJVthC0fY0HaxdmJU1/
QNQgTOtohbBQ1JMhfHoM7Y/t97Co+J66KpvO1gzmek7s4WfZLmnk/DuDZYMJnvbQ
O6B4tVLHzBEL7JeT50U7
=bd76
-----END PGP SIGNATURE-----

--Sig_/.7BX=CEvPP2HJFb2uqOKdkS--
