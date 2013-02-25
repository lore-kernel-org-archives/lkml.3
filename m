Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab3BYRO0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 12:14:26 -0500
Received: from 8bytes.org ([85.214.48.195]:33045 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948Ab3BYROY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 12:14:24 -0500
Date: Mon, 25 Feb 2013 18:14:20 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: [git pull] IOMMU Updates for v3.9
Message-ID: <20130225171414.GA3706@8bytes.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Mon Feb 25 18:14:21 2013
X-DSPAM-Confidence: 0.9995
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 512b9bed22971703615039
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

This time the pull-request conflicts at a few places with your tree
(mostly due to other changes on ARM). The conflicts are more or less
trivial, I attach my resolution diff to this pull request. Please let me
know if you want me to resolve the conflicts first before you pull.
Anyway, here is the pull-request:

The following changes since commit 19f949f52599ba7c3f67a5897ac6be14bfcb1200:

  Linux 3.8 (2013-02-18 15:58:34 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git tags/iommu-u=
pdates-v3.9

for you to fetch changes up to 604542b824f72fa5d7fd977af277538c1e15b5f0:

  Merge branches 'core', 'arm/omap', 'iommu/fixes', 'arm/tegra', 'arm/shmob=
ile', 'arm/exynos', 'x86/vt-d' and 'x86/amd' into next (2013-02-19 15:45:17=
 +0100)

----------------------------------------------------------------

IOMMU Updates for Linux v3.9

Besides some fixes and cleanups in the code there are three more
important changes to point out this time:

	* New IOMMU driver for the ARM SHMOBILE platform
	* An IOMMU-API extension for non-paging IOMMUs (required for
	  upcoming PAMU driver)
	* Rework of the way the Tegra IOMMU driver accesses its
	  registetrs - register windows are easier to extend now.

There are also a few changes to non-iommu code, but that is acked by the
respective maintainers.

----------------------------------------------------------------
Alexey Kardashevskiy (1):
      iommu: moving initialization earlier

Cho KyongHo (1):
      ARM: EXYNOS: remove system mmu initialization from exynos tree

Cong Ding (1):
      iommu/omap: Remove unnecessary null pointer check

Cyril Roelandt (1):
      iommu/amd: Remove redundant NULL check before dma_ops_domain_free().

Hannes Reinecke (1):
      iommu/vt-d: Zero out allocated memory in dmar_enable_qi

Hideki EIRAKU (4):
      iommu/shmobile: Add iommu driver for Renesas IPMMU modules
      ARM: mach-shmobile: sh7372: Add IPMMU device
      ARM: mach-shmobile: sh73a0: Add IPMMU device
      ARM: mach-shmobile: r8a7740: Add IPMMU device

Hiroshi Doyu (3):
      iommu/tegra: smmu: Support variable MMIO ranges/blocks
      iommu/tegra: smmu: Change SMMU's dependency on ARCH_TEGRA
      iommu/tegra: smmu: Fix incorrect mask for regbase

Joerg Roedel (8):
      iommu/tegra: smmu: Use helper function to check for valid register of=
fset
      iommu: Make sure DOMAIN_ATTR_MAX is really the maximum
      iommu: Check for valid pgsize_bitmap in iommu_map/unmap
      iommu: Implement DOMAIN_ATTR_PAGING attribute
      iommu: Add domain window handling functions
      iommu: Add DOMAIN_ATTR_WINDOWS domain attribute
      iommu/amd: Initialize device table after dma_ops
      Merge branches 'core', 'arm/omap', 'iommu/fixes', 'arm/tegra', 'arm/s=
hmobile', 'arm/exynos', 'x86/vt-d' and 'x86/amd' into next

Sachin Kamat (1):
      iommu/exynos: Make exynos_sysmmu_disable static

Sami Liedes (1):
      iommu/tegra: Add missing spinlock initialization

Stephen Warren (2):
      iommu/tegra: assume CONFIG_OF in gart driver
      iommu/tegra: assume CONFIG_OF in SMMU driver

 arch/arm/mach-exynos/Kconfig               |    5 -
 arch/arm/mach-exynos/Makefile              |    1 -
 arch/arm/mach-exynos/clock-exynos4.c       |   41 ++-
 arch/arm/mach-exynos/clock-exynos4210.c    |    9 +-
 arch/arm/mach-exynos/clock-exynos4212.c    |   23 +-
 arch/arm/mach-exynos/clock-exynos5.c       |   62 +++--
 arch/arm/mach-exynos/dev-sysmmu.c          |  274 -------------------
 arch/arm/mach-exynos/include/mach/sysmmu.h |   66 -----
 arch/arm/mach-exynos/mach-exynos4-dt.c     |   34 +++
 arch/arm/mach-exynos/mach-exynos5-dt.c     |   30 +++
 arch/arm/mach-shmobile/setup-r8a7740.c     |   33 +++
 arch/arm/mach-shmobile/setup-sh7372.c      |   39 +++
 arch/arm/mach-shmobile/setup-sh73a0.c      |   31 +++
 drivers/iommu/Kconfig                      |   76 +++++-
 drivers/iommu/Makefile                     |    2 +
 drivers/iommu/amd_iommu.c                  |    3 +-
 drivers/iommu/amd_iommu_init.c             |   10 +-
 drivers/iommu/dmar.c                       |    2 +-
 drivers/iommu/exynos-iommu.c               |    2 +-
 drivers/iommu/iommu.c                      |   66 ++++-
 drivers/iommu/omap-iommu.c                 |    4 +-
 drivers/iommu/shmobile-iommu.c             |  395 ++++++++++++++++++++++++=
++++
 drivers/iommu/shmobile-ipmmu.c             |  136 ++++++++++
 drivers/iommu/shmobile-ipmmu.h             |   34 +++
 drivers/iommu/tegra-gart.c                 |    4 +-
 drivers/iommu/tegra-smmu.c                 |   75 +++---
 include/linux/iommu.h                      |   30 ++-
 include/linux/platform_data/sh_ipmmu.h     |   18 ++
 28 files changed, 1043 insertions(+), 462 deletions(-)
 delete mode 100644 arch/arm/mach-exynos/dev-sysmmu.c
 delete mode 100644 arch/arm/mach-exynos/include/mach/sysmmu.h
 create mode 100644 drivers/iommu/shmobile-iommu.c
 create mode 100644 drivers/iommu/shmobile-ipmmu.c
 create mode 100644 drivers/iommu/shmobile-ipmmu.h
 create mode 100644 include/linux/platform_data/sh_ipmmu.h

Please pull.

Regards,

	Joerg

My conflict resolution:

diff --cc arch/arm/mach-exynos/mach-exynos5-dt.c
index 973a066,2671075..acaeb14
--- a/arch/arm/mach-exynos/mach-exynos5-dt.c
+++ b/arch/arm/mach-exynos/mach-exynos5-dt.c
@@@ -103,12 -104,36 +103,42 @@@ static const struct of_dev_auxdata exyn
  	OF_DEV_AUXDATA("samsung,mfc-v6", 0x11000000, "s5p-mfc-v6", NULL),
  	OF_DEV_AUXDATA("samsung,exynos5250-tmu", 0x10060000,
  				"exynos-tmu", NULL),
 +	OF_DEV_AUXDATA("samsung,i2s-v5", 0x03830000,
 +				"samsung-i2s.0", NULL),
 +	OF_DEV_AUXDATA("samsung,i2s-v5", 0x12D60000,
 +				"samsung-i2s.1", NULL),
 +	OF_DEV_AUXDATA("samsung,i2s-v5", 0x12D70000,
 +				"samsung-i2s.2", NULL),
+ 	OF_DEV_AUXDATA("samsung,exynos-sysmmu", 0x11210000,
+ 			"exynos-sysmmu.0", "mfc"), /* MFC_L */
+ 	OF_DEV_AUXDATA("samsung,exynos-sysmmu", 0x11200000,
+ 			"exynos-sysmmu.1", "mfc"), /* MFC_R */
+ 	OF_DEV_AUXDATA("samsung,exynos-sysmmu", 0x14650000,
+ 			"exynos-sysmmu.2", NULL), /* TV */
+ 	OF_DEV_AUXDATA("samsung,exynos-sysmmu", 0x11F20000,
+ 			"exynos-sysmmu.3", "jpeg"), /* JPEG */
+ 	OF_DEV_AUXDATA("samsung,exynos-sysmmu", 0x11D40000,
+ 			"exynos-sysmmu.4", NULL), /* ROTATOR */
+ 	OF_DEV_AUXDATA("samsung,exynos-sysmmu", 0x13E80000,
+ 			"exynos-sysmmu.5", "gscl"), /* GSCL0 */
+ 	OF_DEV_AUXDATA("samsung,exynos-sysmmu", 0x13E90000,
+ 			"exynos-sysmmu.6", "gscl"), /* GSCL1 */
+ 	OF_DEV_AUXDATA("samsung,exynos-sysmmu", 0x13EA0000,
+ 			"exynos-sysmmu.7", "gscl"), /* GSCL2 */
+ 	OF_DEV_AUXDATA("samsung,exynos-sysmmu", 0x13EB0000,
+ 			"exynos-sysmmu.8", "gscl"), /* GSCL3 */
+ 	OF_DEV_AUXDATA("samsung,exynos-sysmmu", 0x13260000,
+ 			"exynos-sysmmu.9", NULL), /* FIMC-IS0 */
+ 	OF_DEV_AUXDATA("samsung,exynos-sysmmu", 0x132C0000,
+ 			"exynos-sysmmu.10", NULL), /* FIMC-IS1 */
+ 	OF_DEV_AUXDATA("samsung,exynos-sysmmu", 0x14640000,
+ 			"exynos-sysmmu.11", NULL), /* FIMD1 */
+ 	OF_DEV_AUXDATA("samsung,exynos-sysmmu", 0x13C40000,
+ 			"exynos-sysmmu.12", NULL), /* FIMC-LITE0 */
+ 	OF_DEV_AUXDATA("samsung,exynos-sysmmu", 0x13C50000,
+ 			"exynos-sysmmu.13", NULL), /* FIMC-LITE1 */
+ 	OF_DEV_AUXDATA("samsung,exynos-sysmmu", 0x10A60000,
+ 			"exynos-sysmmu.14", NULL), /* G2D */
  	{},
  };
 =20
diff --cc arch/arm/mach-shmobile/setup-r8a7740.c
index 30ac79c,b85bea5..3d7aa9d
--- a/arch/arm/mach-shmobile/setup-r8a7740.c
+++ b/arch/arm/mach-shmobile/setup-r8a7740.c
@@@ -287,97 -263,37 +289,128 @@@ static struct platform_device cmt10_dev
  	.num_resources	=3D ARRAY_SIZE(cmt10_resources),
  };
 =20
 +/* TMU */
 +static struct sh_timer_config tmu00_platform_data =3D {
 +	.name =3D "TMU00",
 +	.channel_offset =3D 0x4,
 +	.timer_bit =3D 0,
 +	.clockevent_rating =3D 200,
 +};
 +
 +static struct resource tmu00_resources[] =3D {
 +	[0] =3D {
 +		.name	=3D "TMU00",
 +		.start	=3D 0xfff80008,
 +		.end	=3D 0xfff80014 - 1,
 +		.flags	=3D IORESOURCE_MEM,
 +	},
 +	[1] =3D {
 +		.start	=3D intcs_evt2irq(0xe80),
 +		.flags	=3D IORESOURCE_IRQ,
 +	},
 +};
 +
 +static struct platform_device tmu00_device =3D {
 +	.name		=3D "sh_tmu",
 +	.id		=3D 0,
 +	.dev =3D {
 +		.platform_data	=3D &tmu00_platform_data,
 +	},
 +	.resource	=3D tmu00_resources,
 +	.num_resources	=3D ARRAY_SIZE(tmu00_resources),
 +};
 +
 +static struct sh_timer_config tmu01_platform_data =3D {
 +	.name =3D "TMU01",
 +	.channel_offset =3D 0x10,
 +	.timer_bit =3D 1,
 +	.clocksource_rating =3D 200,
 +};
 +
 +static struct resource tmu01_resources[] =3D {
 +	[0] =3D {
 +		.name	=3D "TMU01",
 +		.start	=3D 0xfff80014,
 +		.end	=3D 0xfff80020 - 1,
 +		.flags	=3D IORESOURCE_MEM,
 +	},
 +	[1] =3D {
 +		.start	=3D intcs_evt2irq(0xea0),
 +		.flags	=3D IORESOURCE_IRQ,
 +	},
 +};
 +
 +static struct platform_device tmu01_device =3D {
 +	.name		=3D "sh_tmu",
 +	.id		=3D 1,
 +	.dev =3D {
 +		.platform_data	=3D &tmu01_platform_data,
 +	},
 +	.resource	=3D tmu01_resources,
 +	.num_resources	=3D ARRAY_SIZE(tmu01_resources),
 +};
 +
 +static struct sh_timer_config tmu02_platform_data =3D {
 +	.name =3D "TMU02",
 +	.channel_offset =3D 0x1C,
 +	.timer_bit =3D 2,
 +	.clocksource_rating =3D 200,
 +};
 +
 +static struct resource tmu02_resources[] =3D {
 +	[0] =3D {
 +		.name	=3D "TMU02",
 +		.start	=3D 0xfff80020,
 +		.end	=3D 0xfff8002C - 1,
 +		.flags	=3D IORESOURCE_MEM,
 +	},
 +	[1] =3D {
 +		.start	=3D intcs_evt2irq(0xec0),
 +		.flags	=3D IORESOURCE_IRQ,
 +	},
 +};
 +
 +static struct platform_device tmu02_device =3D {
 +	.name		=3D "sh_tmu",
 +	.id		=3D 2,
 +	.dev =3D {
 +		.platform_data	=3D &tmu02_platform_data,
 +	},
 +	.resource	=3D tmu02_resources,
 +	.num_resources	=3D ARRAY_SIZE(tmu02_resources),
 +};
 +
+ /* IPMMUI (an IPMMU module for ICB/LMB) */
+ static struct resource ipmmu_resources[] =3D {
+ 	[0] =3D {
+ 		.name	=3D "IPMMUI",
+ 		.start	=3D 0xfe951000,
+ 		.end	=3D 0xfe9510ff,
+ 		.flags	=3D IORESOURCE_MEM,
+ 	},
+ };
+=20
+ static const char * const ipmmu_dev_names[] =3D {
+ 	"sh_mobile_lcdc_fb.0",
+ 	"sh_mobile_lcdc_fb.1",
+ 	"sh_mobile_ceu.0",
+ };
+=20
+ static struct shmobile_ipmmu_platform_data ipmmu_platform_data =3D {
+ 	.dev_names =3D ipmmu_dev_names,
+ 	.num_dev_names =3D ARRAY_SIZE(ipmmu_dev_names),
+ };
+=20
+ static struct platform_device ipmmu_device =3D {
+ 	.name           =3D "ipmmu",
+ 	.id             =3D -1,
+ 	.dev =3D {
+ 		.platform_data =3D &ipmmu_platform_data,
+ 	},
+ 	.resource       =3D ipmmu_resources,
+ 	.num_resources  =3D ARRAY_SIZE(ipmmu_resources),
+ };
+=20
  static struct platform_device *r8a7740_early_devices[] __initdata =3D {
  	&scif0_device,
  	&scif1_device,
@@@ -389,9 -305,7 +422,10 @@@
  	&scif7_device,
  	&scifb_device,
  	&cmt10_device,
 +	&tmu00_device,
 +	&tmu01_device,
 +	&tmu02_device,
+ 	&ipmmu_device,
  };
 =20
  /* DMA */
diff --cc arch/arm/mach-shmobile/setup-sh73a0.c
index 2ecd668,36c2b2e..bdab575
--- a/arch/arm/mach-shmobile/setup-sh73a0.c
+++ b/arch/arm/mach-shmobile/setup-sh73a0.c
@@@ -780,7 -755,36 +781,36 @@@ static struct platform_device pmu_devic
  	.resource	=3D pmu_resources,
  };
 =20
+ /* an IPMMU module for ICB */
+ static struct resource ipmmu_resources[] =3D {
+ 	[0] =3D {
+ 		.name	=3D "IPMMU",
+ 		.start	=3D 0xfe951000,
+ 		.end	=3D 0xfe9510ff,
+ 		.flags	=3D IORESOURCE_MEM,
+ 	},
+ };
+=20
+ static const char * const ipmmu_dev_names[] =3D {
+ 	"sh_mobile_lcdc_fb.0",
+ };
+=20
+ static struct shmobile_ipmmu_platform_data ipmmu_platform_data =3D {
+ 	.dev_names =3D ipmmu_dev_names,
+ 	.num_dev_names =3D ARRAY_SIZE(ipmmu_dev_names),
+ };
+=20
+ static struct platform_device ipmmu_device =3D {
+ 	.name           =3D "ipmmu",
+ 	.id             =3D -1,
+ 	.dev =3D {
+ 		.platform_data =3D &ipmmu_platform_data,
+ 	},
+ 	.resource       =3D ipmmu_resources,
+ 	.num_resources  =3D ARRAY_SIZE(ipmmu_resources),
+ };
+=20
 -static struct platform_device *sh73a0_early_devices[] __initdata =3D {
 +static struct platform_device *sh73a0_early_devices_dt[] __initdata =3D {
  	&scif0_device,
  	&scif1_device,
  	&scif2_device,
@@@ -791,11 -795,9 +821,12 @@@
  	&scif7_device,
  	&scif8_device,
  	&cmt10_device,
 +};
 +
 +static struct platform_device *sh73a0_early_devices[] __initdata =3D {
  	&tmu00_device,
  	&tmu01_device,
+ 	&ipmmu_device,
  };
 =20
  static struct platform_device *sh73a0_late_devices[] __initdata =3D {
diff --cc drivers/iommu/tegra-smmu.c
index f08dbcd,8b1d9f7..eb0109f
--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@@ -1177,10 -1185,13 +1186,13 @@@ static int tegra_smmu_probe(struct plat
  		res =3D platform_get_resource(pdev, IORESOURCE_MEM, i);
  		if (!res)
  			return -ENODEV;
 -		smmu->regs[i] =3D devm_request_and_ioremap(&pdev->dev, res);
 -		if (!smmu->regs[i])
 -			return -EBUSY;
 +		smmu->regs[i] =3D devm_ioremap_resource(&pdev->dev, res);
 +		if (IS_ERR(smmu->regs[i]))
 +			return PTR_ERR(smmu->regs[i]);
+ 		smmu->rege[i] =3D smmu->regs[i] + resource_size(res) - 1;
  	}
+ 	/* Same as "mc" 1st regiter block start address */
+ 	smmu->regbase =3D (void __iomem *)((u32)smmu->regs[0] & PAGE_MASK);
 =20
  	err =3D of_get_dma_window(dev->of_node, NULL, 0, NULL, &base, &size);
  	if (err)

--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJRK5vmAAoJECvwRC2XARrjI7gQAKDI98hNNVLcBfBnYfm6FffK
bJshjqUJjzKFWmmfHcu20DLlpnkx9yiPKiDa/P9/wwMcIZyKFoo6eieq9nbC+Sab
KAGNPlGF25nP2yiJaCygOcyckc/C0pMIq5f5RNrIS8QVcDVI0ZiCik1ZhJpDCFJf
1zsvmrnwmoZXy/9qll3Ft7pOSlfCouYA3BNH7oPdYrrSq4vmV9qoyrTbYVtV/gR1
2dv6lWHLs9MkrAM6Mta/+SNz0UbEw40T8GAGngktBetNmXszDw9Mxci5gIn2rCON
9nN72zCvKnS0ZWvQ97qWNAofL524v06wH0tO29UQEHCzCldEHuAHMwWz6qSEP0Ii
JEwkmpmtxnDrHsp7BB1VUY3OJkgClsobhRswey9iEmM+xd2fMt+mAUlfU/rbepeS
hyxxGt3D8yUFmXxYpubj3dVI0W4+6lCbqzf35sSmzhiKJmy3ke/Fx8veyeyH65Ab
YXQt3odGBxJzh/W1/wVa/IPl/Y6lmoZYdKPX4yROemCHTLu/EiG8PIdhz+aHtr2/
lZ4ePWaA4fspGfIL5V6BXmZ11ywCYKbijKWz4F+rG9O/S4YmJ0MHDEz6trT65gUK
4ey1Ld+pFD/Irg9yjaobtf6woS2pAnXhUeEe2qIeGvKwSf8vXAfnLc1uRDmzWKHh
xha5bsIsSm83gqoIwY6L
=JLn7
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--


