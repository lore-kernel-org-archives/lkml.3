Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab3GIV2I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 17:28:08 -0400
Received: from mout.gmx.net ([212.227.17.22]:64868 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752843Ab3GIV2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 17:28:06 -0400
Date: Tue, 9 Jul 2013 23:28:00 +0200
From: Helge Deller <deller@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] parisc updates for v3.11
Message-ID: <20130709212800.GA16807@p100.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V03:K0:F4GtQIcHDlUHbmxGyo/b12+a3IEfXbTESGIYIdiE21CsVwupY04
 ex8dHjlvK/sB353k0xegjCZWBwFvNreg+WZ0jdXcMNsh0mGWctavJEcmoiv1Olg1t/NPQl0
 koBdap44sReWe5CAeHd0iWi0RhukBQ6upw/1OKAOuC3DptWzo0EV/6e02MU03wqIYFkOY3+
 CZl5bexz2gEnsRMknSKzw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the latest parisc updates from

  git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux.git parisc-for-3.11

PA-RISC updates for v3.11 include a gcc miscompilation fix,
gzip-compressed vmlinuz support, a fix in the PCI code for ATI FireGL
support on c8000 machines, a fix to prevent that %sr1 is being clobbered
and a few smaller optimizations and documentation updates.

Thanks,
Helge

----------------------------------------------------------------
Helge Deller (6):
      parisc: fix LMMIO mismatch between PAT length and MASK register
      parisc: more capabilities info in /proc/cpuinfo
      parisc: document the shadow registers
      parisc: switch to gzip-compressed vmlinuz kernel
      parisc: optimize mtsp(0,sr) inline assembly
      parisc: Fix gcc miscompilation in pa_memcpy()

John David Anglin (1):
      parisc: Ensure volatile space register %sr1 is not clobbered

 Documentation/parisc/registers          |  8 ++++
 arch/parisc/Makefile                    | 15 +++++--
 arch/parisc/defpalo.conf                |  8 ++--
 arch/parisc/include/asm/special_insns.h |  9 ++--
 arch/parisc/include/asm/tlbflush.h      |  5 ++-
 arch/parisc/install.sh                  |  6 +--
 arch/parisc/kernel/cache.c              |  2 +-
 arch/parisc/kernel/processor.c          | 19 ++++++--
 arch/parisc/lib/memcpy.c                | 79 +++++++++++++++++++++------------
 drivers/parisc/lba_pci.c                | 56 +++++++++++++++++++++++
 10 files changed, 158 insertions(+), 49 deletions(-)
