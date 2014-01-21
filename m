Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076AbaAUKQw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 05:16:52 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:54204 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122AbaAUKQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 05:16:49 -0500
Date: Tue, 21 Jan 2014 05:16:43 -0500
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [GIT PULL] libata changes for v3.14-rc1
Message-ID: <20140121101643.GD6928@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Support for some new embedded controllers.  A couple late (<= a week)
fixes have stable cc'd and one patch ("SATA: MV: Add support for the
optional PHYs") got committed yesterday because otherwise the
resulting kernel would fail boot on an embedded board due to
interdependent changes in its platform tree.  Other than that, nothing
too noteworthy.

The following changes since commit 55c82a6c2a513de1d8a20c3b3a769129a1a14d50:

  sata_sis: missing PM support (2014-01-01 15:14:40 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata.git for-3.14

for you to fetch changes up to b7db4f2e15603c394da56a0536a33669f4c87c4f:

  SATA: MV: Add support for the optional PHYs (2014-01-20 07:46:15 -0500)

Thanks.
----------------------------------------------------------------
Andrew Lunn (1):
      SATA: MV: Add support for the optional PHYs

Fengguang Wu (1):
      ahci: imx: ahci_imx_softreset() can be static

Hans de Goede (1):
      sata-highbank: Remove unnecessary ahci_platform.h include

James Laird (1):
      ahci: mcp89: enter AHCI mode under Apple BIOS emulation

Jingoo Han (1):
      ata: pata_samsung_cf: Use devm_ioremap_resource()

Levente Kurusa (1):
      ata: libata-eh: Remove unnecessary snprintf arithmetic

Lior Amsalem (1):
      ata: sata_mv: fix disk hotplug for Armada 370/XP SoCs

Marek Vasut (2):
      ahci: imx: Pull out the clock enable/disable calls
      ahci: imx: Add i.MX53 support

Rashika Kheria (2):
      drivers: ata: Mark the function ahci_init_interrupts() as static in ahci.c
      drivers: ata: Mark the function as static in libahci.c

Sachin Kamat (3):
      ata: pata_samsung_cf: Move plat/regs-ata.h to drivers/ata
      ata: pata_samsung_cf: Merge pata_samsung_cf.h into pata_samsung_cf.c
      ata: pata_samsung_cf: Remove unused macros

Simon Guinot (2):
      ata: sata_mv: introduce compatible string "marvell, armada-370-sata"
      ARM: mvebu: update the SATA compatible string for Armada 370/XP

Tejun Heo (3):
      libata: Merge branch 'for-3.13-fixes' into for-3.14
      Merge branch 'for-3.13-fixes' into for-3.14
      libata: disable LPM for some WD SATA-I devices

Valentine Barshak (2):
      sata_rcar: Add R-Car Gen2 SATA PHY support
      libata, dt: Document sata_rcar bindings

Wei Yongjun (1):
      ahci: imx: fix the error handling in imx_ahci_probe()

 Documentation/devicetree/bindings/ata/marvell.txt  |   2 +-
 .../devicetree/bindings/ata/sata_rcar.txt          |  18 ++
 arch/arm/boot/dts/armada-370-xp.dtsi               |   2 +-
 arch/arm/plat-samsung/include/plat/regs-ata.h      |  56 -----
 drivers/ata/ahci.c                                 |  62 +++++-
 drivers/ata/ahci_imx.c                             | 242 +++++++++++++--------
 drivers/ata/ata_generic.c                          |   7 -
 drivers/ata/libahci.c                              |   4 +-
 drivers/ata/libata-core.c                          |  27 +++
 drivers/ata/libata-eh.c                            |   5 +-
 drivers/ata/libata-scsi.c                          |  18 +-
 drivers/ata/pata_samsung_cf.c                      |  43 ++--
 drivers/ata/sata_highbank.c                        |   1 -
 drivers/ata/sata_mv.c                              |  52 +++++
 drivers/ata/sata_rcar.c                            | 118 ++++++++--
 include/linux/libata.h                             |   2 +
 16 files changed, 458 insertions(+), 201 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ata/sata_rcar.txt
 delete mode 100644 arch/arm/plat-samsung/include/plat/regs-ata.h

--
tejun
