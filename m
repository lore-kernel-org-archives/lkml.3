Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab3ILPfK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 11:35:10 -0400
Received: from 8bytes.org ([85.214.48.195]:60178 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751736Ab3ILPfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 11:35:08 -0400
Date: Thu, 12 Sep 2013 17:35:03 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: [git pull] IOMMU Updates for v3.12
Message-ID: <20130912153502.GA28163@8bytes.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AqsLC8rIMeq19msA"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Thu Sep 12 17:35:06 2013
X-DSPAM-Confidence: 0.9989
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5231df2a20861148780270
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

The following changes since commit 6e4664525b1db28f8c4e1130957f70a94c19213e:

  Linux 3.11 (2013-09-02 13:46:10 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git tags/iommu-u=
pdates-v3.12

for you to fetch changes up to d6a60fc1a8187004792a01643d8af1d06a465026:

  Merge branches 'arm/exynos', 'ppc/pamu', 'arm/smmu', 'x86/amd' and 'iommu=
/fixes' into next (2013-09-12 16:46:34 +0200)

----------------------------------------------------------------

IOMMU Updates for Linux v3.12

This round the updates contain:

	* A new driver for the Freescale PAMU IOMMU from Varun Sethi.
	  This driver has cooked for a while and required changes to the
	  IOMMU-API and infrastructure that were already merged before.
	* Updates for the ARM-SMMU driver from Will Deacon
	* Various fixes, the most important one is probably a fix from
	  Alex Williamson for a memory leak in the VT-d page-table
	  freeing code

In summary not all that much. The biggest part in the diffstat is the
new PAMU driver.

----------------------------------------------------------------
Alex Williamson (1):
      intel-iommu: Fix leaks in pagetable freeing

Grant Grundler (1):
      iommu/exynos: Remove dead code (set_prefbuf)

Joerg Roedel (3):
      iommu/fsl: Fix whitespace problems noticed by git-am
      iommu/fsl: Remove unnecessary 'fsl-pamu' prefixes
      Merge branches 'arm/exynos', 'ppc/pamu', 'arm/smmu', 'x86/amd' and 'i=
ommu/fixes' into next

Radmila Kompov=E1 (1):
      iommu/amd: Fix resource leak in iommu_init_device()

Varun Sethi (3):
      powerpc: Add iommu domain pointer to device archdata
      iommu/fsl: Add additional iommu attributes required by the PAMU drive=
r.
      iommu/fsl: Freescale PAMU driver and iommu implementation.

Will Deacon (4):
      iommu/arm-smmu: Remove broken big-endian check
      iommu/arm-smmu: Tighten up global fault reporting
      iommu/arm-smmu: Don't use VMIDs for stage-1 translations
      iommu/arm-smmu: Simplify VMID and ASID allocation

Yijing Wang (1):
      iommu/amd: Clean up unnecessary MSI/MSI-X capability find

 arch/powerpc/include/asm/device.h         |    3 +
 arch/powerpc/include/asm/fsl_pamu_stash.h |   39 +
 arch/powerpc/sysdev/fsl_pci.h             |    5 +
 drivers/iommu/Kconfig                     |   10 +
 drivers/iommu/Makefile                    |    1 +
 drivers/iommu/amd_iommu.c                 |    4 +-
 drivers/iommu/amd_iommu_init.c            |    2 +-
 drivers/iommu/arm-smmu.c                  |   93 +-
 drivers/iommu/exynos-iommu.c              |   44 -
 drivers/iommu/fsl_pamu.c                  | 1309 +++++++++++++++++++++++++=
++++
 drivers/iommu/fsl_pamu.h                  |  410 +++++++++
 drivers/iommu/fsl_pamu_domain.c           | 1172 ++++++++++++++++++++++++++
 drivers/iommu/fsl_pamu_domain.h           |   85 ++
 drivers/iommu/intel-iommu.c               |   72 +-
 include/linux/iommu.h                     |   16 +
 15 files changed, 3145 insertions(+), 120 deletions(-)
 create mode 100644 arch/powerpc/include/asm/fsl_pamu_stash.h
 create mode 100644 drivers/iommu/fsl_pamu.c
 create mode 100644 drivers/iommu/fsl_pamu.h
 create mode 100644 drivers/iommu/fsl_pamu_domain.c
 create mode 100644 drivers/iommu/fsl_pamu_domain.h

Please pull.

Thanks,

	Joerg


--AqsLC8rIMeq19msA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJSMd8lAAoJECvwRC2XARrjnLYP/ieozuteXTzVKscSnKf0QnnJ
PKCLDl9h4L4Rc2+7tWqS3ZemNPaot5ljuU9iV9WcSp2xzsZc+FuISHkm13/dEKw3
al2VgEJjDvd372GMYvMnBJZv6YC2wv66FQKwZkEGgrjarsUu9iaVNJXNWtcXK7Ou
H9tbvLiaKHOSszsRIBV6McuNZCe6CqUNmMXqGpN2kBHd1LwCAaxcCjN5/mO+Ru6W
JnXUIXX+wiO4aAQNLFYP/bqJOUwSH9LBrkNfIE1+eAxiqKhiAuwPBCXwXuo/Ykrh
Cyu5HR/NeoaOd7gAE8JfW4/BN5IpOBFA8VcvCGTQZAqhnD12oYxz2kez7G8sxuS+
4G162seRTjgU69yBzkKFxYcoKhwlHXtfRH5YUhc0JNNf926EiGHUOa9yhJOaSDLN
mneoaR8qktERUst3hMqi6kw6lCzg2mNoqy7UgdAo0sjMZ8So4TmlyjfVnIdODEeV
lqkP4BFRkRSBFRPQHBMe9psJsPAS66IHhSI6+6RjpyN1YKccvhzJowNEJO7wCCVq
FbN8RhSeep0whCyLvk7mNOt7vPY9gexCSQOAIO8SpvXpq4lOjsxDvwvTfDCKm4O3
eVyLMsa4ZivKt85cljg4jHIOvL/kt2hZyRvgOrX4dmmHZTw7DMq95TsCFcx1HX7C
QIiYjZJeddCL7Hz7E9yf
=AY5k
-----END PGP SIGNATURE-----

--AqsLC8rIMeq19msA--


