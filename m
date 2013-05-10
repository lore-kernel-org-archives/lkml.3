Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172Ab3EJIP5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 04:15:57 -0400
Received: from nskntqsrv03p.mx.bigpond.com ([61.9.168.237]:20768 "EHLO
	nskntqsrv03p.mx.bigpond.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751561Ab3EJIPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 04:15:53 -0400
X-Greylist: delayed 3672 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 May 2013 04:15:52 EDT
X-Authority-Analysis: v=2.0 cv=FNSZNpUs c=1 sm=1
 a=tpHzvNDyw14p4wpd1xf5Bw==:17 a=4QTP58DfdrcA:10 a=aFTPlZ8mLXYA:10
 a=abLpnCq0AAAA:8 a=H5rnqBSDAAAA:8 a=YvqQfTbJdaQA:10 a=VwQbUJbxAAAA:8
 a=mVMJ6PgCaTTKqff_vy4A:9 a=U-mUTV892a2tCXzE:21 a=g6FUtOpjfvvkjl2y:21
 a=tpHzvNDyw14p4wpd1xf5Bw==:117
Date: Fri, 10 May 2013 17:13:58 +1000
From: Greg Ungerer <gerg@uclinux.org>
Message-Id: <201305100713.r4A7Dwq6031930@goober.accelcon.com>
CC: <linux-kernel@vger.kernel.org>, <linux-m68k@vger.kernel.org>,
        <uclinux-dev@uclinux.org>, <geert@linux-m68k.org>
Subject: [git pull] m68knommu arch fixes for 3.10
To: <torvalds@linux-foundation.org>
X-Mailer: mail (GNU Mailutils 2.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Can you please pull the m68knommu git tree, for-next branch.

The bulk of the changes are generalizing the ColdFire v3 core support and
adding in 537x CPU support. Also a couple of other bug fixes, one to fix
a reintroduction of a past bug in the romfs filesystem nommu support.

Regards
Greg




The following changes since commit 60d509fa6a9c4653a86ad830e4c4b30360b23f0e:

  Linux 3.9-rc8 (2013-04-21 14:38:45 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-next

for you to fetch changes up to 2842e5b00e99b30404f9af1c1b367c8e467b5c6c:

  m68knommu: enable Timer on coldfire 532x (2013-04-29 09:17:59 +1000)

----------------------------------------------------------------
Greg Ungerer (8):
      romfs: fix nommu map length to keep inside filesystem
      m68k: remove unused asm/dbg.h
      m68knommu: create and use a common M53xx ColdFire class of CPUs
      m68knommu: make ColdFire M532x platform support more v3 generic
      m68knommu: add support for the ColdFire 537x family of CPUs
      m68knommu: add support for configuring a Freescale M5373EVB board
      m68knommu: fix ColdFire 5373/5329 QSPI base address
      m68knommu: enable Timer on coldfire 532x

Paul Bolle (1):
      m68k: clean up unused "config ROMVECSIZE"

Stany MARCEL (1):
      m68k: Set ColdFire ACR1 cache mode depending on kernel configuration

 arch/m68k/Kconfig.cpu                            | 12 ++++++++++++
 arch/m68k/Kconfig.machine                        | 16 +++++++---------
 arch/m68k/Makefile                               |  1 +
 arch/m68k/include/asm/dbg.h                      |  6 ------
 arch/m68k/include/asm/dma.h                      |  2 +-
 arch/m68k/include/asm/m53xxacr.h                 |  4 ++--
 arch/m68k/include/asm/{m532xsim.h => m53xxsim.h} | 12 ++++++------
 arch/m68k/include/asm/m54xxacr.h                 |  7 ++++++-
 arch/m68k/include/asm/mcfgpio.h                  | 10 +++++-----
 arch/m68k/include/asm/mcfsim.h                   |  4 ++--
 arch/m68k/include/asm/mcftimer.h                 |  2 +-
 arch/m68k/platform/coldfire/Makefile             |  2 +-
 arch/m68k/platform/coldfire/{m532x.c => m53xx.c} | 23 +++++++++++------------
 arch/m68k/platform/coldfire/timers.c             |  2 +-
 drivers/tty/serial/68328serial.c                 |  1 -
 fs/romfs/mmap-nommu.c                            |  5 ++++-
 16 files changed, 60 insertions(+), 49 deletions(-)
 delete mode 100644 arch/m68k/include/asm/dbg.h
 rename arch/m68k/include/asm/{m532xsim.h => m53xxsim.h} (99%)
 rename arch/m68k/platform/coldfire/{m532x.c => m53xx.c} (98%)
