Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561AbaIZGp3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 02:45:29 -0400
Received: from ozlabs.org ([103.22.144.67]:43406 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753015AbaIZGp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 02:45:26 -0400
Date: Fri, 26 Sep 2014 16:45:19 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Josh Triplett <josh@joshtriplett.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Fleming <matt.fleming@intel.com>
Subject: linux-next: manual merge of the tiny tree with the tip tree
Message-ID: <20140926164519.49a0f395@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/vIebW7odEsTsFxNiV_QsVfw"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/vIebW7odEsTsFxNiV_QsVfw
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Josh,

Today's linux-next merge of the tiny tree got a conflict in
arch/x86/boot/compressed/Makefile between commit 84be880560fb ("Revert
"efi/x86: efistub: Move shared dependencies to <asm/efi.h>"") from the
tip tree and commit 9a1cb47112ef ("x86, boot: Use the usual -y -n
mechanism for objects in vmlinux") from the tiny tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/boot/compressed/Makefile
index 0fcd9133790c,20db5b3609de..000000000000
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@@ -32,11 -35,10 +35,9 @@@ vmlinux-objs-$(CONFIG_RANDOMIZE_BASE) +
 =20
  $(obj)/eboot.o: KBUILD_CFLAGS +=3D -fshort-wchar -mno-red-zone
 =20
- ifeq ($(CONFIG_EFI_STUB), y)
- 	VMLINUX_OBJS +=3D $(obj)/eboot.o $(obj)/efi_stub_$(BITS).o
- endif
 -vmlinux-objs-$(CONFIG_EFI_STUB) +=3D $(obj)/eboot.o $(obj)/efi_stub_$(BIT=
S).o \
 -	$(objtree)/drivers/firmware/efi/libstub/lib.a
++vmlinux-objs-$(CONFIG_EFI_STUB) +=3D $(obj)/eboot.o $(obj)/efi_stub_$(BIT=
S).o
 =20
- $(obj)/vmlinux: $(VMLINUX_OBJS) FORCE
+ $(obj)/vmlinux: $(vmlinux-objs-y) FORCE
  	$(call if_changed,ld)
  	@:
 =20

--Sig_/vIebW7odEsTsFxNiV_QsVfw
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUJQuEAAoJEMDTa8Ir7ZwV0zIP+gKjTU6S/cAuKWYmI4TtiGNu
RzAmBtzYe8VKQ4H8AOaJOrtMwYbqw+XvYAv/O8unxnh04XIzLJpEuD21gTXSBXsy
ky1t/7XmLHMCARrVNmQSu8Ot4mVim7/PCeaAK+QE3qgBirxqDSXkrQ3gezUyzZvb
bUqJuU6FnENvGiZL2xo6gUHLScTS4sSgFFjtzAMOtHys0cjWzvWOzRiqf99+zenU
TASiL7v1fs8gnSd0bKPYBL6wlsRWmbG8/qegIAE19XzPpGw8uBBH1EqT6X8fgdXr
QfRL2FLIDNpJu+nxidXgQt9lwC8H5mWizTSSSLdItbXgU3DTMitslLBP0qjPr65f
RtCTCK+ppigggsBOYe1qdQGq7Cyc0gmehGO7wZg3KY4Nr+Bj/31ESuxFu2eUlupA
aucCOee/Mx51x4Xr4kELcQxP7bSzWPHFHsOtjUbIManKf9yNBgAQhXHsOSTca9tN
W43JGYqFrF2RZb7DEJfMajTLCHIovnUEwEq2EY2dC3ar0CTvaDRmKLS2RNYaGs1N
LoQINpLiGLrjq/MkMl4Cq46M1y1kBFrWh3dG+a2OMGbr+392IklyA1Z4v2kBdavi
7bK4JdFzqDVgc2Us6ZbjQTPV2etDy9woNWsxNxLvLQfJ2UUQ7+ncvxmJ1MpUqMf/
UF9w/gYoz674Zd676Dt4
=YjZA
-----END PGP SIGNATURE-----

--Sig_/vIebW7odEsTsFxNiV_QsVfw--
