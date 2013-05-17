Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519Ab3EQRck (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 13:32:40 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:58620 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756461Ab3EQRcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 13:32:39 -0400
Date: Fri, 17 May 2013 18:32:05 +0100
From: Catalin Marinas <Catalin.Marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] arm64 fixes for 3.10-rc2
Message-ID: <20130517173205.GA14326@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
user-agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the arm64 patches below. Thanks.

The following changes since commit f722406faae2d073cc1d01063d1123c35425939e:

  Linux 3.10-rc1 (2013-05-11 17:14:08 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux-aarch64.git tags/arm64-fixes

for you to fetch changes up to 3126976be64bfb4c87297cb022ca815212079aec:

  arm64: debug: fix mdscr.ss check when enabling debug exceptions (2013-05-17 18:24:19 +0100)

----------------------------------------------------------------
Fixes for duplicate definition of early_console, kernel/time/Kconfig
include, __flush_dcache_all() set/way computing, debug (locking, bit
testing). The of_platform_populate() was moved to an arch_init_call() to
allow subsys_init_call() drivers to probe the DT.

----------------------------------------------------------------
Catalin Marinas (2):
      arm64: Invoke the of_platform_populate() at arch_initcall() level
      arm64: Do not source kernel/time/Kconfig explicitly

Chen Gang (1):
      arm64: Fix duplicate definition of early_console

Sukanto Ghosh (1):
      arm64: mm: Fix operands of clz in __flush_dcache_all

Will Deacon (2):
      arm64: debug: clear mdscr_el1 instead of taking the OS lock
      arm64: debug: fix mdscr.ss check when enabling debug exceptions

 arch/arm64/Kconfig                 |  2 --
 arch/arm64/include/asm/assembler.h |  2 +-
 arch/arm64/kernel/debug-monitors.c |  2 --
 arch/arm64/kernel/early_printk.c   |  5 +++--
 arch/arm64/kernel/setup.c          | 12 +++---------
 arch/arm64/mm/cache.S              |  2 +-
 arch/arm64/mm/proc.S               |  3 +--
 7 files changed, 9 insertions(+), 19 deletions(-)
