Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751256AbaK0F5a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 00:57:30 -0500
Received: from ozlabs.org ([103.22.144.67]:54944 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783AbaK0F53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 00:57:29 -0500
Date: Thu, 27 Nov 2014 16:57:19 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jason Cooper <jason@lakedaemon.net>, Ralf Baechle <ralf@linux-mips.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Bresticker <abrestic@chromium.org>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>
Subject: linux-next: manual merge of the irqchip tree with the mips tree
Message-ID: <20141127165719.2e5cb4e4@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/ou5qZlUcXra13.aOn7wLLDe"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ou5qZlUcXra13.aOn7wLLDe
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Jason,

Today's linux-next merge of the irqchip tree got a conflict in
drivers/irqchip/Makefile between commit 8a19b8f19429 ("MIPS: Move GIC
to drivers/irqchip/") from the mips tree and commit 5fe3bba3088c
("irqchip: mtk-sysirq: Add sysirq interrupt polarity support") from the
irqchip tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/irqchip/Makefile
index 021833079c91,5761696368f9..000000000000
--- a/drivers/irqchip/Makefile
+++ b/drivers/irqchip/Makefile
@@@ -35,7 -37,7 +37,8 @@@ obj-$(CONFIG_TB10X_IRQC)		+=3D irq-tb10x.
  obj-$(CONFIG_XTENSA)			+=3D irq-xtensa-pic.o
  obj-$(CONFIG_XTENSA_MX)			+=3D irq-xtensa-mx.o
  obj-$(CONFIG_IRQ_CROSSBAR)		+=3D irq-crossbar.o
- obj-$(CONFIG_BRCMSTB_L2_IRQ)		+=3D irq-brcmstb-l2.o \
- 					   irq-bcm7120-l2.o
+ obj-$(CONFIG_BCM7120_L2_IRQ)		+=3D irq-bcm7120-l2.o
+ obj-$(CONFIG_BRCMSTB_L2_IRQ)		+=3D irq-brcmstb-l2.o
  obj-$(CONFIG_KEYSTONE_IRQ)		+=3D irq-keystone.o
 +obj-$(CONFIG_MIPS_GIC)			+=3D irq-mips-gic.o
+ obj-$(CONFIG_ARCH_MEDIATEK)		+=3D irq-mtk-sysirq.o

--Sig_/ou5qZlUcXra13.aOn7wLLDe
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUdr1FAAoJEMDTa8Ir7ZwVCekP/22HEyt2s1yJ0hCTa+RD81lM
cuuvflHlzpcW+QdslQWs1uepbo8U8o3VHK7NI0U2OvWbeIefpgwLln7x9xtveyRR
nlTt6ruNjtUIgY9Fy5bB5+1nkN5WbUtpdEvR9UEjBF5zvDYOUmKuAR/0o+85GCFh
gEdm1diyTAx3sfU7gyhpjpzEwd5zetlm43mpCeKGWT+gExCDdeRP4ZmEDVAt5muh
FvOR/av0gq83ghZHkpPn9f7Sa9RoDDfJGO3YMldfV3+orizFQTA11X5a/uaxt69T
GcNxnBlxirJWuQ418Z6nWUiGJwffHZfTvB5ATETXkFRz/CgxchtA0Q2O1W+u6omm
tOfPjfcIcfIrBob7qH6s6MlVFq5pj9sUGinhVNa8dn1WQsY+XcFgGsZH7UKKX2tQ
cTIsjWPT+I6zVXtRgDvMEWufyfVeCKBoPjAVzlw8P/NTinrtMe/9p8EK4dSkQbHd
kZI0ufH+g5kEv1JJIzRtZm5C+ez8PwJUAdHsJsCe5+XQEg1laLsBrqlnKSBMMKZG
4QeNidgh29pzTKTK+ePZxubNdQt26IBKvi564qec9OLaY3CD+OCDMrdP3t5yBFQj
ylsEvrx0LsnrPJODqWegbGGQdKpRKb3rBTjGHgvm7UgXmcJv/jnl71RXz6Fzwng4
pWjvyTFlUgrdgeW27gO3
=au2s
-----END PGP SIGNATURE-----

--Sig_/ou5qZlUcXra13.aOn7wLLDe--
