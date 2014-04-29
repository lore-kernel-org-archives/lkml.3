Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814AbaD2Ers (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 00:47:48 -0400
Received: from ozlabs.org ([103.22.144.67]:36697 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753AbaD2Erq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 00:47:46 -0400
Date: Tue, 29 Apr 2014 14:47:40 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Davidlohr Bueso <davidlohr@hp.com>,
        Linus <torvalds@linux-foundation.org>
Subject: linux-next: manual merge of the akpm-current tree with Linus' tree
Message-Id: <20140429144740.0666b2b6ff4c7c6f02a4b301@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__29_Apr_2014_14_47_40_+1000_qi0SJln5SAQFGkT3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__29_Apr_2014_14_47_40_+1000_qi0SJln5SAQFGkT3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
mm/vmacache.c between commit 50f5aa8a9b24 ("mm: don't pointlessly use
BUG_ON() for sanity check") from Linus' tree and commit 8beba5473820
("mm,vmacache: add debug data") from the akpm-current tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc mm/vmacache.c
index 1037a3bab505,61c38ae9f54b..000000000000
--- a/mm/vmacache.c
+++ b/mm/vmacache.c
@@@ -81,12 -93,11 +93,14 @@@ struct vm_area_struct *vmacache_find(st
  	for (i =3D 0; i < VMACACHE_SIZE; i++) {
  		struct vm_area_struct *vma =3D current->vmacache[i];
 =20
 -		if (vma && vma->vm_start <=3D addr && vma->vm_end > addr) {
 -			BUG_ON(vma->vm_mm !=3D mm);
 +		if (!vma)
 +			continue;
 +		if (WARN_ON_ONCE(vma->vm_mm !=3D mm))
 +			break;
- 		if (vma->vm_start <=3D addr && vma->vm_end > addr)
++		if (vma->vm_start <=3D addr && vma->vm_end > addr) {
+ 			count_vm_vmacache_event(VMACACHE_FIND_HITS);
  			return vma;
+ 		}
  	}
 =20
  	return NULL;

--Signature=_Tue__29_Apr_2014_14_47_40_+1000_qi0SJln5SAQFGkT3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTXy7wAAoJEMDTa8Ir7ZwVlXYP/0IBe2CCiSqCE1BjbUWIYm9J
lMxs7D7i3i3O6VdlEr+KoNLF0WSHl1/27ilq2HSRDFyh6oLCGmQz1MGcOUS61gpB
3Hemql0sjFmnYGPgV0vznHIDRI2o7i1TvbCHtvFLsHH7DlS7KQCuZNmvmAq2mQlH
PTKt4zjQm3PB6C2iJAlv197SihtEVh/nbrS8/Rchtkqln+JX8d8JK1NDu/u02LTX
oYNmudEAn4dovmGXAXkmlEyPAwRSBaxaOdwe+88n2//eV8UTuJ+o7HJGCVgSvgPK
AGgDe1DPh0EsTHn9Cf09I413WBUNkryCIdk6yhOp8996Misk8gtKXnzvglp0uGk2
Zcxpc39+R80O0JSSMigdcczCRb7vPgWMhENT80QBwu7kIZ87eLmi62RPT7IRitPT
SjtDI7u0qTflbNbW+IodTC1mFOyIsDh5jpn5LjO0i8bxDtf7rftiE3uIDuazEVt0
xIPgVwzMfUHjdA82+0UZUHpReLA61ddG9xDxTJZ9lsFLuTLulqmgwQas0b31dswr
m44kVh+V2fwTFzlhl/PpXypoO5e4SYQBjeotMX2McNag2SVA+GBn/ZQL10ktYyOz
zjbjc40e/R2t83tNjd5mJzbB998yaVEUkcfckKNlFv/LxHhhN5RqzO9yjHL3T/JO
yfwaFBNjgyQ0/qRajltL
=e9s8
-----END PGP SIGNATURE-----

--Signature=_Tue__29_Apr_2014_14_47_40_+1000_qi0SJln5SAQFGkT3--
