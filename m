Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208Ab3KKTbV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 14:31:21 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:37595 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076Ab3KKTbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 14:31:13 -0500
Date: Mon, 11 Nov 2013 14:30:03 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [GIT PULL] (xen) stable/for-linus-3.13-rc0-tag
Message-ID: <20131111193003.GA8024@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EuxKj2iCbKjpUGkD"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EuxKj2iCbKjpUGkD
Content-Type: multipart/mixed; boundary="vtzGhvizbBRQ85DL"
Content-Disposition: inline


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey Linus,

Please git pull the following tag:

 git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip.git stable/for-linus-3.13-rc0-tag

which has tons of fixes and two major features which are concentrated around
the Xen SWIOTLB library.

The short <blurb> is that the tracing facility (just one function) has been
added to SWIOTLB to make it easier to track I/O progress. Additionally under
Xen and ARM (32 & 64) the Xen-SWIOTLB driver "isused to translate physical to
machine and machine to physical addresses of foreign[guest] pages for
DMA operations" (Stefano) when booting under hardware without proper IOMMU.

There are also bug-fixes, cleanups, compile warning fixes, etc.

</blurb>

The commit times for some of the commits is a bit fresh - that is b/c
we wanted to make sure we have the Ack's from the ARM folks - which with
the string of back-to-back conferences took a bit of time. Rest assured -
the code has been stewing in #linux-next for some time.

There is also an easy to resolve conflict with the ARM tree, and
Stephen Rothwell is carrying a patch:

	arch/arm/include/asm/dma-mapping.h between commit 6a6a5c15d871 ("ARM:
	7805/1: mm: change max*pfn to include the physical offset of memory")
	from the arm tree and commit e24b7aa368a0 ("arm: make SWIOTLB available")
	from the xen-tip tree.


See attached file.

 arch/arm/Kconfig                           |   7 +
 arch/arm/include/asm/dma-mapping.h         |  46 ++++++-
 arch/arm/include/asm/io.h                  |   9 ++
 arch/arm/include/asm/xen/hypervisor.h      |   2 +
 arch/arm/include/asm/xen/page-coherent.h   |  50 +++++++
 arch/arm/include/asm/xen/page.h            |  44 +++++-
 arch/arm/xen/Makefile                      |   2 +-
 arch/arm/xen/mm.c                          |  65 +++++++++
 arch/arm/xen/p2m.c                         | 208 +++++++++++++++++++++++++++++
 arch/arm64/Kconfig                         |   1 +
 arch/arm64/include/asm/dma-mapping.h       |  14 +-
 arch/arm64/include/asm/io.h                |  10 ++
 arch/arm64/include/asm/xen/page-coherent.h |  47 +++++++
 arch/arm64/xen/Makefile                    |   2 +-
 arch/ia64/include/asm/xen/page-coherent.h  |  38 ++++++
 arch/x86/include/asm/xen/page-coherent.h   |  38 ++++++
 arch/x86/xen/mmu.c                         |  15 ++-
 arch/x86/xen/p2m.c                         |   6 +-
 arch/x86/xen/pci-swiotlb-xen.c             |   4 +
 arch/x86/xen/setup.c                       |   2 +-
 arch/x86/xen/smp.c                         |  10 +-
 arch/x86/xen/spinlock.c                    |   2 +-
 arch/x86/xen/time.c                        |   3 +-
 drivers/tty/hvc/hvc_xen.c                  |  19 ++-
 drivers/xen/Kconfig                        |   1 -
 drivers/xen/balloon.c                      |   6 +-
 drivers/xen/evtchn.c                       |   2 +-
 drivers/xen/grant-table.c                  |  19 ++-
 drivers/xen/pci.c                          |  47 +++++++
 drivers/xen/platform-pci.c                 |   2 +-
 drivers/xen/swiotlb-xen.c                  | 119 +++++++++++++----
 include/trace/events/swiotlb.h             |  46 +++++++
 include/xen/interface/physdev.h            |  11 ++
 include/xen/swiotlb-xen.h                  |   3 +
 include/xen/xen-ops.h                      |   7 +-
 lib/swiotlb.c                              |   6 +
 36 files changed, 846 insertions(+), 67 deletions(-)

Boris Ostrovsky (1):
      xen/balloon: Set balloon's initial state to number of existing RAM pages

Konrad Rzeszutek Wilk (3):
      xen/mmu: Correct PAT MST setting.
      xen/hvc: If we use xen_raw_printk let it also work on HVM guests.
      xen/mcfg: Call PHYSDEVOP_pci_mmcfg_reserved for MCFG areas.

Michael Opdenacker (2):
      x86/xen: remove deprecated IRQF_DISABLED
      xen: remove deprecated IRQF_DISABLED

Paul Gortmaker (1):
      xen: delete new instances of added __cpuinit

Stefano Stabellini (23):
      arm: make SWIOTLB available
      arm64: define DMA_ERROR_CODE
      arm/xen,arm64/xen: introduce p2m
      xen/x86: allow __set_phys_to_machine for autotranslate guests
      xen: make xen_create_contiguous_region return the dma address
      xen/arm,arm64: enable SWIOTLB_XEN
      swiotlb-xen: introduce xen_swiotlb_set_dma_mask
      arm/xen: get_dma_ops: return xen_dma_ops if we are running as xen_initial_domain
      arm64/xen: get_dma_ops: return xen_dma_ops if we are running as xen_initial_domain
      xen: introduce xen_alloc/free_coherent_pages
      swiotlb-xen: use xen_alloc/free_coherent_pages
      xen: introduce xen_dma_map/unmap_page and xen_dma_sync_single_for_cpu/device
      swiotlb-xen: use xen_dma_map/unmap_page, xen_dma_sync_single_for_cpu/device
      swiotlb: print a warning when the swiotlb is full
      arm,arm64: do not always merge biovec if we are running on Xen
      grant-table: call set_phys_to_machine after mapping grant refs
      swiotlb-xen: static inline xen_phys_to_bus, xen_bus_to_phys, xen_virt_to_bus and range_straddles_page_boundary
      swiotlb-xen: fix error code returned by xen_swiotlb_map_sg_attrs
      arm: make SWIOTLB available
      pci-swiotlb-xen: call pci_request_acs only ifdef CONFIG_PCI
      swiotlb-xen: missing include dma-direction.h
      arm,arm64/include/asm/io.h: define struct bio_vec
      xen/arm: pfn_to_mfn and mfn_to_pfn return the argument if nothing is in the p2m

Thierry Reding (1):
      tracing/events: Fix swiotlb tracepoint creation

Zoltan Kiss (1):
      tracing/events: Add bounce tracing to swiotbl


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="linux-next-merge.patch"
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the xen-tip tree got a conflict in
arch/arm/include/asm/dma-mapping.h between commit 6a6a5c15d871 ("ARM:
7805/1: mm: change max*pfn to include the physical offset of memory")
=66rom the arm tree and commit e24b7aa368a0 ("arm: make SWIOTLB available")
=66rom the xen-tip tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/include/asm/dma-mapping.h
index 863cd84eb1a2,8acfef48124a..000000000000
--- a/arch/arm/include/asm/dma-mapping.h
+++ b/arch/arm/include/asm/dma-mapping.h
@@@ -87,13 -97,39 +98,46 @@@ static inline dma_addr_t virt_to_dma(st
  }
  #endif
 =20
+ static inline dma_addr_t phys_to_dma(struct device *dev, phys_addr_t padd=
r)
+ {
+ 	unsigned int offset =3D paddr & ~PAGE_MASK;
+ 	return pfn_to_dma(dev, __phys_to_pfn(paddr)) + offset;
+ }
+=20
+ static inline phys_addr_t dma_to_phys(struct device *dev, dma_addr_t dev_=
addr)
+ {
+ 	unsigned int offset =3D dev_addr & ~PAGE_MASK;
+ 	return __pfn_to_phys(dma_to_pfn(dev, dev_addr)) + offset;
+ }
+=20
+ static inline bool dma_capable(struct device *dev, dma_addr_t addr, size_=
t size)
+ {
+ 	u64 limit, mask;
+=20
+ 	if (!dev->dma_mask)
+ 		return 0;
+=20
+ 	mask =3D *dev->dma_mask;
+=20
+ 	limit =3D (mask + 1) & ~mask;
+ 	if (limit && size > limit)
+ 		return 0;
+=20
+ 	if ((addr | (addr + size - 1)) & ~mask)
+ 		return 0;
+=20
+ 	return 1;
+ }
+=20
+ static inline void dma_mark_clean(void *addr, size_t size) { }
+=20
 +/* The ARM override for dma_max_pfn() */
 +static inline unsigned long dma_max_pfn(struct device *dev)
 +{
 +	return PHYS_PFN_OFFSET + dma_to_pfn(dev, *dev->dma_mask);
 +}
 +#define dma_max_pfn(dev) dma_max_pfn(dev)
 +
  /*
   * DMA errors are defined by all-bits-set in the DMA address.
   */

--vtzGhvizbBRQ85DL--

--EuxKj2iCbKjpUGkD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQEcBAEBAgAGBQJSgTA3AAoJEFjIrFwIi8fJzfEH/Awv/wuCEcMGND2fyGgEZHCo
jatosTaEAGp8qg01RS3EQLofU9pSeSE6VLkFYmet1gjtmSZs1UzFa1dTi/aL7Mkz
Ee8DEBOBmlxm3CZcpEjQQn4m5ynZ9dALf/zcsTUWq745FWCbDZVbJsO212s+nSG7
nYaouGusUIC4PAgqtXjxJjNou+Fr3CMX31Bh3MWfB8g5hSF8w9ECmkKFRFpRwmUz
LTRpXBgF1xgQgBOpml7q6+/CTPFUuRwZjBmD7k4HFfdwyp1nbxzmG8voHixD6+xs
grZXutnY68zRJUMBTuesXy2p7fd43qVnXaAp99/Ni/l7Hp3MzZ54vrNHygutHFg=
=V84r
-----END PGP SIGNATURE-----

--EuxKj2iCbKjpUGkD--
