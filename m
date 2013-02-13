Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601Ab3BMHSl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 02:18:41 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:33415 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811Ab3BMHSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 02:18:40 -0500
Date: Wed, 13 Feb 2013 18:18:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Hogan <james.hogan@imgtec.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: linux-next: manual merge of the arm-soc tree with the metag tree
Message-Id: <20130213181829.d8b9244c04b2eeb0e09ee5df@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__13_Feb_2013_18_18_29_+1100_F+=376YKs2iol0an"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__13_Feb_2013_18_18_29_+1100_F+=376YKs2iol0an
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
drivers/irqchip/Makefile between commit 270de53f851b ("metag: Internal
and external irqchips") from the metag tree and commit a900e5d99718
("ARM: exynos: move exynos4210-combiner to drivers/irqchip") from the
arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/irqchip/Makefile
index ff02f6b,e65fbf2..0000000
--- a/drivers/irqchip/Makefile
+++ b/drivers/irqchip/Makefile
@@@ -1,6 -1,9 +1,11 @@@
+ obj-$(CONFIG_IRQCHIP)			+=3D irqchip.o
+=20
  obj-$(CONFIG_ARCH_BCM2835)		+=3D irq-bcm2835.o
 +obj-$(CONFIG_METAG)			+=3D irq-metag-ext.o
 +obj-$(CONFIG_METAG_PERFCOUNTER_IRQS)	+=3D irq-metag.o
+ obj-$(CONFIG_ARCH_EXYNOS)		+=3D exynos-combiner.o
  obj-$(CONFIG_ARCH_SUNXI)		+=3D irq-sunxi.o
- obj-$(CONFIG_VERSATILE_FPGA_IRQ)	+=3D irq-versatile-fpga.o
  obj-$(CONFIG_ARCH_SPEAR3XX)		+=3D spear-shirq.o
+ obj-$(CONFIG_ARM_GIC)			+=3D irq-gic.o
+ obj-$(CONFIG_ARM_VIC)			+=3D irq-vic.o
+ obj-$(CONFIG_VERSATILE_FPGA_IRQ)	+=3D irq-versatile-fpga.o

--Signature=_Wed__13_Feb_2013_18_18_29_+1100_F+=376YKs2iol0an
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRGz5FAAoJEECxmPOUX5FEI2YP/jJh4KdRABXCRI0bAybIqNNB
b66SmQkte9JY3AbPxadoWvouQ6KZE2If05pN7HxKHm5Y6TxyusIoZC/yL+dumAxY
PkMLEJHr5AEewt7iQlTShunbVXsleF7ls1L9vQ1qnfUrxm7MhwWYridlX+yaLccm
OKPtintt529w4sSBnJFjQFoO97nVAD1oceLcGmVWo3nkG1u0W+UiN/CiJaGCoHiY
6W6LahDuf2DHucA/oD14tnMkYRR3BborJWRL0k+DD5hxgJCEuwYCiXn8XteZjoiF
XzZ5e6Cep/xAs7LJ5qeX5upRvMFlpvve08mZLUULwjTAS+nawWC67uwq9Ct6anwb
g6FM08NLFwl5VZ49TglYHOduISVCiHRxtYxcl+05oRhQysJasItdYfTw77yln+ec
17k8DLjWLf16POFByoTppKxYVfri9itgQtsXZWrM7Edx7Qno1cLR0WSdcxRgaWhz
fCXOoJ6+zrPN479nzUv/wkgr8F+iUT36EJxBTMwV/KnrYgP0RVxwc9zT4SgrnDKl
yIilgmLe+1ueV7AVftwLulZ0DDOUpUg+5X4ay1jKxweuM9kTIwinf0YpCKm5aLIA
bOWPyXJvnYmT0r0Z+3y/ZQ5iGGv/mJrRQH2xR/92Z3of5MhSmQyBJWoheqHZ7X5K
kvjYfifB0kAB3LHlESe9
=I2j4
-----END PGP SIGNATURE-----

--Signature=_Wed__13_Feb_2013_18_18_29_+1100_F+=376YKs2iol0an--
