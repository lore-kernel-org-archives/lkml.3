Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334Ab3C2LBm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 07:01:42 -0400
Received: from us02smtp2.synopsys.com ([198.182.60.77]:58797 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab3C2LBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 07:01:41 -0400
Message-ID: <51557482.5030007@synopsys.com>
Date: Fri, 29 Mar 2013 16:31:22 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/arc fixes for 3.9
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.157]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This pull request contains ARC fixes for 3.9 cycle.

It includes fix for a serious bug in DMA mapping API, make allyesconfig wreckage,
removal of bogus email-list placeholder in MAINTAINERS, a typo in ptrace helper
code and last remaining changes for syscall ABI v3 which we are finally starting
to transition-to internally.

The request is late than I intended to - but I was held up with debugging a timer
link list corruption, for which a proposed fix to generic timer code was sent out
to lkml/tglx earlier today.

Please consider pulling.

Thanks,
Vineet

The following changes since commit 6dbe51c251a327e012439c4772097a13df43c5b8:

  Linux 3.9-rc1 (2013-03-03 15:11:05 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vgupta/arc.git/ for-curr

for you to fetch changes up to 367f3fcd9296977bc4689546f55c5f4a9c680e8d:

  ARC: Fix the typo in event identifier flags used by ptrace (2013-03-20 18:45:45
+0530)

----------------------------------------------------------------
ARC fixes for 3.9 cycle

----------------------------------------------------------------
Pierrick Hascoet (1):
      arc: fix dma_address assignment during dma_map_sg()

Vineet Gupta (6):
      ARC: MAINTAINERS update for ARC
      ARC: make allyesconfig build breakages
      ARC: ABIv3: Print the correct ABI ver
      ARC: ABIv3: fork/vfork wrappers not needed in "no-legacy-syscall" ABI
      ARC: Remove SET_PERSONALITY (tracks cross-arch change)
      ARC: Fix the typo in event identifier flags used by ptrace

 MAINTAINERS                        |    3 ++-
 arch/arc/include/asm/dma-mapping.h |    2 +-
 arch/arc/include/asm/elf.h         |    3 ---
 arch/arc/include/asm/entry.h       |    2 +-
 arch/arc/include/asm/kgdb.h        |    6 ++----
 arch/arc/include/asm/ptrace.h      |    2 +-
 arch/arc/include/asm/syscalls.h    |    2 --
 arch/arc/include/uapi/asm/ptrace.h |    4 ++--
 arch/arc/kernel/entry.S            |   27 +--------------------------
 arch/arc/kernel/kgdb.c             |    1 +
 arch/arc/kernel/setup.c            |    4 +---
 arch/arc/kernel/sys.c              |    2 --
 12 files changed, 12 insertions(+), 46 deletions(-)
