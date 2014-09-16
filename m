Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040AbaIPGqX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 02:46:23 -0400
Received: from ozlabs.org ([103.22.144.67]:33584 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752158AbaIPGqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 02:46:22 -0400
Date: Tue, 16 Sep 2014 16:46:07 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Behan Webster <behanw@converseincode.com>,
        <llvmlinux@lists.linuxfoundation.org>, Michal Marek <mmarek@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: linux-next: manual merge of the llvmlinux tree with the kbuild tree
Message-ID: <20140916164607.3627ee85@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/B32aST+ZilUJe+8Ig/cI_LE"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/B32aST+ZilUJe+8Ig/cI_LE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the llvmlinux tree got a conflict in
Makefile between commit 19a3cc83353e ("Kbuild, lto: Add Link Time
Optimization support v3") from the kbuild tree and commit 6d9203642de6
("kbuild, LLVMLinux: Add better clang cross build support") from the
llvmlinux tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc Makefile
index 6b5e010d91e2,aa642d244f19..000000000000
--- a/Makefile
+++ b/Makefile
@@@ -360,14 -360,18 +360,23 @@@ include $(srctree)/scripts/Kbuild.inclu
  # Make variables (CC, etc...)
  AS		=3D $(CROSS_COMPILE)as
  LD		=3D $(CROSS_COMPILE)ld
 +LDFINAL	=3D $(LD)
+ ifeq ($(COMPILER),clang)
+ ifneq ($(CROSS_COMPILE),)
+ CC		+=3D -target $(CROSS_COMPILE:%-=3D%)
+ endif
+ ifneq ($(GCC_TOOLCHAIN),)
+ CC		+=3D -gcc-toolchain $(GCC_TOOLCHAIN)
+ endif
+ else
  CC		=3D $(CROSS_COMPILE)gcc
+ endif
  CPP		=3D $(CC) -E
 +ifdef CONFIG_LTO
 +AR		=3D $(CROSS_COMPILE)gcc-ar
 +else
  AR		=3D $(CROSS_COMPILE)ar
 +endif
  NM		=3D $(CROSS_COMPILE)nm
  STRIP		=3D $(CROSS_COMPILE)strip
  OBJCOPY		=3D $(CROSS_COMPILE)objcopy

--Sig_/B32aST+ZilUJe+8Ig/cI_LE
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUF9y5AAoJEMDTa8Ir7ZwVq5gQAIe9ZOLXuy9Ug6qw2AZcSMwX
xee+sDIY9vDit3swE0zbrJzDdWVtejuh0jV9pcTEo7p5pQnvItoGfINDeTN83DhH
ULgi9jkHGM+92LXfSpbsGPbORQBzP2JNlKsf+IeNH4Qr1q8bqF4i4kS+1Jk2elFd
WSEIfU31l+m1DGxYViRWQiR33yz10cmvxvLogzQQtpiX+87MvN4wlejCh0+OdwFg
Ss8IEKg/xUSKjDVWOvDLsnqJsn84Od1I3zuL1P+L1spIxy8vD1xiisbqR/U+ukfO
urP+CKc8gCmaHxshgWoSHbUQrZuKenfquZui+hOnu0uqMDfCQXtF94KPZ/xrDirx
JkSRiEk5P8hvEZXmk1L/SWJ0gYXIMHkJYJYkT0rZVQS/8Vduezw8trc+n5/du3yt
I3+h5tMCTu+8kq+ptEjBQ4cCSxXP/1SGtP2v/1+CKHOeCjgCWN1gimmVwcXNhwGW
BT4XoL3lET15wTnT9V6nCw81SB0gRm8rICLblPEKSmyItuTpb4xpwV3sHs4qbloI
XcjOWCAl058VyHDbloCmzCsNAKlGvJ2ezWt0POc+9e0rW+nblWIigqNowMK/BpFA
/HN5JA+/7B9tCRtaDEHRPrjc+OoZ4xB95azdZSY0OAr6OYsqksxqf3lkyO0hk1sY
ZlaQhhg1xguCK3yw73Z/
=Nsi2
-----END PGP SIGNATURE-----

--Sig_/B32aST+ZilUJe+8Ig/cI_LE--
