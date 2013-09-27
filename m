Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab3I0IsT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 04:48:19 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:44993 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab3I0IsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 04:48:14 -0400
Date: Fri, 27 Sep 2013 18:48:04 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sudeep Dutt <sudeep.dutt@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Caz Yokoyama <Caz.Yokoyama@intel.com>,
        Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>,
        Nikhil Rao <nikhil.rao@intel.com>,
        Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>
Subject: linux-next: build failure after merge of the final tree (char-misc
 tree related)
Message-Id: <20130927184804.ddb460377bcd3fb35f8b41d2@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.21; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__27_Sep_2013_18_48_04_+1000_Lk4J1=YKKSJmhhQf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__27_Sep_2013_18_48_04_+1000_Lk4J1=YKKSJmhhQf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/misc/mic/card/mic_x100.c: In function 'mic_init':
drivers/misc/mic/card/mic_x100.c:215:9: error: implicit declaration of func=
tion 'cpu_data' [-Werror=3Dimplicit-function-declaration]
  struct cpuinfo_x86 *c =3D &cpu_data(0);
         ^
drivers/misc/mic/card/mic_x100.c:215:26: error: lvalue required as unary '&=
' operand
  struct cpuinfo_x86 *c =3D &cpu_data(0);
                          ^
drivers/misc/mic/card/mic_x100.c:217:9: error: dereferencing pointer to inc=
omplete type
  if (!(c->x86 =3D=3D 11 && c->x86_model =3D=3D 1)) {
         ^
drivers/misc/mic/card/mic_x100.c:217:25: error: dereferencing pointer to in=
complete type
  if (!(c->x86 =3D=3D 11 && c->x86_model =3D=3D 1)) {
                         ^
In file included from drivers/misc/mic/host/mic_device.h:27:0,
                 from drivers/misc/mic/host/mic_boot.c:26:
drivers/misc/mic/host/mic_intr.h:134:58: warning: 'struct pci_dev' declared=
 inside parameter list [enabled by default]
 int mic_setup_interrupts(struct mic_device *mdev, struct pci_dev *pdev);
                                                          ^
drivers/misc/mic/host/mic_intr.h:134:58: warning: its scope is only this de=
finition or declaration, which is probably not what you want [enabled by de=
fault]
drivers/misc/mic/host/mic_intr.h:135:58: warning: 'struct pci_dev' declared=
 inside parameter list [enabled by default]
 void mic_free_interrupts(struct mic_device *mdev, struct pci_dev *pdev);
                                                          ^
In file included from drivers/misc/mic/host/mic_boot.c:26:0:
drivers/misc/mic/host/mic_device.h: In function 'mic_mmio_read':
drivers/misc/mic/host/mic_device.h:164:2: error: implicit declaration of fu=
nction 'ioread32' [-Werror=3Dimplicit-function-declaration]
  return ioread32(mw->va + offset);
  ^
drivers/misc/mic/host/mic_device.h: In function 'mic_mmio_write':
drivers/misc/mic/host/mic_device.h:178:2: error: implicit declaration of fu=
nction 'iowrite32' [-Werror=3Dimplicit-function-declaration]
  iowrite32(val, mw->va + offset);
  ^
In file included from arch/powerpc/include/asm/io.h:37:0,
                 from arch/powerpc/include/asm/dma.h:21,
                 from arch/powerpc/include/asm/scatterlist.h:12,
                 from include/linux/scatterlist.h:9,
                 from include/linux/virtio.h:6,
                 from include/linux/virtio_config.h:6,
                 from drivers/misc/mic/host/mic_virtio.h:24,
                 from drivers/misc/mic/host/mic_boot.c:28:
include/asm-generic/iomap.h: At top level:
include/asm-generic/iomap.h:31:21: error: conflicting types for 'ioread32'
 extern unsigned int ioread32(void __iomem *);
                     ^
In file included from drivers/misc/mic/host/mic_boot.c:26:0:
drivers/misc/mic/host/mic_device.h:164:9: note: previous implicit declarati=
on of 'ioread32' was here
  return ioread32(mw->va + offset);
         ^
In file included from arch/powerpc/include/asm/io.h:37:0,
                 from arch/powerpc/include/asm/dma.h:21,
                 from arch/powerpc/include/asm/scatterlist.h:12,
                 from include/linux/scatterlist.h:9,
                 from include/linux/virtio.h:6,
                 from include/linux/virtio_config.h:6,
                 from drivers/misc/mic/host/mic_virtio.h:24,
                 from drivers/misc/mic/host/mic_boot.c:28:
include/asm-generic/iomap.h:37:13: warning: conflicting types for 'iowrite3=
2' [enabled by default]
 extern void iowrite32(u32, void __iomem *);
             ^
In file included from drivers/misc/mic/host/mic_boot.c:26:0:
drivers/misc/mic/host/mic_device.h:178:2: note: previous implicit declarati=
on of 'iowrite32' was here
  iowrite32(val, mw->va + offset);
  ^
drivers/misc/mic/host/mic_x100.c: In function 'mic_x100_load_ramdisk':
drivers/misc/mic/host/mic_x100.c:402:49: error: dereferencing pointer to in=
complete type
  iowrite32(cpu_to_le32(mdev->bootaddr << 1), &bp->hdr.ramdisk_image);
                                                 ^
drivers/misc/mic/host/mic_x100.c:403:38: error: dereferencing pointer to in=
complete type
  iowrite32(cpu_to_le32(fw->size), &bp->hdr.ramdisk_size);
                                      ^
drivers/misc/mic/host/mic_debugfs.c: In function 'mic_log_buf_show':
drivers/misc/mic/host/mic_debugfs.c:55:51: error: '__START_KERNEL_map' unde=
clared (first use in this function)
  aper_offset =3D (unsigned long)mdev->log_buf_len - __START_KERNEL_map;
                                                   ^
drivers/misc/mic/host/mic_debugfs.c:55:51: note: each undeclared identifier=
 is reported only once for each function it appears in
In file included from drivers/misc/mic/host/mic_device.h:27:0,
                 from drivers/misc/mic/host/mic_fops.c:25:
drivers/misc/mic/host/mic_intr.h:134:58: warning: 'struct pci_dev' declared=
 inside parameter list [enabled by default]
 int mic_setup_interrupts(struct mic_device *mdev, struct pci_dev *pdev);
                                                          ^
drivers/misc/mic/host/mic_intr.h:134:58: warning: its scope is only this de=
finition or declaration, which is probably not what you want [enabled by de=
fault]
drivers/misc/mic/host/mic_intr.h:135:58: warning: 'struct pci_dev' declared=
 inside parameter list [enabled by default]
 void mic_free_interrupts(struct mic_device *mdev, struct pci_dev *pdev);
                                                          ^
In file included from drivers/misc/mic/host/mic_fops.c:25:0:
drivers/misc/mic/host/mic_device.h: In function 'mic_mmio_read':
drivers/misc/mic/host/mic_device.h:164:2: error: implicit declaration of fu=
nction 'ioread32' [-Werror=3Dimplicit-function-declaration]
  return ioread32(mw->va + offset);
  ^
drivers/misc/mic/host/mic_device.h: In function 'mic_mmio_write':
drivers/misc/mic/host/mic_device.h:178:2: error: implicit declaration of fu=
nction 'iowrite32' [-Werror=3Dimplicit-function-declaration]
  iowrite32(val, mw->va + offset);
  ^
make[5]: *** [drivers/misc/mic/host/mic_debugfs.o] Error 1
In file included from arch/powerpc/include/asm/io.h:37:0,
                 from arch/powerpc/include/asm/dma.h:21,
                 from arch/powerpc/include/asm/scatterlist.h:12,
                 from include/linux/scatterlist.h:9,
                 from include/linux/virtio.h:6,
                 from include/linux/virtio_config.h:6,
                 from drivers/misc/mic/host/mic_virtio.h:24,
                 from drivers/misc/mic/host/mic_fops.c:27:
include/asm-generic/iomap.h: At top level:
include/asm-generic/iomap.h:31:21: error: conflicting types for 'ioread32'
 extern unsigned int ioread32(void __iomem *);
                     ^
In file included from drivers/misc/mic/host/mic_fops.c:25:0:
drivers/misc/mic/host/mic_device.h:164:9: note: previous implicit declarati=
on of 'ioread32' was here
  return ioread32(mw->va + offset);
         ^
In file included from arch/powerpc/include/asm/io.h:37:0,
                 from arch/powerpc/include/asm/dma.h:21,
                 from arch/powerpc/include/asm/scatterlist.h:12,
                 from include/linux/scatterlist.h:9,
                 from include/linux/virtio.h:6,
                 from include/linux/virtio_config.h:6,
                 from drivers/misc/mic/host/mic_virtio.h:24,
                 from drivers/misc/mic/host/mic_fops.c:27:
include/asm-generic/iomap.h:37:13: warning: conflicting types for 'iowrite3=
2' [enabled by default]
 extern void iowrite32(u32, void __iomem *);
             ^
In file included from drivers/misc/mic/host/mic_fops.c:25:0:
drivers/misc/mic/host/mic_device.h:178:2: note: previous implicit declarati=
on of 'iowrite32' was here
  iowrite32(val, mw->va + offset);
  ^

I assume all that is the result of commit aa27badd8972 ("Intel MIC Card
Driver for X100 family") from the char-misc tree.

I have disabled that driver for today (that commit did not revert
cleanly):

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 27 Sep 2013 18:38:55 +1000
Subject: [PATCH] disable broken Intel MIC Card Driver for X100 family for n=
ow

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/misc/mic/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/misc/mic/Kconfig b/drivers/misc/mic/Kconfig
index d453768..aa9805a 100644
--- a/drivers/misc/mic/Kconfig
+++ b/drivers/misc/mic/Kconfig
@@ -5,6 +5,7 @@ config INTEL_MIC_HOST
 	depends on 64BIT && PCI
 	select VHOST_RING
 	default N
+	depends on BROKEN
 	help
 	  This enables Host Driver support for the Intel Many Integrated
 	  Core (MIC) family of PCIe form factor coprocessor devices that
@@ -26,6 +27,7 @@ config INTEL_MIC_CARD
 	depends on 64BIT
 	select VIRTIO
 	default N
+	depends on BROKEN
 	help
 	  This enables card driver support for the Intel Many Integrated
 	  Core (MIC) device family. The card driver communicates shutdown/
--=20
1.8.4.rc3

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__27_Sep_2013_18_48_04_+1000_Lk4J1=YKKSJmhhQf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSRUZKAAoJEMDTa8Ir7ZwVXHwP/RQrR7UJMCLO6+sXjbhGSQFS
HSm0CxV0mKRN3oWl3m0e+sfiN8D7BuaAZYRpgniPab6kE3VqyKVR3rCaNopoU1TH
LVBAmBLMSIBtQcqPb+sL93cJyKz89MKVwrc1uN0Qazr/UnLCDBPhLnSQC50lyHHv
2KrVJlLSLGpEFIX17bVrh01lcs1pPbqwrNoPupjRYD19h3SKdPx5K2NjU+6JZJ6s
Nnci1g8CtIdHUTZBvUjd6wzg5OdIMgUg/H84Q/npLzBiMeOoidmERlC2BQLgKE+a
suWX2L1gMepOuTkucLAmSSvxAZklH8tRAqWbQ9DxcG5y3gblzIBhfWviglrRCnDD
3xYHdZ5xPXs4i6jIb446GowvB+neRMKV2rnKhkE/AFkp83Je4nzPgq9sDXSivIXC
Dwm8/zdaJj9Wx0+QGmaY4iKYJE614/KaXeWWJ+lKx+3BAIhop+RgxJcmds0jkwTH
0E1+4TgeYLjjyUNr4AFh9G6ZvFfTmbyI2gF02UWNx6mBnAMLcGo4jDUgZ7mpSrdF
Hh4e8KfpMrzGhpsT5qtwhIjKDcf4Opz2xym0mwuBrTSZ20cve2NaWJQUI1/WuddJ
kyxAhJnkIHiNSEgJpjagkb95E0vy4UozXfLsTossVjsDHKdC/LYdmC3d1LwPLyU8
l/Qq89XiGa45juXcskwk
=4YU8
-----END PGP SIGNATURE-----

--Signature=_Fri__27_Sep_2013_18_48_04_+1000_Lk4J1=YKKSJmhhQf--
