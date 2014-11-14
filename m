Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161943AbaKNUno (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 15:43:44 -0500
Received: from mail-qg0-f54.google.com ([209.85.192.54]:39396 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754377AbaKNUnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 15:43:42 -0500
Date: Fri, 14 Nov 2014 15:43:39 -0500
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [GIT PULL] libata fixes for v3.18-rc4
Message-ID: <20141114204339.GJ25889@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

libata fixes for v3.18-rc4.

The most notable is the revert of lock splitting optimization in ahci.
This also made the IRQ handling threaded even when there's only one
IRQ in use.  The conversion missed IRFQ_SHARED leading to screaming
IRQs problem in some cases and the threaded IRQ handling showed
performance regression in some LKP test cases.  The changes are
reverted for now.  It'll probably be retried once threaded IRQ
handling is removed from ahci.

Other than that, there's one fix for ahci and several patches adding
device IDs.

Thanks.

The following changes since commit cac7f2429872d3733dc3f9915857b1691da2eb2f:

  Linux 3.18-rc2 (2014-10-26 16:48:41 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata.git for-3.18-fixes

for you to fetch changes up to 9a23c1d6f0f5dbac4c9b73fa6cea7c9ee3d29074:

  ahci: fix AHCI parameters not taken into account (2014-11-04 12:56:25 -0500)

----------------------------------------------------------------
Antoine Tenart (1):
      ahci: fix AHCI parameters not taken into account

James Ralston (1):
      ahci: Add Device IDs for Intel Sunrise Point PCH

Koji Matsuoka (1):
      ata: sata_rcar: Add r8a7793 device support

Simon Horman (1):
      ata: sata_rcar: Disable DIPM mode for r8a7790 ES1

Tejun Heo (3):
      Revert "AHCI: Do not acquire ata_host::lock from single IRQ handler"
      Revert "AHCI: Optimize single IRQ interrupt processing"
      ahci: disable MSI instead of NCQ on Samsung pci-e SSDs on macbooks

 .../devicetree/bindings/ata/sata_rcar.txt          |  6 +-
 drivers/ata/ahci.c                                 | 28 +++++---
 drivers/ata/libahci.c                              | 78 +++++-----------------
 drivers/ata/sata_rcar.c                            | 15 +++++
 4 files changed, 55 insertions(+), 72 deletions(-)

-- 
tejun
