Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355AbaLWC0Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 21:26:16 -0500
Received: from ozlabs.org ([103.22.144.67]:32968 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753695AbaLWC0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 21:26:14 -0500
Date: Tue, 23 Dec 2014 13:26:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>
Cc: Will Deacon <will.deacon@arm.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Xen Devel <Xen-devel@lists.xensource.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Vrabel <david.vrabel@citrix.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: linux-next: missing merge fix patch for the merge of the xen-tip
 tree with the arm-soc tree
Message-ID: <20141223132605.02d81e01@canb.auug.org.au>
In-Reply-To: <20141208103328.GE27367@arm.com>
References: <20141208184908.27bfd605@canb.auug.org.au>
	<20141208103328.GE27367@arm.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/QYtZIu3XwRWMpWpEXCkyZOj"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/QYtZIu3XwRWMpWpEXCkyZOj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Linus,

I have been carrying this merge fix patch for some time that is now
needed in your tree:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 8 Dec 2014 18:46:59 +1100
Subject: [PATCH] arm: introduce is_device_dma_coherent merge fix

The merge of the (linux-next) xen-tip tree got a conflict in
arch/arm/include/asm/dma-mapping.h between commits a3a60f81ee6f
("dma-mapping: replace set_arch_dma_coherent_ops with
arch_setup_dma_ops") and 4bb25789ed28 ("arm: dma-mapping: plumb our
iommu mapping ops into arch_setup_dma_ops") from the arm-soc tree and
commit 3d5391ac6f5e ("arm: introduce is_device_dma_coherent") from the
xen-tip tree.  It was fixed up, but also required this additional fix.

"Looks good to me"-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/arm/mm/dma-mapping.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 09645f00bd17..43064cbe58f9 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -2058,6 +2058,7 @@ void arch_setup_dma_ops(struct device *dev, u64 dma_b=
ase, u64 size,
 	else
 		dma_ops =3D arm_get_dma_map_ops(coherent);
=20
+	dev->archdata.dma_coherent =3D coherent;
 	set_dma_ops(dev, dma_ops);
 }
=20
--=20
2.1.3

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/QYtZIu3XwRWMpWpEXCkyZOj
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUmNLDAAoJEMDTa8Ir7ZwVBMkP/jNMLxNBOEL1OZAPi0U3azhT
SQS4SMTBhGIsW2FqDLGn4Wj1mDXvMB5rG0OQDZi++wE3x8mIQrbKTsmTym3GnNFU
273G3jM9/V7YFMo2b+iTGDA0xZxMtGBI7EqhXd+GH54qzQiT/U803/ejsgIWDzBK
ZwoBDEtoi9zU7M81h8mrpYS9XDJByH6gjiiB7kDDFwJxhPtIsi6TpUagtf6lY/Fj
GrY2neIWlIDClx+Fx0gpmiy3XIA1PL2xxcXgw70fc6oZSO6upDAR+9La0IdItiKY
QyLBJHhTT+WM8OqBbnz7oyrw2SWC1Y4HXdrr26EqmUuNhsGotbFG/XG9nwuTfUpl
0yU86iQCm7ov79xpQQjVmV3u1eN0620cXbSC4xEFQHeSnhuO1QLmWVsVgMHkJ53q
yD/r35sJy4r/VAH6a/B5cnEW14FJ+n7mec14dSohxRbDwkNbXn//h9NTuhybESQF
60l4dj0kRhY64LR4Klv0zj8omDe24mMrbbg8p8Gp1/PLQhidHS1ICXgeDZpGXcup
N2Mzzc/CORQa4GPQxNiO49KfEWoLO76YPNv/Vf4waIT618HNkpCCUlrU+7cen3JB
GcVhdo6iC4OV94Vp6boOdQRUGYbQUQL2ftb7PzgXI7nWAzPMCIYIYOOnPmIuCVTC
idW5VOEzpw6T+eM4DjYz
=+uGw
-----END PGP SIGNATURE-----

--Sig_/QYtZIu3XwRWMpWpEXCkyZOj--
