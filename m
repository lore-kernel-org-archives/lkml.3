Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757677AbaLJQyD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 11:54:03 -0500
Received: from mail-qg0-f53.google.com ([209.85.192.53]:55515 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755312AbaLJQyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 11:54:00 -0500
Date: Wed, 10 Dec 2014 11:53:57 -0500
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [GIT PULL] libata changes for v3.19-rc1
Message-ID: <20141210165357.GD6294@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The only interesting piece is the support for shingled drives.  The
changes in libata layer are minimal.  All it does is identifying the
new class of device and report upwards accordingly.

Thanks.

The following changes since commit 9a23c1d6f0f5dbac4c9b73fa6cea7c9ee3d29074:

  ahci: fix AHCI parameters not taken into account (2014-11-04 12:56:25 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata.git for-3.19

for you to fetch changes up to 2ba520f0cd65c2e688f8beb495bb6634a61ee17b:

  libata: Remove FIXME comment in atapi_request_sense() (2014-12-04 12:58:50 -0500)

----------------------------------------------------------------
Geert Uytterhoeven (1):
      sata_rcar: Document deprecated "renesas,rcar-sata"

Hannes Reinecke (3):
      libsas: use ata_dev_classify()
      libata: Implement ATA_DEV_ZAC
      libata-scsi: Update SATL for ZAC drives

Hans de Goede (1):
      ahci_sunxi: Make AHCI_HFLAG_NO_PMP flag configurable with a module option

Nicholas Krause (1):
      libata: Remove FIXME comment in atapi_request_sense()

Valentine Barshak (1):
      sata_rcar: Add clocks to sata_rcar bindings

 .../devicetree/bindings/ata/sata_rcar.txt          | 11 ++--
 drivers/ata/ahci_sunxi.c                           | 16 +++++-
 drivers/ata/libata-core.c                          | 20 +++++--
 drivers/ata/libata-eh.c                            |  7 ++-
 drivers/ata/libata-scsi.c                          | 31 ++++++++--
 drivers/ata/libata-transport.c                     |  1 +
 drivers/scsi/aic94xx/aic94xx_task.c                | 10 ++--
 drivers/scsi/isci/request.c                        |  4 +-
 drivers/scsi/libsas/sas_ata.c                      | 66 ++++------------------
 drivers/scsi/mvsas/mv_sas.c                        |  4 +-
 drivers/scsi/pm8001/pm8001_hwi.c                   |  2 +-
 drivers/scsi/pm8001/pm80xx_hwi.c                   |  2 +-
 include/linux/libata.h                             |  6 +-
 include/scsi/libsas.h                              | 11 +---
 14 files changed, 98 insertions(+), 93 deletions(-)

-- 
tejun
