Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751218AbaLPVWa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 16:22:30 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:53207 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbaLPVW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 16:22:29 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL 3/3] ARM: SoC/iommu configuration for 3.19
Date: Tue, 16 Dec 2014 22:22:25 +0100
Message-ID: <5437011.lU1AJxKYA5@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5499732.TPqbyGxy2W@wuerfel>
References: <5499732.TPqbyGxy2W@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:mpyiifQm0FTy7JmGjmAKv2zUr9LNA7jSpxzuXNS3G6G39ptD4mx
 zhCUIXJBjG7RAp2lwU9y5Qgd1UJmiYoUZtvfE7meFnC9wgEmfpxiNME/SSMudLEQY5iTEoZ
 MWYRlXwlwG7tU3AgbJ77eWa6AV7FVser8oOPv2VRwKXWxDlI1IA5bWkFXj955WMY4vlusN0
 UdwZeaaVo7Ei/eoI4S05w==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 5d01410fe4d92081f349b013a2e7a95429e4f2c9:

  Linux 3.18-rc6 (2014-11-23 15:25:20 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/iommu-config-for-linus

for you to fetch changes up to fd522d279235b8bcafc39c1040895fe2d938d1e7:

  Merge tag 'of-iommu-configure' of git://git.kernel.org/pub/scm/linux/kernel/git/will/linux into next/iommu-config (2014-12-05 17:45:38 +0100)

----------------------------------------------------------------
ARM: SoC/iommu configuration for 3.19

The iomm-config branch contains work from Will Deacon, quoting his description:

    This series adds automatic IOMMU and DMA-mapping configuration for
    OF-based DMA masters described using the generic IOMMU devicetree
    bindings. Although there is plenty of future work around splitting up
    iommu_ops, adding default IOMMU domains and sorting out automatic IOMMU
    group creation for the platform_bus, this is already useful enough for
    people to port over their IOMMU drivers and start using the new probing
    infrastructure (indeed, Marek has patches queued for the Exynos IOMMU).

The branch touches core ARM and IOMMU driver files, and the respective
maintainers (Russell King and Joerg Roedel) agreed to have the contents
merged through the arm-soc tree. The final version was ready just before
the merge window, so we ended up delaying it a bit longer than the rest,
but we don't expect to see regressions because this is just additional
infrastructure that will get used in drivers starting in 3.20 but is
unused so far.

---

Please note the non-obvious conflict resolution, Stephen got it
right in linux-next: https://lkml.org/lkml/2014/12/8/83

----------------------------------------------------------------
Arnd Bergmann (1):
      Merge tag 'of-iommu-configure' of git://git.kernel.org/.../will/linux into next/iommu-config

Marek Szyprowski (1):
      iommu: fix initialization without 'add_device' callback

Robin Murphy (1):
      iommu: store DT-probed IOMMU data privately

Will Deacon (7):
      iommu: provide early initialisation hook for IOMMU drivers
      dma-mapping: replace set_arch_dma_coherent_ops with arch_setup_dma_ops
      iommu: add new iommu_ops callback for adding an OF device
      iommu: provide helper function to configure an IOMMU for an of master
      dma-mapping: detect and configure IOMMU in of_dma_configure
      arm: call iommu_init before of_platform_populate
      arm: dma-mapping: plumb our iommu mapping ops into arch_setup_dma_ops

 arch/arm/include/asm/dma-mapping.h | 12 ++---
 arch/arm/kernel/setup.c            |  2 +
 arch/arm/mm/dma-mapping.c          | 83 ++++++++++++++++++++++++++++++++---
 drivers/iommu/Kconfig              |  2 +-
 drivers/iommu/iommu.c              |  2 +-
 drivers/iommu/of_iommu.c           | 89 ++++++++++++++++++++++++++++++++++++++
 drivers/of/platform.c              | 50 +++++++++++----------
 include/asm-generic/vmlinux.lds.h  |  2 +
 include/linux/dma-mapping.h        | 13 +++---
 include/linux/iommu.h              |  8 ++++
 include/linux/of_iommu.h           | 23 ++++++++++
 11 files changed, 242 insertions(+), 44 deletions(-)

