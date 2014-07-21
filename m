Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbaGUMRr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 08:17:47 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:57996 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036AbaGUMRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 08:17:46 -0400
Date: Mon, 21 Jul 2014 08:17:40 -0400
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>
Subject: [GIT PULL] libata fixes for v3.16-rc6
Message-ID: <20140721121740.GB12921@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Late libata fixes.

The most important one is from Kevin Hao which makes sure that libata
only allocates tags inside the max tag number the controller supports.
libata always had this problem but the recent tag allocation change
and addition of support for sata_fsl which only supports queue depth
of 16 exposed the issue.

Hans de Goede agreed to become the maintainer of libahci_platform
which is under higher than usual development pressure from all the new
controllers popping up from the ARM world.

Thanks.

The following changes since commit 2a0bdff6b958d1b2523d2754b6cd5e0ea4053016:

  ahci_xgene: fix the dma state machine lockup for the IDENTIFY DEVICE PIO mode command. (2014-07-08 11:46:05 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata.git 

for you to fetch changes up to b32bfc06aefab61acc872dec3222624e6cd867ed:

  ahci: add support for the Promise FastTrak TX8660 SATA HBA (ahci mode) (2014-07-18 18:00:50 -0400)

----------------------------------------------------------------
Alexey Asemov (1):
      libata: EH should handle AMNF error condition as a media error

Andrey Utkin (1):
      drivers/ata/pata_ep93xx.c: use signed int type for result of platform_get_irq()

Hans de Goede (1):
      MAINTAINERS: Add Hans de Goede as ahci-platform maintainer

Kevin Hao (1):
      libata: support the ata host which implements a queue depth less than 32

Romain Degez (1):
      ahci: add support for the Promise FastTrak TX8660 SATA HBA (ahci mode)

 MAINTAINERS               | 10 ++++++++++
 drivers/ata/ahci.c        |  1 +
 drivers/ata/libata-core.c | 22 +++++++++++++++++++---
 drivers/ata/libata-eh.c   |  9 +++++----
 drivers/ata/pata_ep93xx.c |  2 +-
 5 files changed, 36 insertions(+), 8 deletions(-)

-- 
tejun
