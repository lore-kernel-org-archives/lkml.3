Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751401Ab3IIFdP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 01:33:15 -0400
Received: from us01smtp2.synopsys.com ([198.182.44.80]:49419 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab3IIFdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 01:33:13 -0400
Message-ID: <522D5D86.60503@synopsys.com>
Date: Mon, 9 Sep 2013 11:02:54 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: linus Torvalds <torvalds@linux-foundation.org>
CC: lkml <linux-kernel@vger.kernel.org>, <arc-linux-dev@synopsys.com>,
        "Noam Camus" <noamc@ezchip.com>,
        mischa Jonker <Mischa.Jonker@synopsys.com>
Subject: [GIT PULL] ARC changes for 3.12
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.111]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull ARC changes for 3.12

Thx,
-Vineet

----------------->
The following changes since commit d8dfad3876e4386666b759da3c833d62fb8b2267:

  Linux 3.11-rc7 (2013-08-25 17:43:22 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vgupta/arc.git/ tags/arc-v3.12-rc1

for you to fetch changes up to 07b9b65147d1d7cc03b9ff1e1f3b1c163ba4d067:

  ARC: fix new Section mismatches in build (post __cpuinit cleanup) (2013-09-05
19:19:06 +0530)

----------------------------------------------------------------
ARC changes for 3.12

- ARC MM changes
    preparation for MMUv4 (accomodate new PTE bits, new cmds)
    Rework the ASID allocation algorithm to remove asid-mm reverse map

- Boilerplate code consolidation in Exception Handlers
- Disable FRAME_POINTER for ARC
- Unaligned Access Emulation for Big-Endian from Noam
- Bunch of fixes (udelay, missing accessors) from Mischa

----------------------------------------------------------------
Mischa Jonker (3):
      ARC: Add read*_relaxed to asm/io.h
      ARC: remove console_verbose() from setup_arch()
      ARC: Fix __udelay calculation

Noam Camus (1):
      ARC: Handle un-aligned user space access in BE.

Vineet Gupta (15):
      ARC: Add some .gitignore entries
      ARC: Exception Handlers Code consolidation
      ARC: Entry Handler tweaks: Optimize away redundant IRQ_DISABLE_SAVE
      ARC: Code cosmetics (Nothing semantical)
      ARC: MMUv4 preps/1 - Fold PTE K/U access flags
      ARC: MMUv4 preps/2 - Reshuffle PTE bits
      ARC: MMUv4 preps/3 - Abstract out TLB Insert/Delete
      ARC: No need to flush the TLB in early boot
      ARC: [ASID] Remove legacy/unused debug code
      ARC: [ASID] Refactor the TLB paranoid debug code
      ARC: [ASID] get_new_mmu_context() to conditionally allocate new ASID
      ARC: [ASID] activate_mm() == switch_mm()
      ARC: [ASID] Track ASID allocation cycles/generations
      Kconfig.debug: Add FRAME_POINTER anti-dependency for ARC
      ARC: fix new Section mismatches in build (post __cpuinit cleanup)

 arch/arc/boot/.gitignore              |   1 +
 arch/arc/include/asm/cache.h          |   2 +-
 arch/arc/include/asm/delay.h          |   5 +-
 arch/arc/include/asm/entry.h          |  24 +++-
 arch/arc/include/asm/io.h             |   4 +
 arch/arc/include/asm/irqflags.h       |   7 --
 arch/arc/include/asm/mmu.h            |  11 +-
 arch/arc/include/asm/mmu_context.h    | 161 ++++++++------------------
 arch/arc/include/asm/pgtable.h        |  61 ++++------
 arch/arc/include/asm/ptrace.h         |  36 ++----
 arch/arc/include/asm/spinlock_types.h |   6 +-
 arch/arc/kernel/.gitignore            |   1 +
 arch/arc/kernel/entry.S               |  66 +++--------
 arch/arc/kernel/setup.c               |   2 -
 arch/arc/kernel/unaligned.c           |  26 +++--
 arch/arc/mm/cache_arc700.c            |   8 +-
 arch/arc/mm/tlb.c                     | 174 +++++++++++++++--------------
 arch/arc/mm/tlbex.S                   | 205 ++++++++++++++++------------------
 lib/Kconfig.debug                     |   6 +-
 19 files changed, 352 insertions(+), 454 deletions(-)
 create mode 100644 arch/arc/boot/.gitignore
 create mode 100644 arch/arc/kernel/.gitignore
