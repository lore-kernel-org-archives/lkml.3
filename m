Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758913Ab3BZV6Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 16:58:25 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:48743 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758399Ab3BZV6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 16:58:24 -0500
Message-ID: <512D2FFD.5060108@zankel.net>
Date: Tue, 26 Feb 2013 13:58:21 -0800
From: Chris Zankel <chris@zankel.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] xtensa changes for 3.9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 19f949f52599ba7c3f67a5897ac6be14bfcb1200:

  Linux 3.8 (2013-02-18 15:58:34 -0800)

are available in the git repository at:

  git://github.com/czankel/xtensa-linux.git tags/xtensa-next-20130225

for you to fetch changes up to 9cf81c759b7db1db593b2ca60b74ec350d5f9205:

  xtensa: add accept4 syscall (2013-02-25 22:48:51 -0800)

----------------------------------------------------------------
Changes for arch/xtensa for the 3.9 merge window.

Added features:
- add support for thread local storage (TLS)
- add accept4 and finit_module syscalls
- support medium-priority interrupts
- add support for dc232c processor variant
- support file-base simulated disk for ISS simulator

Bug fixes:
- fix return values returned by the  str[n]cmp functions
- avoid mmap cache aliasing
- fix handling of 'windowed registers' in ptrace

----------------------------------------------------------------
Chris Zankel (2):
      xtensa: add support for TLS
      xtensa: add accept4 syscall

Marc Gauthier (1):
      xtensa: dispatch medium-priority interrupts

Max Filippov (10):
      xtensa: rename prom_update_property to of_update_property
      xtensa: fix ipc_parse_version selection
      xtensa: pull signal definitions from signal-defs.h
      xtensa: add finit_module syscall
      xtensa: avoid mmap cache aliasing
      xtensa: fix str[n]cmp return value
      xtensa: move spill_registers to traps.h
      xtensa: complete ptrace handling of register windows
      xtensa: do not enable GENERIC_GPIO by default
      xtensa: add missing include asm/uaccess.h to checksum.h

Pete Delaney (1):
      xtensa: Add config files for Diamond 233L - Rev C processor variant

Stephen Warren (1):
      xtensa: use new common dtc rule

Victor Prupis (1):
      xtensa: ISS: add host file-based simulated disk

dann (1):
      xtensa: add support for oprofile

 arch/xtensa/Kconfig                                |   46 +-
 arch/xtensa/Makefile                               |    6 +-
 arch/xtensa/boot/Makefile                          |   12 -
 arch/xtensa/boot/dts/Makefile                      |   15 +
 arch/xtensa/include/asm/atomic.h                   |    6 +-
 arch/xtensa/include/asm/checksum.h                 |    1 +
 arch/xtensa/include/asm/elf.h                      |    3 +-
 arch/xtensa/include/asm/pgtable.h                  |    4 +
 arch/xtensa/include/asm/processor.h                |    4 +-
 arch/xtensa/include/asm/ptrace.h                   |    3 +-
 arch/xtensa/include/asm/regs.h                     |    1 +
 arch/xtensa/include/asm/string.h                   |    4 +-
 arch/xtensa/include/asm/timex.h                    |    8 +-
 arch/xtensa/include/asm/traps.h                    |   24 +
 arch/xtensa/include/uapi/asm/signal.h              |   11 +-
 arch/xtensa/include/uapi/asm/unistd.h              |    7 +-
 arch/xtensa/kernel/asm-offsets.c                   |    1 +
 arch/xtensa/kernel/entry.S                         |   69 ++-
 arch/xtensa/kernel/head.S                          |    9 +-
 arch/xtensa/kernel/process.c                       |    5 +-
 arch/xtensa/kernel/ptrace.c                        |   35 +-
 arch/xtensa/kernel/setup.c                         |   42 ++
 arch/xtensa/kernel/signal.c                        |    6 +-
 arch/xtensa/kernel/syscall.c                       |   41 ++
 arch/xtensa/kernel/traps.c                         |   74 +--
 arch/xtensa/kernel/vectors.S                       |   57 ++-
 arch/xtensa/kernel/vmlinux.lds.S                   |   68 ++-
 arch/xtensa/oprofile/Makefile                      |    9 +
 arch/xtensa/oprofile/backtrace.c                   |  171 +++++++
 arch/xtensa/oprofile/init.c                        |   26 ++
 arch/xtensa/platforms/iss/Makefile                 |    1 +
 arch/xtensa/platforms/iss/simdisk.c                |  375 ++++++++++++++++
 arch/xtensa/platforms/xtfpga/setup.c               |    4 +-
 arch/xtensa/variants/dc233c/include/variant/core.h |  475
++++++++++++++++++++
 .../variants/dc233c/include/variant/tie-asm.h      |  193 ++++++++
 arch/xtensa/variants/dc233c/include/variant/tie.h  |  150 +++++++
 36 files changed, 1851 insertions(+), 115 deletions(-)
 create mode 100644 arch/xtensa/boot/dts/Makefile
 create mode 100644 arch/xtensa/oprofile/Makefile
 create mode 100644 arch/xtensa/oprofile/backtrace.c
 create mode 100644 arch/xtensa/oprofile/init.c
 create mode 100644 arch/xtensa/platforms/iss/simdisk.c
 create mode 100644 arch/xtensa/variants/dc233c/include/variant/core.h
 create mode 100644 arch/xtensa/variants/dc233c/include/variant/tie-asm.h
 create mode 100644 arch/xtensa/variants/dc233c/include/variant/tie.h
