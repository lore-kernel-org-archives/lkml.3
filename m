Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231AbaJHOqN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 10:46:13 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:43748 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbaJHOqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 10:46:10 -0400
Date: Wed, 8 Oct 2014 10:46:07 -0400
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [GIT PULL] libata changes for v3.18-rc1
Message-ID: <20141008144607.GB8184@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

AHCI is getting per-port irq handling and locks for better
scalability.  The gain is not huge but measureable with multiple high
iops devices connected to the same host; however, the value of
threaded IRQ handling seems negligible for AHCI and it likely will
revert to non-threaded handling soon.

Another noteworthy change is George Spelvin's "libata: Un-break ATA
blacklist".  During 3.17 devel cycle, the libata blacklist glob
matching got generalized and rewritten; unfortunately, the patch
forgot to swap arguments to match the new match function and ended up
breaking blacklist matching completely.  It got noticed only a couple
days ago so it couldn't make for-3.17-fixes either.  :(

Other than the above two, nothing too interesting - the usual cleanup
churns and device-specific changes.

Thanks.

The following changes since commit 88ec63d6f85ccf40988ddae8b430dcb07355b29b:

  Merge tag 'scsi-misc' of git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi (2014-08-15 18:28:58 -0600)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata.git for-3.18

for you to fetch changes up to 37017ac6849e772e67dd187ba2fbd056c4afa533:

  pata_serverworks: disable 64-KB DMA transfers on Broadcom OSB4 IDE Controller (2014-10-07 17:10:14 -0400)

----------------------------------------------------------------
Alexander Gordeev (8):
      AHCI: Cleanup checking of multiple MSIs/SLM modes
      AHCI: Pass SCSI host template as arg to ahci_host_activate()
      AHCI: Move ahci_host_activate() function to libahci.c
      AHCI: Move host activation code into ahci_host_activate()
      AHCI: Make few function names more descriptive
      AHCI: Do not read HOST_IRQ_STAT reg in multi-MSI mode
      AHCI: Optimize single IRQ interrupt processing
      AHCI: Do not acquire ata_host::lock from single IRQ handler

Alexander Shiyan (3):
      libata: Use dev_name() for request_irq() to distinguish devices
      pata_of_platform: Remove "electra-ide" quirk
      pata_platform: Remove useless irq_flags field

Bartlomiej Zolnierkiewicz (1):
      ata: remove deprecated struct ahci_platform_data

Fabio Estevam (2):
      libahci_platform: Staticize ahci_platform_<en/dis>able_phys()
      ata: pata_imx: Use the SIMPLE_DEV_PM_OPS() macro

George Spelvin (1):
      libata: Un-break ATA blacklist

Joe Perches (1):
      libata: change ata_<foo>_printk routines to return void

Kumar Gala (2):
      ahci-platform: Bump max number of clocks to 5
      ata: qcom: Add device tree bindings information

Mathias Krause (1):
      ahci: ahci_p5wdh_workaround - constify DMI table

Ondrej Zary (1):
      libata-sff: Fix controllers with no ctl port

Scott Carter (1):
      pata_serverworks: disable 64-KB DMA transfers on Broadcom OSB4 IDE Controller

Suman Tripathi (1):
      ahci_xgene: Fix the error print invalid resource for APM X-Gene SoC AHCI SATA Host Controller driver.

 .../devicetree/bindings/ata/qcom-sata.txt          |  48 +++++
 arch/blackfin/mach-bf537/boards/cm_bf537e.c        |   3 +-
 arch/blackfin/mach-bf537/boards/cm_bf537u.c        |   3 +-
 arch/blackfin/mach-bf537/boards/stamp.c            |   3 +-
 arch/blackfin/mach-bf537/boards/tcm_bf537.c        |   3 +-
 arch/blackfin/mach-bf561/boards/cm_bf561.c         |   3 +-
 drivers/ata/acard-ahci.c                           |   3 +-
 drivers/ata/ahci.c                                 |  82 +--------
 drivers/ata/ahci.h                                 |  10 +-
 drivers/ata/ahci_platform.c                        |  18 +-
 drivers/ata/ahci_xgene.c                           |  10 +-
 drivers/ata/libahci.c                              | 195 ++++++++++++++-------
 drivers/ata/libahci_platform.c                     |  32 +---
 drivers/ata/libata-core.c                          |  41 ++---
 drivers/ata/libata-sff.c                           |  20 +--
 drivers/ata/pata_imx.c                             |   9 +-
 drivers/ata/pata_of_platform.c                     |  24 +--
 drivers/ata/pata_platform.c                        |   4 +-
 drivers/ata/pata_serverworks.c                     |  13 +-
 drivers/ata/sata_highbank.c                        |   3 +-
 include/linux/ahci_platform.h                      |  13 --
 include/linux/ata_platform.h                       |   5 -
 include/linux/libata.h                             |  12 +-
 23 files changed, 259 insertions(+), 298 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ata/qcom-sata.txt

-- 
tejun
