Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab3EFIvZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 04:51:25 -0400
Received: from 8bytes.org ([85.214.48.195]:40887 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752228Ab3EFIvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 04:51:24 -0400
Date: Mon, 6 May 2013 10:51:21 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: [git pull] IOMMU Updates for v3.10
Message-ID: <20130506085120.GA2973@8bytes.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3MwIy2ne0vdjdPXF"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Mon May  6 10:51:22 2013
X-DSPAM-Confidence: 0.9990
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 51876f0a23671334620052
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The following changes since commit c1be5a5b1b355d40e6cf79cc979eb66dafa24ad1:

  Linux 3.9 (2013-04-28 17:36:01 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git tags/iommu-updates-v3.10

for you to fetch changes up to 0c4513be3d01a854867446ee793748409cc0ebdf:

  Merge branches 'iommu/fixes', 'x86/vt-d', 'x86/amd', 'ppc/pamu', 'core' and 'arm/tegra' into next (2013-05-02 12:10:19 +0200)

----------------------------------------------------------------

IOMMU Updates for Linux v3.10

The updates are mostly about the x86 IOMMUs this time. Exceptions are
the groundwork for the PAMU IOMMU from Freescale (for a PPC platform)
and an extension to the IOMMU group interface. On the x86 side this
includes a workaround for VT-d to disable interrupt remapping on broken
chipsets. On the AMD-Vi side the most important new feature is a kernel
command-line interface to override broken information in IVRS ACPI
tables and get interrupt remapping working this way. Besides that there
are small fixes all over the place.

----------------------------------------------------------------
Alexey Kardashevskiy (1):
      iommu: Add a function to find an iommu group by id

Joerg Roedel (12):
      iommu/amd: Remove map_sg_no_iommu()
      iommu/amd: Use AMD specific data structure for irq remapping
      iommu/amd: Properly initialize irq-table lock
      iommu: Fix compile warnings with forward declarations
      iommu/amd: Move add_special_device() to __init
      iommu/amd: Extend IVRS special device data structure
      iommu/amd: Add early maps for ioapic and hpet
      iommu/amd: Add ioapic and hpet ivrs override
      iommu/amd: Don't report firmware bugs with cmd-line ivrs overrides
      iommu/amd: Document ivrs_ioapic and ivrs_hpet parameters
      iommu/amd: Workaround for ERBT1312
      Merge branches 'iommu/fixes', 'x86/vt-d', 'x86/amd', 'ppc/pamu', 'core' and 'arm/tegra' into next

Li, Zhen-Hua (1):
      iommu/vt-d: dmar_fault should only clear PPF/PFO field.

Linn Crosetto (1):
      iommu/vt-d: Remove warning for HPET scope type

Neil Horman (1):
      iommu/vt-d: add quirk for broken interrupt remapping on 55XX chipsets

Suravee Suthikulpanit (2):
      iommu/amd: Re-enable IOMMU event log interrupt after handling.
      iommu/AMD: Per-thread IOMMU Interrupt Handling

Takao Indoh (1):
      iommu/vt-d: Disable translation if already enabled

Varun Sethi (4):
      iommu/fsl: Make iova dma_addr_t in the iommu_iova_to_phys API.
      iommu/fsl: Add the window permission flag as a parameter to iommu_window_enable API.
      iommu: Move swap_pci_ref function to drivers/iommu/pci.h.
      iommu/tegra: Fix printk formats for dma_addr_t

Wang YanQing (1):
      iommu: Include linux/err.h

Wei Yongjun (1):
      iommu/amd: fix error return code in early_amd_iommu_init()

 Documentation/kernel-parameters.txt  |   14 ++++
 arch/x86/include/asm/irq_remapping.h |    9 ++
 arch/x86/kernel/early-quirks.c       |   20 +++++
 drivers/iommu/amd_iommu.c            |  145 ++++++++++++++------------------
 drivers/iommu/amd_iommu_init.c       |  154 ++++++++++++++++++++++++++++++----
 drivers/iommu/amd_iommu_types.h      |    2 +
 drivers/iommu/dmar.c                 |   26 ++++--
 drivers/iommu/exynos-iommu.c         |    2 +-
 drivers/iommu/intel-iommu.c          |   24 ++++--
 drivers/iommu/intel_irq_remapping.c  |   10 +++
 drivers/iommu/iommu.c                |   37 +++++++-
 drivers/iommu/irq_remapping.c        |    6 ++
 drivers/iommu/irq_remapping.h        |    2 +
 drivers/iommu/msm_iommu.c            |    2 +-
 drivers/iommu/omap-iommu.c           |    2 +-
 drivers/iommu/pci.h                  |   29 +++++++
 drivers/iommu/shmobile-iommu.c       |    2 +-
 drivers/iommu/tegra-gart.c           |    5 +-
 drivers/iommu/tegra-smmu.c           |    5 +-
 include/linux/iommu.h                |   18 ++--
 20 files changed, 382 insertions(+), 132 deletions(-)
 create mode 100644 drivers/iommu/pci.h

Please pull.

Thanks,

	Joerg


--3MwIy2ne0vdjdPXF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJRh28IAAoJECvwRC2XARrjD9cP/AzFh5128wZGVYDAr4AVBKGt
PAmvQmd+QKZt/TDvuYPh5QOXdqF48R/cPCevAvNK5sn33xc8Ac4YvFqkAqAFmW26
ZpBwLsKjiMsJiHO17mvHzFPB+7dGhupoIwsChS5mcukrzbFreUmFQF7RR70eu5QI
ZaZlTkf06iKxxj4i+xkUcfIDEwMkqyd5QR+ij9Zo6kDP7jiahxz6yHjs8DKJTQLZ
V+7oAKlaIAaF5KU2pH5g7iXmSKtIL/Jpn5a7XGJfQD68gSCftzs3xV3qaFwC29/k
eXBZEzEOmUie4LyldQs0Da7BTDy4JDNhL4KF7Cg2607dcPsPJtSgBHYNqM5Rz9o/
L+4LSR/+TefizpudM6jk7ImDn8KenU+Mg8XXbzQyPAZ0beTcI0pxwC5GqCN+4I25
pjlLgMq/Vf3rf9DY6EOdc2ouTszYn1xQZPxTOVMDmBz2Bub41+ga1D0B9eJj/OfN
7I+opPupNpiV+PaUanLpTLE/rwebKc0h8NiwERgmndTmDha16k30wi9mYu/AT4MS
MoZJBWzhO63pdjRTCH/hAwtQJev2LOMHIDR7vOvmMR+vOZvzlSCvWghqWv2AGE+l
XEZvVGnSdOV38W5VogflIfAPmcV8MZPDVm16+3ROM0o1D+6Su+CXaWNBQUIKBgK+
I5TMcS8GI6IyuZFakiTG
=98Wk
-----END PGP SIGNATURE-----

--3MwIy2ne0vdjdPXF--


