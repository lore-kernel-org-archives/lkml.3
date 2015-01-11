Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364AbbAKED0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 23:03:26 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:41784 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbbAKEDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 23:03:24 -0500
From: David Long <dave.long@linaro.org>
To: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>
Cc: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        William Cohen <wcohen@redhat.com>,
        Steve Capper <steve.capper@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/6] arm64: Add kernel probes (kprobes) support
Date: Sat, 10 Jan 2015 23:03:15 -0500
Message-Id: <1420949002-3726-1-git-send-email-dave.long@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "David A. Long" <dave.long@linaro.org>

This patchset is heavily based on Sandeepa Prabhu's ARM v8 kprobes patches, first
seen in October 2013. This version attempts to address concerns raised by
reviewers and also fixes problems discovered during testing, particularly during
SMP testing.

This patchset adds support for kernel probes(kprobes), jump probes(jprobes)
and return probes(kretprobes) support for ARM64.

The kprobes mechanism makes use of software breakpoint and single stepping
support available in the ARM v8 kernel.

Changes since v2 include:

1) Removal of NOP padding in kprobe XOL slots. Slots are now exactly one
instruction long.
2) Disabling of interrupts during execution in single-step mode.
3) Fixing of numerous problems in instruction simulation code (mostly
thanks to Will Cohen).
4) Support for the HAVE_REGS_AND_STACK_ACCESS_API feature is added, to allow
access to kprobes through debugfs.
5) kprobes is *not* enabled in defconfig.
6) Numerous complaints from checkpatch have been cleaned up, although a couple
remain as removing the function pointer typedefs results in ugly code.

Changes since v3 include:

1) Remove table-driven instruction parsing and replace with an if statement
calling out to old and new instruction test functions in insn.c.
2) I removed the addition of orig_x0 to ptrace.h.
3) Reorder the patches.
4) Replace the previous interrupt disabling (from Will Cohen) with
an improved solution (from Steve Capper).

David A. Long (2):
  arm64: Add HAVE_REGS_AND_STACK_ACCESS_API feature
  arm64: Add more test functions to insn.c

Sandeepa Prabhu (4):
  arm64: Kprobes with single stepping support
  arm64: Kprobes instruction simulation support
  arm64: Add kernel return probes support(kretprobes)
  kprobes: Add arm64 case in kprobe example module

 arch/arm64/Kconfig                       |   3 +
 arch/arm64/include/asm/insn.h            |  21 +-
 arch/arm64/include/asm/kprobes.h         |  61 +++
 arch/arm64/include/asm/probes.h          |  50 +++
 arch/arm64/include/asm/ptrace.h          |  32 +-
 arch/arm64/include/uapi/asm/ptrace.h     |  36 ++
 arch/arm64/kernel/Makefile               |   3 +
 arch/arm64/kernel/insn.c                 |  18 +
 arch/arm64/kernel/kprobes-arm64.c        | 161 +++++++
 arch/arm64/kernel/kprobes-arm64.h        |  30 ++
 arch/arm64/kernel/kprobes.c              | 692 +++++++++++++++++++++++++++++++
 arch/arm64/kernel/kprobes.h              |  30 ++
 arch/arm64/kernel/probes-condn-check.c   | 122 ++++++
 arch/arm64/kernel/probes-simulate-insn.c | 174 ++++++++
 arch/arm64/kernel/probes-simulate-insn.h |  33 ++
 arch/arm64/kernel/ptrace.c               | 119 ++++++
 arch/arm64/kernel/vmlinux.lds.S          |   1 +
 samples/kprobes/kprobe_example.c         |   8 +
 18 files changed, 1591 insertions(+), 3 deletions(-)
 create mode 100644 arch/arm64/include/asm/kprobes.h
 create mode 100644 arch/arm64/include/asm/probes.h
 create mode 100644 arch/arm64/kernel/kprobes-arm64.c
 create mode 100644 arch/arm64/kernel/kprobes-arm64.h
 create mode 100644 arch/arm64/kernel/kprobes.c
 create mode 100644 arch/arm64/kernel/kprobes.h
 create mode 100644 arch/arm64/kernel/probes-condn-check.c
 create mode 100644 arch/arm64/kernel/probes-simulate-insn.c
 create mode 100644 arch/arm64/kernel/probes-simulate-insn.h

-- 
1.8.1.2

