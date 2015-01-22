Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbbAVFHW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 00:07:22 -0500
Received: from ozlabs.org ([103.22.144.67]:54102 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013AbbAVFHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 00:07:06 -0500
Date: Thu, 22 Jan 2015 16:07:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Christoffer Dall <cdall@cs.columbia.edu>,
        Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Wei Huang <wei@redhat.com>
Subject: linux-next: manual merge of the kvm-arm tree with the arm64 tree
Message-ID: <20150122160704.5ad5aeb9@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/g0g9WOLTgf6uAEXazqmdYru"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/g0g9WOLTgf6uAEXazqmdYru
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm-arm tree got a conflict in
arch/arm64/include/asm/kvm_arm.h between commit 6e53031ed840 ("arm64:
kvm: remove ESR_EL2_* macros") from the arm64 tree and commit
0d97f8848104 ("arm/arm64: KVM: add tracing support for arm64 exit
handler") from the kvm-arm tree.

I fixed it up (see below, but this probably requires more work) and can
carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm64/include/asm/kvm_arm.h
index 94674eb7e7bb,3da2d3acec0b..000000000000
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@@ -192,4 -217,46 +192,6 @@@
  /* Hyp Prefetch Fault Address Register (HPFAR/HDFAR) */
  #define HPFAR_MASK	(~UL(0xf))
 =20
 -#define ESR_EL2_EC_UNKNOWN	(0x00)
 -#define ESR_EL2_EC_WFI		(0x01)
 -#define ESR_EL2_EC_CP15_32	(0x03)
 -#define ESR_EL2_EC_CP15_64	(0x04)
 -#define ESR_EL2_EC_CP14_MR	(0x05)
 -#define ESR_EL2_EC_CP14_LS	(0x06)
 -#define ESR_EL2_EC_FP_ASIMD	(0x07)
 -#define ESR_EL2_EC_CP10_ID	(0x08)
 -#define ESR_EL2_EC_CP14_64	(0x0C)
 -#define ESR_EL2_EC_ILL_ISS	(0x0E)
 -#define ESR_EL2_EC_SVC32	(0x11)
 -#define ESR_EL2_EC_HVC32	(0x12)
 -#define ESR_EL2_EC_SMC32	(0x13)
 -#define ESR_EL2_EC_SVC64	(0x15)
 -#define ESR_EL2_EC_HVC64	(0x16)
 -#define ESR_EL2_EC_SMC64	(0x17)
 -#define ESR_EL2_EC_SYS64	(0x18)
 -#define ESR_EL2_EC_IABT		(0x20)
 -#define ESR_EL2_EC_IABT_HYP	(0x21)
 -#define ESR_EL2_EC_PC_ALIGN	(0x22)
 -#define ESR_EL2_EC_DABT		(0x24)
 -#define ESR_EL2_EC_DABT_HYP	(0x25)
 -#define ESR_EL2_EC_SP_ALIGN	(0x26)
 -#define ESR_EL2_EC_FP_EXC32	(0x28)
 -#define ESR_EL2_EC_FP_EXC64	(0x2C)
 -#define ESR_EL2_EC_SERROR	(0x2F)
 -#define ESR_EL2_EC_BREAKPT	(0x30)
 -#define ESR_EL2_EC_BREAKPT_HYP	(0x31)
 -#define ESR_EL2_EC_SOFTSTP	(0x32)
 -#define ESR_EL2_EC_SOFTSTP_HYP	(0x33)
 -#define ESR_EL2_EC_WATCHPT	(0x34)
 -#define ESR_EL2_EC_WATCHPT_HYP	(0x35)
 -#define ESR_EL2_EC_BKPT32	(0x38)
 -#define ESR_EL2_EC_VECTOR32	(0x3A)
 -#define ESR_EL2_EC_BRK64	(0x3C)
 -
 -#define ESR_EL2_EC_xABT_xFSR_EXTABT	0x10
 -
 -#define ESR_EL2_EC_WFI_ISS_WFE	(1 << 0)
 -
+ #define ESR_EL2_HVC_IMM_MASK	((1UL << 16) - 1)
+=20
  #endif /* __ARM64_KVM_ARM_H__ */

--Sig_/g0g9WOLTgf6uAEXazqmdYru
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUwIV4AAoJEMDTa8Ir7ZwVUTgQAIEcbqbKDUdgGkrfgUyjIl/4
MM1aJbDBglSGkiUTUFI0GIa5voAC+JPDwWLj7mUCgB7VURRVSSD9dkackVIUgqvB
2l0EOtK5003FPcQVpowvpfcF/F1WZmxnp+kBYSVnZnaEJW2EpCsnH0/stPFMUEmg
blxwTnxdFXVYofeUAod62D+NL68PdL3SHpK7nCMnGLNTIX67dMbuATD8JpOxcGAD
9tu1Bpq1nKAoWjHZ2RaI5V+Vd7A5ppDspHpKlwcJfwz48uMxp8nAwlcKAF/Wy0on
8lUwxogH5YIowpha+XcuxWp5/UiXeeZZIpgBOY6l80xDoPs5xZ7ujgLD659rNsJ4
HjHtD69QCF+yC5PifR/8JsSZmKkTlzftanSLE2AHHYNsqfo63rKrWbDdKhlrlnrS
3AMueLwltj9Y0WBX7xqk2CRKTh6zPzfOBhnZNCG10kTrn5UIQJc2+x1ZMUU1HIgh
Hu8u1TjfjbYJDXibxoe1iGYEPhCqdvGAHgPwDhKPZm77rFCeirwyYx8fjXDh7EJO
XA3A2y0v3XHdaPH267HWpI4vgruB74YSqC9dGaWR4qcG1wtqTHxhGIWd+cngKCzo
7s/Qdaf2tk/T+5u48QezxtXeNxYf9jF5LC62hMjhM0RrTmrxo21swHebUC4Z1sB6
lj0u0IH5J32722Q59ZLy
=Yxbq
-----END PGP SIGNATURE-----

--Sig_/g0g9WOLTgf6uAEXazqmdYru--
