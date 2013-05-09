Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350Ab3EIGJM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 02:09:12 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:63957 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932Ab3EIGJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 02:09:07 -0400
Message-ID: <518b3d7f.0269440a.345f.7293@mx.google.com>
From: "chris@zankel.net" <chris@zankel.net>
Date: Wed, 08 May 2013 23:09:01 -0700
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 0f47c9423c0fe468d0b5b153f9b9d6e8e20707eb: 
X-Gm-Message-State: ALoCoQmwQtwfG0E5lTKt+B78CvyUtc1yxfaj87QJ4RQm3SnSXv8iREq/WbEKSWwcG7TUg7tr17OO

  Merge branch 'slab/for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/penberg/linux (2013-05-07 08:42:20 -0700)

are available in the git repository at:


  git://github.com/czankel/xtensa-linux.git tags/xtensa-next-0508

for you to fetch changes up to 67ddeb406fc062a442afcb7d486cd573b2a6fbc9:

  xtensa: Switch to asm-generic/linkage.h (2013-05-08 22:45:44 -0700)

----------------------------------------------------------------
Xtensa patchset for 3.10rc1

----------------------------------------------------------------
Chris Zankel (1):
      xtensa: fix redboot load address

Geert Uytterhoeven (1):
      xtensa: Switch to asm-generic/linkage.h

Max Filippov (15):
      xtensa: fix oprofile building as module
      xtensa: fix ibreakenable register update
      xtensa: add MMU v3 support
      xtensa: document MMUv3 setup sequence
      xtensa: provide default platform_pcibios_init implementation
      xtensa: don't attempt to use unconfigured timers
      xtensa: don't use a7 in simcalls
      xtensa: clean up stpill_registers
      xtensa: add stacktrace support
      xtensa: provide custom CALLER_ADDR* implementations
      xtensa: add irq flags trace support
      xtensa: fix arch_irqs_disabled_flags implementation
      xtensa: enable lockdep support
      xtensa: disable IRQs while IRQ handler is running
      xtensa: ISS: fix timer_lock usage in rs_open

Paul Bolle (1):
      xtensa: remove KCORE_ELF again

 Documentation/xtensa/mmu.txt                       |   46 +++++++
 arch/xtensa/Kconfig                                |   57 ++++++---
 arch/xtensa/boot/boot-elf/Makefile                 |    1 +
 arch/xtensa/boot/boot-elf/boot.lds.S               |   64 ++++------
 arch/xtensa/boot/boot-elf/bootstrap.S              |  101 +++++++++++++---
 arch/xtensa/boot/boot-redboot/boot.ld              |    2 +-
 arch/xtensa/boot/boot-uboot/Makefile               |    6 +-
 arch/xtensa/include/asm/Kbuild                     |    1 +
 arch/xtensa/include/asm/ftrace.h                   |   34 +++++-
 arch/xtensa/include/asm/initialize_mmu.h           |  107 +++++++++++++++++
 arch/xtensa/include/asm/irqflags.h                 |    5 +-
 arch/xtensa/include/asm/linkage.h                  |   16 ---
 arch/xtensa/include/asm/stacktrace.h               |   36 ++++++
 arch/xtensa/include/asm/timex.h                    |    9 +-
 arch/xtensa/include/asm/traps.h                    |    5 +-
 arch/xtensa/include/asm/vectors.h                  |  125 ++++++++++++++++++++
 arch/xtensa/kernel/Makefile                        |    8 +-
 arch/xtensa/kernel/entry.S                         |   84 ++++++-------
 arch/xtensa/kernel/head.S                          |   39 ++++--
 arch/xtensa/kernel/platform.c                      |    1 +
 arch/xtensa/kernel/stacktrace.c                    |  120 +++++++++++++++++++
 arch/xtensa/kernel/traps.c                         |   67 ++++-------
 arch/xtensa/kernel/vectors.S                       |   16 +--
 arch/xtensa/kernel/vmlinux.lds.S                   |   48 +++++---
 arch/xtensa/kernel/xtensa_ksyms.c                  |    5 +
 arch/xtensa/mm/mmu.c                               |   14 ++-
 arch/xtensa/oprofile/backtrace.c                   |    4 +-
 arch/xtensa/platforms/iss/console.c                |   12 +-
 .../platforms/iss/include/platform/simcall.h       |   24 ++--
 arch/xtensa/platforms/iss/setup.c                  |    8 +-
 arch/xtensa/platforms/iss/simdisk.c                |    4 +-
 arch/xtensa/platforms/xt2000/setup.c               |    2 +
 arch/xtensa/platforms/xtfpga/setup.c               |    2 +
 33 files changed, 819 insertions(+), 254 deletions(-)
 create mode 100644 Documentation/xtensa/mmu.txt
 delete mode 100644 arch/xtensa/include/asm/linkage.h
 create mode 100644 arch/xtensa/include/asm/stacktrace.h
 create mode 100644 arch/xtensa/include/asm/vectors.h
 create mode 100644 arch/xtensa/kernel/stacktrace.c
