Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788Ab3GCDOd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 23:14:33 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:51672 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755615Ab3GCDOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 23:14:31 -0400
Date: Tue, 2 Jul 2013 20:14:26 -0700
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [GIT PULL] libata changes for v3.11-rc1
Message-ID: <20130703031426.GA21116@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Nothing too interesting; however, the top commit is merging
for-3.10-fixes into for-3.11.  The severity of patches which were
collecting for-3.10-fixes didn't seem to justify new -fixes pull
request, but, in retrospect, I think I sat on them for too long and
will probably push out quicker from now on.  The merge creates three
conflicts in sata_rcar.c but all are trivial and the resoultions are
identical to what have been published through for-next for quite some
time.

Overview of changes:

* The rest of maintainer email address updates.

* Some core updates - more robust default behavior for port
  multipliers, better error reporting for SG_IO commands, and a way to
  better work around now ancient and probably pretty rare PATA -> SATA
  bridges with ATAPI devices.

* sata_rcar stabilization.

* Some hardware PCI ID additions and one-off low level driver updates.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata.git for-3.11

for you to fetch changes up to 5a0a6a4f17a3606289f96356383db695a555bdbd:

  Merge branch 'libata/for-3.10-fixes' into libata/for-3.11 (2013-07-02 19:54:16 -0700)

----------------------------------------------------------------

Alexander Gordeev (1):
      AHCI: Make distinct names for ports in /proc/interrupts

David Milburn (1):
      libata: export ata_port port_no attribute via /sys

Girish K S (1):
      ahci: sata: add support for exynos5440 sata

Gwendal Grignou (1):
      libata: cleanup SAT error translation

Jingoo Han (2):
      ata: use platform_{get,set}_drvdata()
      ata: use pci_get_drvdata()

Mark Langsdorf (3):
      sata_highbank: increase retry count but shorten duration for Calxeda controller
      ahci: make ahci_transmit_led_message into a function pointer
      sata highbank: add bit-banged SGPIO driver support

Sergei Shtylyov (7):
      sata_rcar: kill superfluous code in sata_rcar_bmdma_fill_sg()
      sata_rcar: correct 'sata_rcar_sht'
      sata_rcar: add 'base' local variable to some functions
      ipr: qc_fill_rtf() method should not store alternate status register
      sata_rcar: fix compilation warning in sata_rcar_thaw()
      libata-zpodd: must use ata_tf_init()
      AHCI: use ATA_BUSY

Seth Heasley (2):
      ata_piix: IDE-mode SATA patch for Intel Coleto Creek DeviceIDs
      ahci: AHCI-mode SATA patch for Intel Coleto Creek DeviceIDs

Shane Huang (1):
      ahci: remove pmp link online check in FBS EH

Simon Horman (1):
      libata: do not limit R-Car SATA driver to shmobile

Tejun Heo (2):
      libata: skip SRST for all SIMG [34]7x port-multipliers
      Merge branch 'libata/for-3.10-fixes' into libata/for-3.11

Vincent Pelletier (1):
      libata: Add atapi_dmadir force flag

 .../devicetree/bindings/ata/ahci-platform.txt      |   5 +
 Documentation/kernel-parameters.txt                |   2 +
 arch/arm/boot/dts/ecx-common.dtsi                  |   2 +
 drivers/ata/Kconfig                                |   1 -
 drivers/ata/acard-ahci.c                           |   4 +-
 drivers/ata/ahci.c                                 |  11 +-
 drivers/ata/ahci.h                                 |   2 +
 drivers/ata/ahci_platform.c                        |   1 +
 drivers/ata/ata_piix.c                             |   8 +-
 drivers/ata/libahci.c                              |  26 ++-
 drivers/ata/libata-core.c                          |   9 +-
 drivers/ata/libata-pmp.c                           |  33 ++--
 drivers/ata/libata-scsi.c                          |  37 ++---
 drivers/ata/libata-transport.c                     |   4 +-
 drivers/ata/libata-zpodd.c                         |   7 +-
 drivers/ata/pata_ali.c                             |   2 +-
 drivers/ata/pata_amd.c                             |   2 +-
 drivers/ata/pata_arasan_cf.c                       |   2 +-
 drivers/ata/pata_artop.c                           |   2 +-
 drivers/ata/pata_at91.c                            |   2 +-
 drivers/ata/pata_atp867x.c                         |   2 +-
 drivers/ata/pata_bf54x.c                           |  10 +-
 drivers/ata/pata_cmd640.c                          |   2 +-
 drivers/ata/pata_cmd64x.c                          |   2 +-
 drivers/ata/pata_cs5520.c                          |   4 +-
 drivers/ata/pata_cs5530.c                          |   2 +-
 drivers/ata/pata_hpt366.c                          |   2 +-
 drivers/ata/pata_hpt3x3.c                          |   2 +-
 drivers/ata/pata_imx.c                             |   2 +-
 drivers/ata/pata_it821x.c                          |   2 +-
 drivers/ata/pata_macio.c                           |   6 +-
 drivers/ata/pata_mpc52xx.c                         |   4 +-
 drivers/ata/pata_ninja32.c                         |   2 +-
 drivers/ata/pata_ns87415.c                         |   2 +-
 drivers/ata/pata_pdc2027x.c                        |   2 +-
 drivers/ata/pata_pxa.c                             |   2 +-
 drivers/ata/pata_rdc.c                             |   2 +-
 drivers/ata/pata_rz1000.c                          |   2 +-
 drivers/ata/pata_serverworks.c                     |   2 +-
 drivers/ata/pata_sil680.c                          |   2 +-
 drivers/ata/pata_sis.c                             |   2 +-
 drivers/ata/pata_sl82c105.c                        |   2 +-
 drivers/ata/pata_triflex.c                         |   2 +-
 drivers/ata/pata_via.c                             |   2 +-
 drivers/ata/sata_fsl.c                             |  14 +-
 drivers/ata/sata_highbank.c                        | 181 ++++++++++++++++++++-
 drivers/ata/sata_inic162x.c                        |   2 +-
 drivers/ata/sata_nv.c                              |   2 +-
 drivers/ata/sata_rcar.c                            | 138 ++++++++--------
 drivers/ata/sata_sil.c                             |   2 +-
 drivers/ata/sata_sil24.c                           |   2 +-
 drivers/scsi/ipr.c                                 |   1 -
 include/linux/libata.h                             |   5 +
 53 files changed, 388 insertions(+), 185 deletions(-)

Thanks.

-- 
tejun
