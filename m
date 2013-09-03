Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534Ab3ICOo7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 10:44:59 -0400
Received: from mail-yh0-f52.google.com ([209.85.213.52]:64092 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804Ab3ICOo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 10:44:57 -0400
Date: Tue, 3 Sep 2013 10:44:52 -0400
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [GIT PULL] libata changes for v3.12-rc1
Message-ID: <20130903144452.GI10522@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Two interesting changes.

* libata acpi handling has been restructured so that the association
  between ata devices and ACPI handles are less convoluted.  This
  change shouldn't change visible behavior.

* Queued TRIM support, which enables sending TRIM to the device
  without draining in-flight RW commands, is added.  Currently only
  enabled for ahci (and likely to stay that way for the foreseeable
  future).

Other changes are driver-specific updates / fixes.

Thanks.

The following changes since commit ad81f0545ef01ea651886dddac4bef6cec930092:

  Linux 3.11-rc1 (2013-07-14 15:18:27 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata.git for-3.12

for you to fetch changes up to 86a565e61bcb9574bae3b622799682fef2d855bb:

  libata: bugfix: Remove __le32 in ata_tf_to_fis() (2013-09-03 10:37:41 -0400)

----------------------------------------------------------------
Aaron Lu (3):
      libata: acpi: remove dead code for ata_acpi_(un)bind
      ata: acpi: rework the ata acpi bind support
      libata: acpi: Remove ata_dev_acpi_handle stub in libata.h

Ezequiel Garcia (2):
      sata_mv: Remove unneeded forward declaration
      sata_mv: Remove unneeded CONFIG_HAVE_CLK ifdefs

Jingoo Han (3):
      ata: use dev_get_platdata()
      ata: pata_arasan: Staticize local symbols
      ata: pata_samsung_cf: add missing __iomem annotation

Julia Lawall (1):
      drivers/ata/sata_rcar.c: simplify use of devm_ioremap_resource

Marc Carino (5):
      libata: Populate host-to-device FIS "auxiliary" field
      libata: Add H2D FIS "auxiliary" port flag
      libata: Add support for SEND/RECEIVE FPDMA QUEUED
      libata: Add support for queued DSM TRIM
      libata: bugfix: Remove __le32 in ata_tf_to_fis()

Mark Langsdorf (3):
      devicetree: create a separate binding description for sata_highbank
      sata, highbank: set tx_atten override bits
      sata, highbank: send extra clock cycles in SGPIO patterns

Rob Herring (1):
      sata highbank: enable 64-bit DMA mask when using LPAE

Sergei Shtylyov (1):
      libata: move 'struct ata_taskfile' and friends from ata.h to libata.h

 .../devicetree/bindings/ata/ahci-platform.txt      |  18 +-
 .../devicetree/bindings/ata/sata_highbank.txt      |  44 ++++
 drivers/ata/ahci.c                                 |   8 +
 drivers/ata/libata-acpi.c                          | 278 ++++++---------------
 drivers/ata/libata-core.c                          |  29 ++-
 drivers/ata/libata-scsi.c                          |  38 ++-
 drivers/ata/libata-transport.c                     |   2 +
 drivers/ata/libata-zpodd.c                         |  12 +-
 drivers/ata/libata.h                               |  19 +-
 drivers/ata/pata_acpi.c                            |   4 +-
 drivers/ata/pata_arasan_cf.c                       |   4 +-
 drivers/ata/pata_at32.c                            |   2 +-
 drivers/ata/pata_at91.c                            |   2 +-
 drivers/ata/pata_ixp4xx_cf.c                       |   4 +-
 drivers/ata/pata_octeon_cf.c                       |   2 +-
 drivers/ata/pata_platform.c                        |   2 +-
 drivers/ata/pata_pxa.c                             |   2 +-
 drivers/ata/pata_samsung_cf.c                      |  10 +-
 drivers/ata/sata_highbank.c                        |  74 +++++-
 drivers/ata/sata_mv.c                              |  26 +-
 drivers/ata/sata_rcar.c                            |   5 +-
 drivers/scsi/scsi_lib.c                            |  22 --
 include/linux/ata.h                                | 123 ++-------
 include/linux/libata.h                             | 120 ++++++++-
 24 files changed, 423 insertions(+), 427 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ata/sata_highbank.txt

-- 
tejun
