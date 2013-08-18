Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335Ab3HRUdF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 16:33:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43432 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754710Ab3HRUdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 16:33:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/34] 3.4.59-stable review
Date: Sun, 18 Aug 2013 13:34:13 -0700
Message-Id: <20130818203259.653403173@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.59 release.
There are 34 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Note, there are a number of "build fixes" in this round, in the quest to
get all arches building properly to be able to track future regressions
easier.  Many thanks to Guenter Roeck and Geert Uytterhoeven for their
work in doing this.

Responses should be made by Tue Aug 20 20:32:48 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.59-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.59-rc1

Jan Kara <jack@suse.cz>
    jbd2: Fix use after free after error in jbd2_journal_dirty_metadata()

Geert Uytterhoeven <geert@linux-m68k.org>
    m68k/atari: ARAnyM - Fix NatFeat module support

Andreas Schwab <schwab@linux-m68k.org>
    m68k: Truncate base in do_div()

Will Deacon <will.deacon@arm.com>
    ARM: 7809/1: perf: fix event validation for software group leaders

Geert Uytterhoeven <geert@linux-m68k.org>
    xtensa: replace xtensa-specific _f{data,text} by _s{data,text}

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: fix linker script transformation for .text.unlikely

Johan Hovold <jhovold@gmail.com>
    USB: mos7720: fix broken control requests

Oliver Neukum <oneukum@suse.de>
    usb: add two quirky touchscreen

Johannes Berg <johannes.berg@intel.com>
    genetlink: fix family dump race

Stephane Grosjean <s.grosjean@peak-system.com>
    can: pcan_usb: fix wrong memcpy() bytes length

Stanislaw Gruszka <sgruszka@redhat.com>
    iwl4965: reset firmware after rfkill off

Stanislaw Gruszka <sgruszka@redhat.com>
    iwl4965: set power mode early

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    af_key: initialize satype in key_notify_policy_flush()

Ralf Baechle <ralf@linux-mips.org>
    MIPS: Rewrite pfn_valid to work in modules, too.

David S. Miller <davem@davemloft.net>
    sparc32: Add ucmpdi2.o to obj-y instead of lib-y.

Sam Ravnborg <sam@ravnborg.org>
    sparc32: add ucmpdi2

NeilBrown <neilb@suse.de>
    md/raid1,raid10: use freeze_array in place of raise_barrier in various places.

Will Deacon <will.deacon@arm.com>
    alpha: makefile: don't enforce small data model for kernel builds

Benjamin Herrenschmidt <benh@kernel.crashing.org>
    powerpc/numa: Avoid stupid uninitialized warning from gcc

Thomas Gleixner <tglx@linutronix.de>
    frv: Use core allocator for task_struct

Thomas Gleixner <tglx@linutronix.de>
    frv: Use correct size for task_struct allocation

Zhang Yi <wetpzy@gmail.com>
    futex: Take hugepages into account when generating futex_key

Jesper Nilsson <jesper.nilsson@axis.com>
    CRIS: Add _sdata to vmlinux.lds.S

Paul Gortmaker <paul.gortmaker@windriver.com>
    cris: Remove old legacy "-traditional" flag from arch-v10/lib/Makefile

Jiri Slaby <jslaby@suse.cz>
    cris: posix_types.h, include asm-generic/posix_types.h

Linus Torvalds <torvalds@linux-foundation.org>
    vm: add no-mmu vm_iomap_memory() stub

Jiri Slaby <jslaby@suse.cz>
    HID: microsoft: do not use compound literal - fix build

Paul Bolle <pebolle@tiscali.nl>
    sound: Fix make allmodconfig on MIPS correctly

Takashi Iwai <tiwai@suse.de>
    sound: Fix make allmodconfig on MIPS

Michal Simek <michal.simek@xilinx.com>
    microblaze: Update microblaze defconfigs

Markos Chandras <markos.chandras@imgtec.com>
    MIPS: Expose missing pci_io{map,unmap} declarations

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915/lvds: ditch ->prepare special case

yonghua zheng <younghua.zheng@gmail.com>
    fs/proc/task_mmu.c: fix buffer overflow in add_page_map()

Stephen Boyd <sboyd@codeaurora.org>
    perf/arm: Fix armpmu_map_hw_event()


-------------

Diffstat:

 Makefile                                 |  4 +-
 arch/alpha/Makefile                      |  2 +-
 arch/arm/kernel/perf_event.c             | 10 ++++-
 arch/cris/arch-v10/lib/Makefile          |  3 --
 arch/cris/include/asm/posix_types.h      |  2 +
 arch/cris/kernel/vmlinux.lds.S           |  1 +
 arch/frv/include/asm/thread_info.h       |  2 -
 arch/frv/kernel/process.c                | 15 -------
 arch/m68k/emu/natfeat.c                  | 23 +++++++++--
 arch/m68k/include/asm/div64.h            |  9 ++--
 arch/microblaze/configs/mmu_defconfig    | 49 +++++++++++++++-------
 arch/microblaze/configs/nommu_defconfig  | 71 +++++++++++++++++++-------------
 arch/mips/Kconfig                        |  2 +-
 arch/mips/include/asm/io.h               |  5 +++
 arch/mips/include/asm/page.h             | 17 ++++----
 arch/powerpc/mm/numa.c                   |  2 +-
 arch/sparc/lib/Makefile                  |  2 +-
 arch/sparc/lib/ucmpdi2.c                 | 19 +++++++++
 arch/xtensa/kernel/Makefile              |  1 +
 arch/xtensa/kernel/vmlinux.lds.S         |  3 +-
 arch/xtensa/mm/init.c                    |  6 +--
 drivers/gpu/drm/i915/intel_lvds.c        |  8 +---
 drivers/hid/hid-microsoft.c              |  6 +--
 drivers/md/raid1.c                       | 22 +++++-----
 drivers/md/raid10.c                      | 14 +++----
 drivers/net/can/usb/peak_usb/pcan_usb.c  |  2 +-
 drivers/net/wireless/iwlegacy/4965-mac.c | 16 +++----
 drivers/net/wireless/iwlegacy/common.c   |  1 +
 drivers/usb/core/quirks.c                |  6 +++
 drivers/usb/serial/mos7720.c             | 21 ++++++----
 fs/ext4/ext4_jbd2.c                      |  8 ++--
 fs/proc/task_mmu.c                       |  8 ++--
 include/linux/hugetlb.h                  | 16 +++++++
 kernel/futex.c                           |  3 +-
 mm/hugetlb.c                             | 17 ++++++++
 mm/nommu.c                               | 10 +++++
 net/key/af_key.c                         |  1 +
 net/netlink/genetlink.c                  |  7 ++++
 sound/oss/Kconfig                        |  1 +
 39 files changed, 269 insertions(+), 146 deletions(-)


