Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677AbaDPGGb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 02:06:31 -0400
Received: from ozlabs.org ([103.22.144.67]:41278 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754454AbaDPGG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 02:06:28 -0400
Date: Wed, 16 Apr 2014 16:06:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Laura Abbott <lauraa@codeaurora.org>
Subject: linux-next: build failure after merge of the akpm-current tree
Message-Id: <20140416160617.bd724cb4061f04409546650b@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__16_Apr_2014_16_06_17_+1000_cLnyVbMyJZ4LfquP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__16_Apr_2014_16_06_17_+1000_cLnyVbMyJZ4LfquP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm tree, today's linux-next build (powerpc
ppc44x_defconfig) failed like this:

arch/powerpc/platforms/44x/warp.c: In function 'warp_probe':
arch/powerpc/platforms/44x/warp.c:52:2: error: 'ISA_DMA_THRESHOLD' undeclar=
ed (first use in this function)
arch/powerpc/mm/dma-noncoherent.c: In function '__dma_alloc_coherent':
arch/powerpc/mm/dma-noncoherent.c:159:13: error: 'ISA_DMA_THRESHOLD' undecl=
ared (first use in this function)

Probably caused by commit ff35bd54456e ("lib/scatterlist: make
ARCH_HAS_SG_CHAIN an actual Kconfig") which removed an implicit include
of <asm/dma.h> with the removal of the arch specific scatterlist.h.

I have added the following patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 16 Apr 2014 16:03:01 +1000
Subject: [PATCH] lib/scatterlist: make ARCH_HAS_SG_CHAIN an actual Kconfig =
fix

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/powerpc/mm/dma-noncoherent.c | 1 +
 arch/powerpc/platforms/44x/warp.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/powerpc/mm/dma-noncoherent.c b/arch/powerpc/mm/dma-noncoh=
erent.c
index 7b6c10750179..d85e86aac7fb 100644
--- a/arch/powerpc/mm/dma-noncoherent.c
+++ b/arch/powerpc/mm/dma-noncoherent.c
@@ -33,6 +33,7 @@
 #include <linux/export.h>
=20
 #include <asm/tlbflush.h>
+#include <asm/dma.h>
=20
 #include "mmu_decl.h"
=20
diff --git a/arch/powerpc/platforms/44x/warp.c b/arch/powerpc/platforms/44x=
/warp.c
index 534574a97ec9..3a104284b338 100644
--- a/arch/powerpc/platforms/44x/warp.c
+++ b/arch/powerpc/platforms/44x/warp.c
@@ -25,6 +25,7 @@
 #include <asm/time.h>
 #include <asm/uic.h>
 #include <asm/ppc4xx.h>
+#include <asm/dma.h>
=20
=20
 static __initdata struct of_device_id warp_of_bus[] =3D {
--=20
1.9.2

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__16_Apr_2014_16_06_17_+1000_cLnyVbMyJZ4LfquP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTTh3iAAoJEMDTa8Ir7ZwVY8wP/iKchfiEYPdZHcFkh+rsQdBF
UAAD0uxGpxEPr3Aoq0PRNYkzsROBW11vCvpn1rJdbIjs7RVATC62NU5Qm2HNojAc
1SJQjsmC6ntzHVZAMs+TCibrQxuaLC/PQ0l4Aa/5E4mOKaB+M1IQkwSCDSNpDLii
PcGp9EA5U76gGLaJTMkmuHtOwQcGkO8Dpe3s19OgRbafX/XvvFwJikp9cXldhRaG
0Jh5o08X/LP8w9ZEXuyjVfZxrr1VO9E4jCppDEc2bW1tCMqYTuG4pgVzLfBStB6I
SHS7VWbj3eNpCVbgEgWMDAB7WlCGY/hD47nl8RFyJ6tupmt4AY/aWMwOD2PA24aA
JV3KxWj+d9BoeFVhzJd6VinuZPb9is+LPrWZOtsEZg37UNLfrg3hvE3SciJ5KzX5
dhgJIl7sWbFsURZUkoGGUcvfnnxa12SuBzfl+ovcAhVkP3MN1FucMlBN5QDCyXSM
tGb5CASeTua+fzfQ4c9ewCt2FfB2fS4CzuVXqZEnx2d/4JkyzRh3TZwSXRr61SnP
5F7x85gu2qGbsRbwVBbQLicW2i7Kofg7yJefcQpjBwLDyYIPPMnIuKoYb1CS8bi/
vdURMBGZzE4MbatmZioG5Ch6Vo05dT19PFPsEzUbfe1zGLOxUMgNwAK9o44NSHfa
nVMF1/dKO9GHoFTB5mR9
=VR2e
-----END PGP SIGNATURE-----

--Signature=_Wed__16_Apr_2014_16_06_17_+1000_cLnyVbMyJZ4LfquP--
