Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814AbbATRIQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 12:08:16 -0500
Received: from mail-qg0-f47.google.com ([209.85.192.47]:35082 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862AbbATRIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 12:08:12 -0500
Date: Tue, 20 Jan 2015 12:08:04 -0500
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [GIT PULL] libata fixes for v3.19-rc5
Message-ID: <20150120170804.GC8684@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

* Bartlomiej will be co-maintaining PATA portion of libata.  git
  workflow will stay the same.

* sata_sil24 wasn't happy with tag ordered submission.  An option to
  restore the old tag allocation behavior is implemented for sil24.

* A very old race condition in PIO host state machine which can
  trigger BUG fixed.

* Other driver-specific changes.

Thanks.

The following changes since commit 97bf6af1f928216fd6c5a66e8a57bfa95a659672:

  Linux 3.19-rc1 (2014-12-20 17:08:50 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata.git for-3.19-fixes

for you to fetch changes up to ce7514526742c0898b837d4395f515b79dfb5a12:

  libata: prevent HSM state change race between ISR and PIO (2015-01-19 14:11:23 -0500)

----------------------------------------------------------------
Alexandre Belloni (1):
      ata: pata_at91: depend on !ARCH_MULTIPLATFORM

Andy Shevchenko (2):
      libata: export ata_get_cmd_descript()
      sata_dwc_460ex: fix resource leak on error path

Bartlomiej Zolnierkiewicz (1):
      ata: add MAINTAINERS entry for libata PATA drivers

Dan Williams (1):
      libata: allow sata_sil24 to opt-out of tag ordered submission

David Jeffery (1):
      libata: prevent HSM state change race between ISR and PIO

Gabriele Mazzotta (1):
      ahci: Use dev_info() to inform about the lack of Device Sleep support

James Ralston (1):
      ahci: Remove Device ID for Intel Sunrise Point PCH

Martin K. Petersen (1):
      libata: Whitelist SSDs that are known to properly return zeroes after TRIM

Suman Tripathi (2):
      ahci_xgene: Fix the endianess issue in APM X-Gene SoC AHCI SATA controller driver.
      ahci_xgene: Fix the DMA state machine lockup for the ATA_CMD_PACKET PIO mode command.

Tejun Heo (1):
      libata: clean up MAINTAINERS entries

 MAINTAINERS                  | 75 +++++++++++++++++++++++++-------------------
 drivers/ata/Kconfig          |  1 +
 drivers/ata/ahci.c           |  1 -
 drivers/ata/ahci_xgene.c     | 14 +++++----
 drivers/ata/libahci.c        |  2 +-
 drivers/ata/libata-core.c    | 36 ++++++++++++++++++---
 drivers/ata/libata-eh.c      |  1 +
 drivers/ata/libata-scsi.c    | 10 +++---
 drivers/ata/libata-sff.c     | 12 +++++++
 drivers/ata/sata_dwc_460ex.c | 26 +++++++--------
 drivers/ata/sata_sil24.c     |  2 +-
 include/linux/libata.h       |  2 ++
 12 files changed, 118 insertions(+), 64 deletions(-)

-- 
tejun
