Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758428Ab3KHWGG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 17:06:06 -0500
Received: from mout.gmx.net ([212.227.17.21]:65250 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757975Ab3KHWGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 17:06:03 -0500
Date: Fri, 8 Nov 2013 23:05:58 +0100
From: Helge Deller <deller@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] parisc updates for v3.13
Message-ID: <20131108220558.GA1531@p100.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V03:K0:fqB4hCmOx7BH6QgZgdSuigYXLixh4J8m4B74r0afsDWe3QbZWtc
 6YkPM48MeM8QgFQVffMTEUevi6ZA5ZfiP8+la7xLhtRJMAk0SOcJQkJlPGBfj6Zo8+jdUu6
 zGKhGVTaoz3bFFjTS8hyfANMj1TiVz7Toof2jcbPvx6qSTjpD0PQdZw9fulrRCWBBBPa4XC
 WyOTk6iyQfSnUJ3+lUc8A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the parisc architecture updates for 3.13-rc1 from

  git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux.git parisc-3.13

which contains the following main features:

- a bugfix for sticon (parisc text console driver) to not crash the
  64bit kernel on machines with more than 4GB RAM
- added kernel audit support
- made udelay() implementation SMP-safe
- "make install" now does not depend on vmlinux
- added defconfigs for 32- and 64-kernels

Thanks,
Helge

----------------------------------------------------------------
Helge Deller (10):
      parisc: provide macro to create exception table entries
      parisc: add kernel audit feature
      parisc: make "make install" not depend on vmlinux
      parisc: make udelay() SMP-safe
      parisc: do not count IPI calls twice
      parisc: correctly display number of active CPUs
      parisc: implement full version of access_ok()
      parisc: signal fixup - SIGBUS vs. SIGSEGV
      parisc: sticon - unbreak on 64bit kernel
      parisc: add generic 32- and 64-bit defconfigs

Michael Opdenacker (1):
      parisc: remove duplicate define

 arch/parisc/Kconfig                         |   3 +
 arch/parisc/Makefile                        |  22 +-
 arch/parisc/configs/generic-32bit_defconfig | 328 ++++++++++++++++++++++++++
 arch/parisc/configs/generic-64bit_defconfig | 346 ++++++++++++++++++++++++++++
 arch/parisc/include/asm/assembly.h          |  12 +
 arch/parisc/include/asm/delay.h             |  41 +---
 arch/parisc/include/asm/hardirq.h           |   1 -
 arch/parisc/include/asm/ptrace.h            |   4 +
 arch/parisc/include/asm/thread_info.h       |   4 +-
 arch/parisc/include/asm/uaccess.h           |  53 ++++-
 arch/parisc/install.sh                      |  44 +++-
 arch/parisc/kernel/Makefile                 |   4 +-
 arch/parisc/kernel/audit.c                  |  81 +++++++
 arch/parisc/kernel/compat_audit.c           |  40 ++++
 arch/parisc/kernel/irq.c                    |   4 -
 arch/parisc/kernel/ptrace.c                 |  26 ++-
 arch/parisc/kernel/setup.c                  |   8 +-
 arch/parisc/kernel/smp.c                    |   5 -
 arch/parisc/kernel/syscall.S                |   6 +-
 arch/parisc/lib/Makefile                    |   2 +-
 arch/parisc/lib/delay.c                     |  73 ++++++
 arch/parisc/lib/lusercopy.S                 |  10 +-
 arch/parisc/math-emu/float.h                |   1 -
 arch/parisc/mm/fault.c                      |  24 +-
 drivers/video/console/sticore.c             | 166 ++++++++-----
 drivers/video/sticore.h                     |  62 ++++-
 drivers/video/stifb.c                       |  10 +-
 init/Kconfig                                |   2 +-
 28 files changed, 1214 insertions(+), 168 deletions(-)
 create mode 100644 arch/parisc/configs/generic-32bit_defconfig
 create mode 100644 arch/parisc/configs/generic-64bit_defconfig
 create mode 100644 arch/parisc/kernel/audit.c
 create mode 100644 arch/parisc/kernel/compat_audit.c
 create mode 100644 arch/parisc/lib/delay.c
