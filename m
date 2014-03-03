Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506AbaCCGDv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 01:03:51 -0500
Received: from ozlabs.org ([203.10.76.45]:45216 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800AbaCCGDt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 01:03:49 -0500
Date: Mon, 3 Mar 2014 17:03:35 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Liviu Dudau <Liviu.Dudau@arm.com>
Subject: linux-next: manual merge of the tip tree with the pci tree
Message-Id: <20140303170335.7a4dd42c6e4f4b9034144a25@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__3_Mar_2014_17_03_35_+1100_fzD2jzNzJAjc5RnB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__3_Mar_2014_17_03_35_+1100_fzD2jzNzJAjc5RnB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
drivers/pci/Makefile between commit 39656f29f665 ("PCI: Cleanup per-arch
list of object files") from the pci tree and commit c5f9ee3d665a ("x86,
platforms: Remove SGI Visual Workstation") from the tip tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/pci/Makefile
index e2501ac6fe84,9d5ee4dcee7d..000000000000
--- a/drivers/pci/Makefile
+++ b/drivers/pci/Makefile
@@@ -33,15 -33,20 +33,14 @@@ obj-$(CONFIG_PCI_IOV) +=3D iov.
  #
  # Some architectures use the generic PCI setup functions
  #
 -obj-$(CONFIG_X86) +=3D setup-bus.o
 -obj-$(CONFIG_ALPHA) +=3D setup-bus.o setup-irq.o
 -obj-$(CONFIG_ARM) +=3D setup-bus.o setup-irq.o
 -obj-$(CONFIG_UNICORE32) +=3D setup-bus.o setup-irq.o
 -obj-$(CONFIG_PARISC) +=3D setup-bus.o
 -obj-$(CONFIG_SUPERH) +=3D setup-bus.o setup-irq.o
 -obj-$(CONFIG_PPC) +=3D setup-bus.o
 -obj-$(CONFIG_FRV) +=3D setup-bus.o
 -obj-$(CONFIG_MIPS) +=3D setup-bus.o setup-irq.o
 -obj-$(CONFIG_MN10300) +=3D setup-bus.o
 -obj-$(CONFIG_MICROBLAZE) +=3D setup-bus.o
 -obj-$(CONFIG_TILE) +=3D setup-bus.o setup-irq.o
 -obj-$(CONFIG_SPARC_LEON) +=3D setup-bus.o setup-irq.o
 -obj-$(CONFIG_M68K) +=3D setup-bus.o setup-irq.o
 +obj-$(CONFIG_ALPHA) +=3D setup-irq.o
 +obj-$(CONFIG_ARM) +=3D setup-irq.o
 +obj-$(CONFIG_UNICORE32) +=3D setup-irq.o
 +obj-$(CONFIG_SUPERH) +=3D setup-irq.o
 +obj-$(CONFIG_MIPS) +=3D setup-irq.o
- obj-$(CONFIG_X86_VISWS) +=3D setup-irq.o
 +obj-$(CONFIG_TILE) +=3D setup-irq.o
 +obj-$(CONFIG_SPARC_LEON) +=3D setup-irq.o
 +obj-$(CONFIG_M68K) +=3D setup-irq.o
 =20
  #
  # ACPI Related PCI FW Functions

--Signature=_Mon__3_Mar_2014_17_03_35_+1100_fzD2jzNzJAjc5RnB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTFBs8AAoJEMDTa8Ir7ZwVfzUP+gIRRWi/ri2zpguQEE5NeJwe
kyc/9xLv0kqMqP4MfBZsKOwS5lKHfURVH7kBCK5zuWAz9OZrEvz/fk5wOpSCx+Lv
Gy78ERMW7eUJmXVCWW8zVs3DeMxuwypmWaxjlnte0X/ALN6Wg51GKqK0Hdfw5Hmb
j/0qzbNRVrBd60YAbzN5tJ40ZdMnN/DkpKbRoeonZ1EmD1v1x3zjwIRQJg8IqNcK
SLwy+KBZ41iOF+bQDo+YCd0U2YUwT9guVk1V2CkgDW0SPAf4sMFt7tc2Dm8va/BA
hwPtxYmalrYkhGdISkz0M7j+g/NDcEqBNe68pGs+DVgO22ItXf3yJWz66WaIHslf
KfwHdjOidsmYkO4wm5yXrI2BokeeoWbdcl9i3lqBOVGgqJkO+7hOjSV5t2MxMGNs
VDzJ0wNfQIfOH1tn2kHGv5C1W0s7UUsApzsFk3psbAZBgqomSGIuawHcg+wPe2Dy
dn+SqyF7MBGVjT9uUJ7roUFat369l2jdr98VVnXGA3FuHwhN9gIVzo6gDwp+I/oh
6dg2D4ld2lceUALQNZdIbR+V+zMmMu8bsL3WENhaemWYb+N3Y+EDaVBC61I7tueg
GSvdGz9IZ309tTPBWLv3CTBrZhgsWwhilP53Xt8ZCVntb662f1jj+HjcPmximVxs
ZZXGqrw2fEunq38suM6Q
=F/Mv
-----END PGP SIGNATURE-----

--Signature=_Mon__3_Mar_2014_17_03_35_+1100_fzD2jzNzJAjc5RnB--
