Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932310AbaHVOR0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 10:17:26 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:49506 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932099AbaHVORZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 10:17:25 -0400
Date: Fri, 22 Aug 2014 15:17:12 +0100
From: Will Deacon <will.deacon@arm.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        catalin.marinas@arm.com, broonie@linaro.org, arnd@arndb.de
Subject: [GIT PULL] arm64: post merge-window fixes for 3.17
Message-ID: <20140822141712.GA12681@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please can you pull the following small set of arm64 fixes to address some
issues introduced during the merge window? There's one change outside of
arch/arm64, which wires up memfd_create for asm-generic unistd.h. Arnd
suggested that we take that via the arm64 tree [1].

Thanks,

Will

[1] https://lkml.org/lkml/2014/8/11/473

--->8

The following changes since commit 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9:

  Linux 3.17-rc1 (2014-08-16 10:40:26 -0600)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git tags/arm64-fixes

for you to fetch changes up to 44b375070fa3defa6bf1010bd0e4e64f7986bfc4:

  Revert "arm64: Do not invoke audit_syscall_* functions if !CONFIG_AUDIT_SYSCALL" (2014-08-19 22:05:45 +0100)

----------------------------------------------------------------
arm64 fixes for merge window fallout

This small set of fixes addresses a few issues introduced during the
merge window, including:

  - Fix typo in I-cache detection that was causing us to treat all
    I-caches as aliasing
  - Hook up memfd_create and getrandom syscalls for native and compat
  - Revert a temporary hack for defconfig builds in -next (the audit
    tree changes didn't make it in this merge window)
  - A couple of UEFI fixes for TEXT_OFFSET fuzzing and /memreserve/
  - A simple sparsemem fix for 48-bit physical addressing
  - Small defconfig updates to get autotesters working with X-gene

----------------------------------------------------------------
Ard Biesheuvel (2):
      arm64: fix typo in I-cache policy detection
      arm64: align randomized TEXT_OFFSET on 4 kB boundary

Ganapatrao Kulkarni (1):
      arm64: mm: update max pa bits to 48

Leif Lindholm (1):
      arm64: ignore DT memreserve entries when booting in UEFI mode

Mark Brown (1):
      arm64: configs: Enable X-Gene SATA and ethernet in defconfig

Will Deacon (3):
      arm64: compat: wire up memfd_create and getrandom syscalls for aarch32
      asm-generic: add memfd_create system call to unistd.h
      Revert "arm64: Do not invoke audit_syscall_* functions if !CONFIG_AUDIT_SYSCALL"

 arch/arm64/Makefile                | 2 +-
 arch/arm64/configs/defconfig       | 3 +++
 arch/arm64/include/asm/sparsemem.h | 2 +-
 arch/arm64/include/asm/unistd.h    | 2 +-
 arch/arm64/include/asm/unistd32.h  | 5 +++++
 arch/arm64/kernel/cpuinfo.c        | 2 +-
 arch/arm64/kernel/efi.c            | 2 ++
 arch/arm64/kernel/head.S           | 8 ++++----
 arch/arm64/kernel/ptrace.c         | 4 ----
 arch/arm64/mm/init.c               | 4 +++-
 include/uapi/asm-generic/unistd.h  | 4 +++-
 11 files changed, 24 insertions(+), 14 deletions(-)
