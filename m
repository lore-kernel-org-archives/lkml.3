Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbaFPB5c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 21:57:32 -0400
Received: from ozlabs.org ([103.22.144.67]:48274 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752625AbaFPB51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 21:57:27 -0400
Date: Mon, 16 Jun 2014 11:57:25 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: linux-next: build warning after merge of the akpm-current tree
Message-ID: <20140616115725.164966a2@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/MiaEPkThO/DqMnGG6zBEcAL"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/MiaEPkThO/DqMnGG6zBEcAL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm-current tree, today's linux-next build (powerpc
ppc64_defconfig) produced this warning:

In file included from arch/powerpc/include/asm/mmu-hash64.h:23:0,
                 from arch/powerpc/include/asm/mmu.h:197,
                 from arch/powerpc/include/asm/lppaca.h:36,
                 from arch/powerpc/include/asm/paca.h:20,
                 from arch/powerpc/include/asm/hw_irq.h:41,
                 from arch/powerpc/include/asm/irqflags.h:11,
                 from include/linux/irqflags.h:15,
                 from include/linux/spinlock.h:53,
                 from include/linux/mmzone.h:7,
                 from include/linux/gfp.h:5,
                 from include/linux/mm.h:9,
                 from include/linux/mman.h:4,
                 from mm/madvise.c:8:
mm/madvise.c: In function 'swapin_walk_pte_entry':
arch/powerpc/include/asm/pgtable-ppc64.h:183:3: warning: statement with no =
effect [-Wunused-value]
   (((pte_t *) pmd_page_vaddr(*(dir))) + (((addr) >> PAGE_SHIFT) & (PTRS_PE=
R_PTE - 1)))
   ^
arch/powerpc/include/asm/pgtable-ppc64.h:185:34: note: in expansion of macr=
o 'pte_offset_kernel'
 #define pte_offset_map(dir,addr) pte_offset_kernel((dir), (addr))
                                  ^
mm/madvise.c:161:2: note: in expansion of macro 'pte_offset_map'
  pte_offset_map(walk->pmd, start & PMD_MASK);
  ^
mm/madvise.c:145:9: warning: unused variable 'orig_pte' [-Wunused-variable]
  pte_t *orig_pte =3D pte - ((start & (PMD_SIZE - 1)) >> PAGE_SHIFT);
         ^

Introduced by commit 17336ae3d58a ("madvise: cleanup swapin_walk_pmd_entry(=
)")
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/MiaEPkThO/DqMnGG6zBEcAL
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTnk8FAAoJEMDTa8Ir7ZwVil0P/R4L3H/B+iGCwJ29teFfm8jo
JWqkb2/65ORveY3Lv6lYzpS82bCcWixgTNe01iwfecsaD9iOXDNFcGErEBWyD0QQ
2u+v1y/voN0ftKKt/LxQiXZLcuUlXT1DLEK3JMVko5itPYW6X8HxgqJC/6SnkMXc
HwmsLtECyuMCMgDmGQzy5Me3F8bbolsFYC8IAvi/VF+YeT2Z0CgozpZDTxtAYD5x
zO8cbMevC4D5IfDECa2+zpTHK1nsel7UEPa1fTOT3VHfFhzkkWpl/1pZursiSojs
7nTznWEsKAMBYMqAjvvXe6JtAdmIPBPXfQtmWwubLVXhqAbVr4jTJN2nHCys3DBE
H4BK9PKHUh0wp32yXgCse2a5tg7YhhSQQEV12dyHE9lG7y+0C5mlvcvTiGTZpeY/
F1WF+m5AOagi10HA/B0ekwEn6dZf3MkkueSalQXmaY+6XzhqhwJf8gnVtARj6cR6
EYRc4j2rp93yldVW610fXLuAd/JJX3q0IVYqUPLzbYTokX2v4olRSAswShwm7xrM
uGk+sf+DOnKLHubbyjBVZDst7AO6vybnKWts92EnZ259u8o0v7gwj0xQPs1AJscF
STXgFUc5xU1I7mh8cbL/fsfGP8PLMajxnqtR1ohkKNApLv60pbWQH0JvJaDVHYwx
47h4cePc11UU/kfiq2/6
=Te95
-----END PGP SIGNATURE-----

--Sig_/MiaEPkThO/DqMnGG6zBEcAL--
