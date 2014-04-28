Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128AbaD1Gwz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 02:52:55 -0400
Received: from gate.crashing.org ([63.228.1.57]:56851 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438AbaD1Gwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 02:52:53 -0400
Message-ID: <1398667957.30694.24.camel@pasglop>
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Mon, 28 Apr 2014 16:52:37 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.11.90 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here is a bunch of post-merge window fixes that have been accumulating
in patchwork while I was on vacation or buried under other stuff last
week.

We have the now usual batch of LE fixes from Anton (sadly some new stuff
that went into this merge window had endian issues, we'll try to make
sure we do better next time)

Some fixes and cleanups to the new 24x7 performance monitoring stuff
(mostly typos and cleaning up printk's)

A series of fixes for an issue with our runlatch bit, which wasn't set
properly for offlined threads/cores and under KVM, causing potentially
some counters to misbehave along with possible power management issues.

A fix for kexec nasty race where the new kernel wouldn't "see" the
secondary processors having reached back into firmware in time.

And finally a few other misc (and pretty simple) bug fixes.

Cheers,
Ben.

The following changes since commit a798c10faf62a505d24e5f6213fbaf904a39623f:

  Linux 3.15-rc2 (2014-04-20 11:08:50 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

for you to fetch changes up to e4565362c7adc31201135c4b6d649fc1bdc3bf20:

  powerpc/4xx: Fix section mismatch in ppc4xx_pci.c (2014-04-28 16:32:53 +1000)

----------------------------------------------------------------
Alistair Popple (1):
      powerpc/4xx: Fix section mismatch in ppc4xx_pci.c

Aneesh Kumar K.V (1):
      powerpc/mm: Fix tlbie to add AVAL fields for 64K pages

Anton Blanchard (11):
      powerpc/powernv: Fix little endian issues in OPAL flash code
      powerpc/powernv: Use uint64_t instead of size_t in OPAL APIs
      powerpc/powernv: Remove some OPAL function declaration duplication
      powerpc/powernv: Fix little endian issues with opal_do_notifier calls
      powerpc/powernv: Fix little endian issues in OPAL error log code
      powerpc/powernv: Create OPAL sglist helper functions and fix endian issues
      powerpc/powernv: Fix little endian issues in OPAL dump code
      powerpc: Rename duplicate COMMAND_LINE_SIZE define
      powerpc: Bump COMMAND_LINE_SIZE to 2048
      powerpc: Bump BOOT_COMMAND_LINE_SIZE to 2048
      powerpc: Fix error return in rtas_flash module init

Benjamin Herrenschmidt (1):
      powerpc/powernv: Fix kexec races going back to OPAL

Cody P Schafer (6):
      powerpc/perf/hv_24x7: Probe errors changed to pr_debug(), padding fixed
      powerpc/perf/hv_gpci: Probe failures use pr_debug(), and padding reduced
      powerpc/perf/hv-gpci: Make device attr static
      powerpc/perf/hv-24x7: Use (unsigned long) not (u32) values when calling plpar_hcall_norets()
      powerpc/perf/hv-24x7: Remove [static 4096], sparse chokes on it
      powerpc/perf/hv-24x7: Catalog version number is be64, not be32

Jeff Mahoney (1):
      powerpc: Export flush_icache_range

Joel Stanley (5):
      powerpc/powernv: Fix sysparam sysfs error handling
      powerpc/powernv: Use ssize_t for sysparam return values
      powerpc/powernv: Check sysfs size before copying
      powerpc/powernv: Fix typos in sysparam code
      powerpc/powernv: Check sysparam size before creation

Li Zhong (2):
      powerpc: Fix Oops in rtas_stop_self()
      powerpc/pseries: Protect remove_memory() with device hotplug lock

Preeti U Murthy (3):
      ppc/powernv: Set the runlatch bits correctly for offline cpus
      ppc/kvm: Set the runlatch bit of a CPU just before starting guest
      ppc/kvm: Clear the runlatch bit of a vcpu before napping

Wei Yang (2):
      powerpc/powernv: Reduce multi-hit of iommu_add_device()
      powerpc/powernv: Release the refcount for pci_dev

 arch/powerpc/boot/main.c                        |   8 +-
 arch/powerpc/boot/ops.h                         |   2 +-
 arch/powerpc/boot/ps3.c                         |   4 +-
 arch/powerpc/include/asm/opal.h                 |  42 ++++-----
 arch/powerpc/include/uapi/asm/setup.h           |   7 +-
 arch/powerpc/kernel/ppc_ksyms.c                 |   1 +
 arch/powerpc/kernel/rtas_flash.c                |   2 +-
 arch/powerpc/kvm/book3s_hv_rmhandlers.S         |  18 +++-
 arch/powerpc/mm/hash_native_64.c                |  38 ++++----
 arch/powerpc/perf/hv-24x7.c                     |  35 ++++---
 arch/powerpc/perf/hv-gpci.c                     |   6 +-
 arch/powerpc/platforms/powernv/opal-dump.c      |  94 +++----------------
 arch/powerpc/platforms/powernv/opal-elog.c      |  11 ++-
 arch/powerpc/platforms/powernv/opal-flash.c     | 118 ++----------------------
 arch/powerpc/platforms/powernv/opal-sysparam.c  |  32 +++++--
 arch/powerpc/platforms/powernv/opal.c           |  69 +++++++++++++-
 arch/powerpc/platforms/powernv/pci-ioda.c       |   3 +-
 arch/powerpc/platforms/powernv/setup.c          |  48 +++++++++-
 arch/powerpc/platforms/powernv/smp.c            |   3 +
 arch/powerpc/platforms/pseries/hotplug-cpu.c    |   5 +-
 arch/powerpc/platforms/pseries/hotplug-memory.c |  10 +-
 arch/powerpc/sysdev/ppc4xx_pci.c                |   2 +-
 22 files changed, 273 insertions(+), 285 deletions(-)


