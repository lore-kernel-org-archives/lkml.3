Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbaJNBD6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 21:03:58 -0400
Received: from nskntqsrv01p.mx.bigpond.com ([61.9.168.231]:54351 "EHLO
	nskntqsrv01p.mx.bigpond.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752985AbaJNBDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 21:03:55 -0400
X-Greylist: delayed 1002 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Oct 2014 21:03:54 EDT
X-Authority-Analysis: v=2.0 cv=RsdH3VaK c=1 sm=1
 a=tpHzvNDyw14p4wpd1xf5Bw==:17 a=aFTPlZ8mLXYA:10 a=abLpnCq0AAAA:8
 a=2_P8teLBAAAA:8 a=VwQbUJbxAAAA:8 a=TedvEm6AaBotNT-kaZ0A:9
 a=tpHzvNDyw14p4wpd1xf5Bw==:117
Date: Tue, 14 Oct 2014 10:46:54 +1000
From: Greg Ungerer <gerg@uclinux.org>
Message-Id: <201410140046.s9E0ksQ1001846@goober.accelecon.com>
To: torvalds@linux-foundation.org
Subject: [git pull] m68knommu arch fixes for 3.18
Cc: linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org,
        uclinux-dev@uclinux.org, geert@linux-m68k.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Can you please pull the m68knommu git tree, for-next branch.

The major change is to remove the arch/m68k/platform directory. The coldfire
(and other non-mmu m68k platform) code is moved to the arch/m68k level, making
them consistent with the traditional m68k platforms. A couple of other minor
miscellaneous fixes as well.

Regards
Greg



The following changes since commit fe82dcec644244676d55a1384c958d5f67979adb:

  Linux 3.17-rc7 (2014-09-28 14:29:07 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-next

for you to fetch changes up to e803d4bd31184b301a54352bb2c1a3fa93f80154:

  m68k: Fix typo 'COFNIG_MBAR' (2014-09-29 09:56:19 +1000)

----------------------------------------------------------------
Fabian Frederick (1):
      m68k/coldfire: remove second asm/mcfclk.h inclusion in m54xx.c

Greg Ungerer (8):
      m68k: move coldfire platform code
      m68k: fix crufty ColdFire intro comments
      m68k: move non-mmu 68000 platform code
      m68k: move non-mmu 68360 platform code
      m68k: remove the unused arch/m68k/platform directory
      m68k: fix crufty 68000 and 68360 intro comments
      m68knommu: fix size of address field for 5272 interrupt controller
      m68knommu: add missing ioport_map() and ioport_unmap()

Paul Bolle (1):
      m68k: Fix typo 'COFNIG_MBAR'

 arch/m68k/{platform => }/68000/Makefile       |  0
 arch/m68k/{platform => }/68000/bootlogo-vz.h  |  0
 arch/m68k/{platform => }/68000/bootlogo.h     |  0
 arch/m68k/{platform => }/68000/entry.S        |  2 +-
 arch/m68k/{platform => }/68000/head.S         |  0
 arch/m68k/{platform => }/68000/ints.c         |  0
 arch/m68k/{platform => }/68000/m68328.c       |  0
 arch/m68k/{platform => }/68000/m68EZ328.c     |  0
 arch/m68k/{platform => }/68000/m68VZ328.c     |  0
 arch/m68k/{platform => }/68000/romvec.S       |  0
 arch/m68k/{platform => }/68000/timers.c       |  0
 arch/m68k/{platform => }/68360/Makefile       |  2 +-
 arch/m68k/{platform => }/68360/commproc.c     |  0
 arch/m68k/{platform => }/68360/config.c       |  2 +-
 arch/m68k/{platform => }/68360/entry.S        |  2 +-
 arch/m68k/{platform => }/68360/head-ram.S     |  5 ++---
 arch/m68k/{platform => }/68360/head-rom.S     |  5 ++---
 arch/m68k/{platform => }/68360/ints.c         |  2 +-
 arch/m68k/Makefile                            | 12 ++++++------
 arch/m68k/{platform => }/coldfire/Makefile    |  0
 arch/m68k/{platform => }/coldfire/cache.c     |  0
 arch/m68k/{platform => }/coldfire/clk.c       |  0
 arch/m68k/{platform => }/coldfire/device.c    |  0
 arch/m68k/{platform => }/coldfire/dma.c       |  0
 arch/m68k/{platform => }/coldfire/dma_timer.c |  0
 arch/m68k/{platform => }/coldfire/entry.S     |  2 +-
 arch/m68k/{platform => }/coldfire/firebee.c   |  0
 arch/m68k/{platform => }/coldfire/gpio.c      |  0
 arch/m68k/{platform => }/coldfire/head.S      |  0
 arch/m68k/{platform => }/coldfire/intc-2.c    |  0
 arch/m68k/{platform => }/coldfire/intc-5249.c |  0
 arch/m68k/{platform => }/coldfire/intc-525x.c |  0
 arch/m68k/{platform => }/coldfire/intc-5272.c |  2 +-
 arch/m68k/{platform => }/coldfire/intc-simr.c |  0
 arch/m68k/{platform => }/coldfire/intc.c      |  0
 arch/m68k/{platform => }/coldfire/m5206.c     |  2 +-
 arch/m68k/{platform => }/coldfire/m520x.c     |  2 +-
 arch/m68k/{platform => }/coldfire/m523x.c     |  2 +-
 arch/m68k/{platform => }/coldfire/m5249.c     |  2 +-
 arch/m68k/{platform => }/coldfire/m525x.c     |  2 +-
 arch/m68k/{platform => }/coldfire/m5272.c     |  2 +-
 arch/m68k/{platform => }/coldfire/m527x.c     |  4 ++--
 arch/m68k/{platform => }/coldfire/m528x.c     |  2 +-
 arch/m68k/{platform => }/coldfire/m5307.c     |  2 +-
 arch/m68k/{platform => }/coldfire/m53xx.c     |  0
 arch/m68k/{platform => }/coldfire/m5407.c     |  2 +-
 arch/m68k/{platform => }/coldfire/m5441x.c    |  0
 arch/m68k/{platform => }/coldfire/m54xx.c     |  3 +--
 arch/m68k/{platform => }/coldfire/mcf8390.c   |  0
 arch/m68k/{platform => }/coldfire/nettel.c    |  0
 arch/m68k/{platform => }/coldfire/pci.c       |  0
 arch/m68k/{platform => }/coldfire/pit.c       |  0
 arch/m68k/{platform => }/coldfire/reset.c     |  0
 arch/m68k/{platform => }/coldfire/sltimers.c  |  0
 arch/m68k/{platform => }/coldfire/timers.c    |  0
 arch/m68k/{platform => }/coldfire/vectors.c   |  2 +-
 arch/m68k/include/asm/io_no.h                 |  9 +++++++++
 arch/m68k/include/asm/m54xxpci.h              |  2 +-
 arch/m68k/platform/Makefile                   |  3 ---
 59 files changed, 40 insertions(+), 37 deletions(-)
 rename arch/m68k/{platform => }/68000/Makefile (100%)
 rename arch/m68k/{platform => }/68000/bootlogo-vz.h (100%)
 rename arch/m68k/{platform => }/68000/bootlogo.h (100%)
 rename arch/m68k/{platform => }/68000/entry.S (98%)
 rename arch/m68k/{platform => }/68000/head.S (100%)
 rename arch/m68k/{platform => }/68000/ints.c (100%)
 rename arch/m68k/{platform => }/68000/m68328.c (100%)
 rename arch/m68k/{platform => }/68000/m68EZ328.c (100%)
 rename arch/m68k/{platform => }/68000/m68VZ328.c (100%)
 rename arch/m68k/{platform => }/68000/romvec.S (100%)
 rename arch/m68k/{platform => }/68000/timers.c (100%)
 rename arch/m68k/{platform => }/68360/Makefile (81%)
 rename arch/m68k/{platform => }/68360/commproc.c (100%)
 rename arch/m68k/{platform => }/68360/config.c (98%)
 rename arch/m68k/{platform => }/68360/entry.S (98%)
 rename arch/m68k/{platform => }/68360/head-ram.S (99%)
 rename arch/m68k/{platform => }/68360/head-rom.S (99%)
 rename arch/m68k/{platform => }/68360/ints.c (98%)
 rename arch/m68k/{platform => }/coldfire/Makefile (100%)
 rename arch/m68k/{platform => }/coldfire/cache.c (100%)
 rename arch/m68k/{platform => }/coldfire/clk.c (100%)
 rename arch/m68k/{platform => }/coldfire/device.c (100%)
 rename arch/m68k/{platform => }/coldfire/dma.c (100%)
 rename arch/m68k/{platform => }/coldfire/dma_timer.c (100%)
 rename arch/m68k/{platform => }/coldfire/entry.S (98%)
 rename arch/m68k/{platform => }/coldfire/firebee.c (100%)
 rename arch/m68k/{platform => }/coldfire/gpio.c (100%)
 rename arch/m68k/{platform => }/coldfire/head.S (100%)
 rename arch/m68k/{platform => }/coldfire/intc-2.c (100%)
 rename arch/m68k/{platform => }/coldfire/intc-5249.c (100%)
 rename arch/m68k/{platform => }/coldfire/intc-525x.c (100%)
 rename arch/m68k/{platform => }/coldfire/intc-5272.c (99%)
 rename arch/m68k/{platform => }/coldfire/intc-simr.c (100%)
 rename arch/m68k/{platform => }/coldfire/intc.c (100%)
 rename arch/m68k/{platform => }/coldfire/m5206.c (96%)
 rename arch/m68k/{platform => }/coldfire/m520x.c (98%)
 rename arch/m68k/{platform => }/coldfire/m523x.c (97%)
 rename arch/m68k/{platform => }/coldfire/m5249.c (97%)
 rename arch/m68k/{platform => }/coldfire/m525x.c (97%)
 rename arch/m68k/{platform => }/coldfire/m5272.c (98%)
 rename arch/m68k/{platform => }/coldfire/m527x.c (97%)
 rename arch/m68k/{platform => }/coldfire/m528x.c (98%)
 rename arch/m68k/{platform => }/coldfire/m5307.c (97%)
 rename arch/m68k/{platform => }/coldfire/m53xx.c (100%)
 rename arch/m68k/{platform => }/coldfire/m5407.c (95%)
 rename arch/m68k/{platform => }/coldfire/m5441x.c (100%)
 rename arch/m68k/{platform => }/coldfire/m54xx.c (97%)
 rename arch/m68k/{platform => }/coldfire/mcf8390.c (100%)
 rename arch/m68k/{platform => }/coldfire/nettel.c (100%)
 rename arch/m68k/{platform => }/coldfire/pci.c (100%)
 rename arch/m68k/{platform => }/coldfire/pit.c (100%)
 rename arch/m68k/{platform => }/coldfire/reset.c (100%)
 rename arch/m68k/{platform => }/coldfire/sltimers.c (100%)
 rename arch/m68k/{platform => }/coldfire/timers.c (100%)
 rename arch/m68k/{platform => }/coldfire/vectors.c (96%)
 delete mode 100644 arch/m68k/platform/Makefile
