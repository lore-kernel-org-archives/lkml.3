Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbaIBNKm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 09:10:42 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46266 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750954AbaIBNKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 09:10:40 -0400
Date: Tue, 2 Sep 2014 14:10:36 +0100
From: Will Deacon <will.deacon@arm.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        catalin.marinas@arm.com
Subject: [GIT PULL] arm64: second wave of arm64 fixes for 3.17
Message-ID: <20140902131036.GL25379@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

Please can you pull these fixes for arm64? They address some issues found
by running smatch on the arch code (ignoring the false positives) and also
stop 32-bit Android from losing track of its stack.

There's one additional irq migration fix in the pipeline, but it came in
after I'd tagged and tested this set.

Thanks,

Will

--->8

The following changes since commit 52addcf9d6669fa439387610bc65c92fa0980cef:

  Linux 3.17-rc2 (2014-08-25 15:36:20 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git tags/arm64-fixes

for you to fetch changes up to 5e39977edf6500fd12f169e6c458d33b0ef62feb:

  Revert "arm64: cpuinfo: print info for all CPUs" (2014-09-01 15:55:22 +0100)

----------------------------------------------------------------
arm64 fixes for -rc4

Another handful of arm64 fixes here:

  - A few fixes for real issues found by smatch (after Dan's talk at KS)
  - Revert the /proc/cpuinfo changes merged during the merge window.
    We've opened a can of worms here, so we need to find out where we
    stand before we change this interface.
  - Implement KSTK_ESP for compat tasks, otherwise 32-bit Android gets
    confused wondering where its [stack] has gone
  - Misc fixes (fpsimd context handling, crypto, ...)

----------------------------------------------------------------
Catalin Marinas (1):
      arm64: Add brackets around user_stack_pointer()

Colin Ian King (1):
      arm64/crypto: remove redundant update of data

Geoff Levand (1):
      arm64: Remove unused variable in head.S

Leo Yan (1):
      arm64: fix bug for reloading FPSIMD state after cpu power off

Will Deacon (5):
      arm64: ptrace: fix compat hardware watchpoint reporting
      arm64: ptrace: fix compat reg getter/setter return values
      arm64: perf: don't rely on layout of pt_regs when grabbing sp or pc
      arm64: report correct stack pointer in KSTK_ESP for compat tasks
      Revert "arm64: cpuinfo: print info for all CPUs"

 arch/arm64/crypto/sha2-ce-glue.c       |  1 -
 arch/arm64/include/asm/hw_breakpoint.h |  1 -
 arch/arm64/include/asm/processor.h     |  2 +-
 arch/arm64/include/asm/ptrace.h        |  2 +-
 arch/arm64/kernel/fpsimd.c             |  1 +
 arch/arm64/kernel/head.S               |  4 ----
 arch/arm64/kernel/perf_regs.c          |  6 +++++
 arch/arm64/kernel/ptrace.c             | 13 +++++++----
 arch/arm64/kernel/setup.c              | 40 +++++++++++++++++++---------------
 9 files changed, 40 insertions(+), 30 deletions(-)
