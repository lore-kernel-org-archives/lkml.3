Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933647Ab3FRVkC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 17:40:02 -0400
Received: from mout.gmx.net ([212.227.15.18]:50227 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933078Ab3FRVkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 17:40:00 -0400
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX1/Dl91i5ZnDa43yWp37muInrxaUg117zZRpd3VxXl
	zqmk2oDPM/Y66s
Date: Tue, 18 Jun 2013 23:39:56 +0200
From: Helge Deller <deller@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] parisc updates for v3.10
Message-ID: <20130618213956.GA20451@p100.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the latest parisc architecture fixes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux.git parisc-3.10

It contains a kernel segfault fix when reading /proc/kpageflags or /proc/kpagecount,
two fixes for the serial port and PCI graphic card support on C8000 workstations
and a fix to use unshadowed registers for flushing D- and I-caches.


This patchset touches parisc-specific source files only.

Thanks,
Helge

----------------------------------------------------------------
Helge Deller (1):
      parisc: fix kernel BUG at arch/parisc/include/asm/mmzone.h:50 (part 2)

John David Anglin (1):
      parisc: Use unshadowed index register for flush instructions in flush_dcache_page_asm and flush_icache_page_asm

Thomas Bogendoerfer (2):
      parisc: fix serial ports on C8000 workstation
      parisc: provide pci_mmap_page_range() for parisc

 arch/parisc/include/asm/mmzone.h   |  4 +-
 arch/parisc/include/asm/pci.h      |  5 +++
 arch/parisc/kernel/hardware.c      |  1 +
 arch/parisc/kernel/pacache.S       | 76 +++++++++++++++++++-------------------
 arch/parisc/kernel/pci.c           | 27 ++++++++++++++
 arch/parisc/mm/init.c              |  2 +-
 drivers/parisc/iosapic.c           | 66 +++++++++++++++++++++++++++++++++
 drivers/tty/serial/8250/8250_gsc.c | 10 ++++-
 8 files changed, 149 insertions(+), 42 deletions(-)
