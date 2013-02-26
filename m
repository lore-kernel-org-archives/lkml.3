Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760076Ab3BZBga (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 20:36:30 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:38035 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab3BZBg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 20:36:27 -0500
MIME-Version: 1.0
Date: Mon, 25 Feb 2013 17:36:25 -0800
Message-ID: <CAHTX3dKHh2R201J-amG6bM+nUBYudgh83mC_+peAenkPGwVw5Q@mail.gmail.com>
Subject: [GIT PULL] arch/microblaze changes for 3.9
From: Michal Simek <monstr@monstr.eu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull these microblaze changes to your tree.
After my discussion with Arnd I have also added there asm-generic io
patch which
is Acked by him and Geert.

Thanks,
Michal


The following changes since commit 836dc9e3fbbab0c30aa6e664417225f5c1fb1c39:

  Linux 3.8-rc7 (2013-02-09 08:20:39 +1100)

are available in the git repository at:

  git://git.monstr.eu/linux-2.6-microblaze.git next

for you to fetch changes up to 711e5b4520986380700e6f095608021cf087170e:

  asm-generic: io: Fix ioread16/32be and iowrite16/32be (2013-02-12
11:29:46 +0100)

----------------------------------------------------------------
Jason Wu (1):
      microblaze: Makefile clean

Lars-Peter Clausen (1):
      microblaze: Add .gitignore entries for auto-generated files

Michal Simek (5):
      microblaze: Fix strncpy_from_user macro
      microblaze: Add missing return from debugfs_tlb
      microblaze: Fix coding style issues
      microblaze: Do not use module.h in files which are not modules
      asm-generic: io: Fix ioread16/32be and iowrite16/32be

 arch/microblaze/Makefile                      |    9 +-
 arch/microblaze/boot/.gitignore               |    3 +
 arch/microblaze/include/asm/io.h              |    2 +-
 arch/microblaze/kernel/.gitignore             |    1 +
 arch/microblaze/kernel/cpu/cache.c            |  148 ++++++++++++-------------
 arch/microblaze/kernel/cpu/cpuinfo-pvr-full.c |   21 ++--
 arch/microblaze/kernel/cpu/cpuinfo.c          |   13 +--
 arch/microblaze/kernel/cpu/pvr.c              |    2 +-
 arch/microblaze/kernel/dma.c                  |    6 +-
 arch/microblaze/kernel/early_printk.c         |   17 ++-
 arch/microblaze/kernel/exceptions.c           |   27 ++---
 arch/microblaze/kernel/ftrace.c               |   44 ++++----
 arch/microblaze/kernel/heartbeat.c            |    2 +-
 arch/microblaze/kernel/intc.c                 |    4 +-
 arch/microblaze/kernel/kgdb.c                 |    2 +-
 arch/microblaze/kernel/microblaze_ksyms.c     |    2 +-
 arch/microblaze/kernel/module.c               |    5 +-
 arch/microblaze/kernel/process.c              |   24 ++--
 arch/microblaze/kernel/prom.c                 |    2 +-
 arch/microblaze/kernel/prom_parse.c           |    2 +-
 arch/microblaze/kernel/ptrace.c               |    2 +-
 arch/microblaze/kernel/setup.c                |   30 ++---
 arch/microblaze/kernel/signal.c               |    6 +-
 arch/microblaze/kernel/stacktrace.c           |    2 +-
 arch/microblaze/kernel/sys_microblaze.c       |    3 +-
 arch/microblaze/kernel/traps.c                |    8 +-
 arch/microblaze/kernel/unwind.c               |    2 +-
 arch/microblaze/lib/ashldi3.c                 |    3 +-
 arch/microblaze/lib/ashrdi3.c                 |    3 +-
 arch/microblaze/lib/cmpdi2.c                  |    2 +-
 arch/microblaze/lib/lshrdi3.c                 |    3 +-
 arch/microblaze/lib/memcpy.c                  |   12 +-
 arch/microblaze/lib/memmove.c                 |   11 +-
 arch/microblaze/lib/memset.c                  |    2 +-
 arch/microblaze/lib/muldi3.c                  |    2 +-
 arch/microblaze/lib/uaccess_old.S             |    9 +-
 arch/microblaze/lib/ucmpdi2.c                 |    2 +-
 arch/microblaze/mm/consistent.c               |    7 +-
 arch/microblaze/mm/fault.c                    |   10 +-
 arch/microblaze/mm/highmem.c                  |    2 +-
 arch/microblaze/mm/init.c                     |   32 +++---
 arch/microblaze/mm/pgtable.c                  |   17 ++-
 arch/microblaze/pci/indirect_pci.c            |    2 +-
 arch/microblaze/pci/iomap.c                   |    2 +-
 arch/microblaze/pci/pci-common.c              |   96 ++++++++--------
 arch/microblaze/pci/xilinx_pci.c              |   16 +--
 include/asm-generic/io.h                      |    8 +-
 47 files changed, 299 insertions(+), 331 deletions(-)
 create mode 100644 arch/microblaze/boot/.gitignore
 create mode 100644 arch/microblaze/kernel/.gitignore




-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform
