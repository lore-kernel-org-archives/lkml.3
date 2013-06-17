Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932258Ab3FQHpg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 03:45:36 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:46142 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754868Ab3FQHpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 03:45:35 -0400
Date: Mon, 17 Jun 2013 17:45:28 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steve Capper <steve.capper@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marc Zyngier <marc.zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: linux-next: manual merge of the arm64-hugepages tree with the arm64
 tree
Message-Id: <20130617174528.fc0381c10f8c5296b4efe776@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Jun_2013_17_45_28_+1000_O4SlmQi/tnc=JyOH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Jun_2013_17_45_28_+1000_O4SlmQi/tnc=JyOH
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Steve,

Today's linux-next merge of the arm64-hugepages tree got conflicts in
arch/arm64/include/asm/pgtable-hwdef.h and
arch/arm64/include/asm/pgtable.h between commit 363116073a26 ("arm64:
KVM: define HYP and Stage-2 translation page flags") from the arm64 tree
and commits 072b1b62a643 ("ARM64: mm: Make PAGE_NONE pages read only and
no-execute") and af07484863e0 ("ARM64: mm: THP support") from the
arm64-hugepages tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

Note that the arm64 tree version of PMD_SECT_USER used a pteval_t where I
would have expected a pmdval_t like the arm64-hugepages tree version.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm64/include/asm/pgtable.h
index 5588e8a,720fc4a..0000000
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@@ -76,13 -76,7 +76,13 @@@ extern pgprot_t pgprot_default
  #define PAGE_KERNEL		_MOD_PROT(pgprot_default, PTE_PXN | PTE_UXN | PTE_DI=
RTY)
  #define PAGE_KERNEL_EXEC	_MOD_PROT(pgprot_default, PTE_UXN | PTE_DIRTY)
 =20
 +#define PAGE_HYP		_MOD_PROT(pgprot_default, PTE_HYP)
 +#define PAGE_HYP_DEVICE		__pgprot(PROT_DEVICE_nGnRE | PTE_HYP)
 +
 +#define PAGE_S2			__pgprot_modify(pgprot_default, PTE_S2_MEMATTR_MASK, PT=
E_S2_MEMATTR(MT_S2_NORMAL) | PTE_S2_RDONLY)
 +#define PAGE_S2_DEVICE		__pgprot(PROT_DEFAULT | PTE_S2_MEMATTR(MT_S2_DEVI=
CE_nGnRE) | PTE_S2_RDWR | PTE_UXN)
 +
- #define __PAGE_NONE		__pgprot(((_PAGE_DEFAULT) & ~PTE_TYPE_MASK) | PTE_PR=
OT_NONE)
+ #define __PAGE_NONE		__pgprot(((_PAGE_DEFAULT) & ~PTE_TYPE_MASK) | PTE_PR=
OT_NONE | PTE_RDONLY | PTE_PXN | PTE_UXN)
  #define __PAGE_SHARED		__pgprot(_PAGE_DEFAULT | PTE_USER | PTE_NG | PTE_P=
XN | PTE_UXN)
  #define __PAGE_SHARED_EXEC	__pgprot(_PAGE_DEFAULT | PTE_USER | PTE_NG | P=
TE_PXN)
  #define __PAGE_COPY		__pgprot(_PAGE_DEFAULT | PTE_USER | PTE_NG | PTE_PXN=
 | PTE_UXN | PTE_RDONLY)

--Signature=_Mon__17_Jun_2013_17_45_28_+1000_O4SlmQi/tnc=JyOH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRvr6YAAoJEECxmPOUX5FECKEQAI3lsxix2vmYti51W09C0Way
n3dkHMgkkox/qbn87UOJJL8yxQlwwphK150mQMv4L12Dgv8HOIfVcUqUvrdm1pUP
9uZ3L5/aYRspGtQKnS1eUhKYHOe91koqbkd9Eocdi5KIOn8s5Rx44VNHpR12p0Fe
pDM0o+OvOrSWFrb9lwtGkysz6Uqg/D3r5CpVhxXHWpVLMmHpLgYjBXqpjDYe9iSO
2pnCDcOJPd7JmUWeYmghK+tBlMAmYv270SwfWpaNnhd2Qq46VIl53zPslfi6naj8
+V9KJ/Y5WNnC/svLPqOJ4BeLa+TkxsJihzrOz6XATCLr3agbpT1ZRm8k/OTohZPt
LHGfowDy1GsrXIOh0N6dXqYaOHbOkPoHX2/f6Gh/htod3VG4WqZKd+7AhmMQMMpF
X7wB3x2v+XZh/A9UFa5B9Xfwyqq/zL/W6DtD/qLxuOSRaeg0+AtrfrZU0zAR1dz5
dzdwQXVgDVJIB6CxYF4ieYWBe6+0CMZaGOSmYK8SrjuE0EHV2091Sbr+KNJ1bqLG
dsQm5aPtFm2xVfKZgGvyGnocV/66BCGHr/ZAt/dq1lEOX8pFcQQFyI21RGJ2puXc
x3jMzmSPM0xAYtUz/xmAxkZqcTcca94gaRwi8fJxH3FrGD4i6n5YSMd8j0XQ/yjo
b3p2ayUW0GX792rtLMBr
=4kqb
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Jun_2013_17_45_28_+1000_O4SlmQi/tnc=JyOH--
