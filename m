Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070AbaDWOtk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 10:49:40 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:49404 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755124AbaDWOtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 10:49:36 -0400
Date: Wed, 23 Apr 2014 10:49:33 -0400
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] libata fixes for v3.15-rc2
Message-ID: <20140423144933.GE4781@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

libata fixes for v3.15-rc2.  Dan updated tag allocation to accomodate
devices which choke when tags jump back and forth.  Quite a few ahci
MSI related fixes.  A couple config dependency fixes and other misc
fixes.

The following changes since commit b33ce442993865180292df2a314ee5251ba38b50:

  Merge branch 'for-3.15/drivers' of git://git.kernel.dk/linux-block (2014-04-01 19:43:53 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata.git for-3.15-fixes

for you to fetch changes up to 8a4aeec8d2d6a3edeffbdfae451cdf05cbf0fefd:

  libata/ahci: accommodate tag ordered controllers (2014-04-18 15:56:03 -0400)

Thanks.

----------------------------------------------------------------
Alexander Gordeev (3):
      ahci: Ensure "MSI Revert to Single Message" mode is not enforced
      ahci: Use pci_enable_msi_exact() instead of pci_enable_msi_range()
      ahci: Do not receive interrupts sent by dummy ports

Bartlomiej Zolnierkiewicz (3):
      pata_at91: fix ata_host_activate() failure handling
      pata_arasan_cf: fix ata_host_activate() failure handling
      pata_samsung_cf: fix ata_host_activate() failure handling

Dan Williams (1):
      libata/ahci: accommodate tag ordered controllers

David Milburn (1):
      ahci: do not request irq for dummy port

Jean Delvare (1):
      ata: fix i.MX AHCI driver dependencies

Martin K. Petersen (1):
      libata: Update queued trim blacklist for M5x0 drives

Tejun Heo (1):
      libata: make AHCI_XGENE depend on PHY_XGENE

 drivers/ata/Kconfig           |  5 ++---
 drivers/ata/ahci.c            | 35 +++++++++++++++++++++--------------
 drivers/ata/ahci.h            |  1 +
 drivers/ata/libata-core.c     | 27 +++++++++++++++++----------
 drivers/ata/pata_arasan_cf.c  |  7 +++++--
 drivers/ata/pata_at91.c       | 11 ++++++-----
 drivers/ata/pata_samsung_cf.c | 10 +++++++---
 include/linux/libata.h        |  1 +
 8 files changed, 60 insertions(+), 37 deletions(-)

-- 
tejun
