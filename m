Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467AbaHDOTw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 10:19:52 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:47582 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117AbaHDOTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 10:19:49 -0400
Date: Mon, 4 Aug 2014 10:19:45 -0400
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [GIT PULL] libata changes for v3.17-rc1
Message-ID: <20140804141945.GD26230@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Except for a few, all the changes are for ahci platform drivers for
the arm devices.  Nothing too interesting or dangerous.  There's one
merge from libata/for-3.16-fixes to pull in dependent changes.

Thanks.

The following changes since commit 1a112d10f03e83fb3a2fdc4c9165865dec8a3ca6:

  libata: introduce ata_host->n_tags to avoid oops on SAS controllers (2014-07-23 10:30:34 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata.git for-3.17

for you to fetch changes up to c4121c650e5c798c852e981c245caa6713c0d99e:

  ata: libahci: Silence compiler warning on 64-bit (2014-08-01 11:18:53 -0400)

----------------------------------------------------------------
Antoine Ténart (4):
      ata: libahci_platform: move port_map parameters into the AHCI structure
      ata: libahci: allow to use multiple PHYs
      ata: ahci_platform: add a generic AHCI compatible
      Documentation: bindings: document the sub-nodes AHCI bindings

Joe Perches (1):
      ata: Use dma_zalloc_coherent

Kiran Padwal (1):
      ahci: st: Make of_device_id array const

Kukjin Kim (1):
      ata: pata_samsung_cf: removes s5pc100 related ata codes

Lee Jones (1):
      ahci: st: Provide DT bindings for ST's SATA implementation

Mikko Perttunen (3):
      of: Add NVIDIA Tegra SATA controller binding
      ata: ahci_platform: Increase AHCI_MAX_CLKS to 4
      ata: Add support for the Tegra124 SATA controller

Russell King (4):
      ata: ahci_imx: allow hardware parameters to be specified in DT
      dt-bindings: ata: add ahci_imx electrical properties
      ata: ahci_imx: add disable for spread-spectrum
      dt-bindings: ata: document ability to disable spread-spectrum clock

Shawn Guo (1):
      dt-bindings: ata: create bindings for imx sata controller

Suman Tripathi (2):
      ahci_xgene: Fix the watermark threshold for the APM X-Gene SATA host controller driver.
      ahci_xgene: Use correct OOB tunning parameters for APM X-Gene SoC AHCI SATA Host controller driver.

Suravee Suthikulpanit (2):
      ahci: Check and set 64-bit DMA mask for platform AHCI driver
      ahci/xgene: Remove logic to set 64-bit DMA mask

Tejun Heo (1):
      Merge branch 'for-3.16-fixes' of git://git.kernel.org/.../tj/libata into for-3.17

Thierry Reding (1):
      ata: libahci: Silence compiler warning on 64-bit

Tim Small (1):
      sata_sil24: Identify which card suffered IRQ status error

Wei Yongjun (1):
      ahci: imx: add missing clk_disable_unprepare() on error in imx_sata_enable()

 .../devicetree/bindings/ata/ahci-platform.txt      |  45 ++-
 Documentation/devicetree/bindings/ata/ahci-st.txt  |  31 ++
 Documentation/devicetree/bindings/ata/imx-sata.txt |  36 ++
 .../devicetree/bindings/ata/tegra-sata.txt         |  30 ++
 drivers/ata/Kconfig                                |   9 +
 drivers/ata/Makefile                               |   1 +
 drivers/ata/acard-ahci.c                           |   2 +-
 drivers/ata/ahci.c                                 |   3 +-
 drivers/ata/ahci.h                                 |  19 +-
 drivers/ata/ahci_da850.c                           |   3 +-
 drivers/ata/ahci_imx.c                             | 187 +++++++++-
 drivers/ata/ahci_mvebu.c                           |   3 +-
 drivers/ata/ahci_platform.c                        |   8 +-
 drivers/ata/ahci_st.c                              |   4 +-
 drivers/ata/ahci_sunxi.c                           |   8 +-
 drivers/ata/ahci_tegra.c                           | 376 +++++++++++++++++++++
 drivers/ata/ahci_xgene.c                           |  29 +-
 drivers/ata/libahci.c                              |  19 +-
 drivers/ata/libahci_platform.c                     | 215 +++++++++---
 drivers/ata/pata_samsung_cf.c                      |  13 -
 drivers/ata/sata_fsl.c                             |   5 +-
 drivers/ata/sata_highbank.c                        |   2 +-
 drivers/ata/sata_sil24.c                           |   4 +-
 include/linux/ahci_platform.h                      |   5 +-
 include/linux/platform_data/ata-samsung_cf.h       |   1 -
 25 files changed, 917 insertions(+), 141 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ata/ahci-st.txt
 create mode 100644 Documentation/devicetree/bindings/ata/imx-sata.txt
 create mode 100644 Documentation/devicetree/bindings/ata/tegra-sata.txt
 create mode 100644 drivers/ata/ahci_tegra.c

-- 
tejun
