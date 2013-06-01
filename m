Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397Ab3FANaF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 09:30:05 -0400
Received: from mout.gmx.net ([212.227.17.21]:64516 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755406Ab3FAN35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 09:29:57 -0400
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX1/VDSJbQ7bV+SnJYM0Df9k+YQeNdwXTRWQyWiFvTC
	CEnHB9qIt1MWef
Date: Sat, 1 Jun 2013 15:29:52 +0200
From: Helge Deller <deller@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] parisc updates for v3.10-rc4
Message-ID: <20130601132952.GA26730@p100.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the latest changes for the parisc architecture.

They are available in the for-3.10 branch in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux.git for-3.10

Thanks!
Helge

----------------------------------------------------------------

This patcheset includes fixes for:
- the PCI/LBA which brings back the stifb graphics framebuffer console
- possible memory overflows in parisc kernel init code
- parport support on older GSC machines
- avoids that users by mistake enable PARPORT_PC_SUPERIO on parisc
- MAINTAINERS file list updates for parisc.

----------------------------------------------------------------
Bjorn Helgaas (1):
      parisc/PCI: Set type for LBA bus_num resource

Chen Gang (2):
      parisc: memory overflow, 'name' length is too short for using
      parisc: kernel: using strlcpy() instead of strcpy()

Helge Deller (5):
      parisc: fix kernel BUG at arch/parisc/include/asm/mmzone.h:50
      MAINTAINERS: update parisc architecture file list
      parisc/PCI: lba: fix: convert to pci_create_root_bus() for correct root bus resources (v2)
      parport_pc: disable PARPORT_PC_SUPERIO on parisc architecture
      parisc: parport0: fix this legacy no-device port driver!

Paul Bolle (1):
      parisc: rename "CONFIG_PA7100" to "CONFIG_PA7000"

 MAINTAINERS                      | 8 ++++++++
 arch/parisc/Makefile             | 2 +-
 arch/parisc/include/asm/mmzone.h | 5 +----
 arch/parisc/kernel/drivers.c     | 2 +-
 arch/parisc/kernel/setup.c       | 3 ++-
 drivers/parisc/lba_pci.c         | 9 +++++----
 drivers/parport/Kconfig          | 2 +-
 drivers/parport/parport_gsc.c    | 6 +++---
 drivers/parport/parport_gsc.h    | 2 +-
 9 files changed, 23 insertions(+), 16 deletions(-)
