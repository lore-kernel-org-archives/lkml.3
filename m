Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbaKRGdG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 01:33:06 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:39798 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbaKRGdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 01:33:00 -0500
From: David Long <dave.long@linaro.org>
To: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>
Cc: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        William Cohen <wcohen@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/5] ARM64: Add kernel probes(Kprobes) support
Date: Tue, 18 Nov 2014 01:32:50 -0500
Message-Id: <1416292375-29560-1-git-send-email-dave.long@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "David A. Long" <dave.long@linaro.org>

This patchset is heavily based on Sandeepa Prabhu's ARM v8 kprobes patches, first
seen in October 2013.  This version attempts to address concerns raised by
reviewers and also fixes problems discovered during testing, particularly during
SMP testing.

This patchset adds support for kernel probes(kprobes), jump probes(jprobes)
and return probes(kretprobes) support for ARM64.

Kprobes mechanism makes use of software breakpoint and single stepping
support available in the ARM v8 kernel.

Changes since v2 include:

1) Removal of NOP padding in kprobe XOL slots.  Slots are now exactly one
instruction long.
2) Disabling of interrupts during execution in single-step mode.
3) Fixing of numerous problems in instruction simulation code.
4) Support for the HAVE_REGS_AND_STACK_ACCESS_API feature is added, to allow
access to kprobes through debugfs.
5) kprobes is *not* enabled in defconfig.
6) Numerous complaints from checkpatch have been cleaned up, although a couple
remain as removing the function pointer typedefs results in ugly code.

David A. Long (1):
  arm64: Add HAVE_REGS_AND_STACK_ACCESS_API feature

Sandeepa Prabhu (4):
  arm64: Kprobes with single stepping support
  arm64: Kprobes instruction simulation support
  arm64: Add kernel return probes support(kretprobes)
  kprobes: Add arm64 case in kprobe example module

 arch/arm64/Kconfig                       |   3 +
 arch/arm64/include/asm/kprobes.h         |  61 +++
 arch/arm64/include/asm/probes.h          |  50 +++
 arch/arm64/include/asm/ptrace.h          |  32 +-
 arch/arm64/include/uapi/asm/ptrace.h     |  36 ++
 arch/arm64/kernel/Makefile               |   3 +
 arch/arm64/kernel/kprobes-arm64.c        | 313 ++++++++++++++
 arch/arm64/kernel/kprobes-arm64.h        |  30 ++
 arch/arm64/kernel/kprobes.c              | 702 +++++++++++++++++++++++++++++++
 arch/arm64/kernel/kprobes.h              |  30 ++
 arch/arm64/kernel/probes-condn-check.c   | 122 ++++++
 arch/arm64/kernel/probes-decode.h        | 110 +++++
 arch/arm64/kernel/probes-simulate-insn.c | 174 ++++++++
 arch/arm64/kernel/probes-simulate-insn.h |  33 ++
 arch/arm64/kernel/ptrace.c               | 119 ++++++
 arch/arm64/kernel/vmlinux.lds.S          |   1 +
 samples/kprobes/kprobe_example.c         |   8 +
 17 files changed, 1826 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/include/asm/kprobes.h
 create mode 100644 arch/arm64/include/asm/probes.h
 create mode 100644 arch/arm64/kernel/kprobes-arm64.c
 create mode 100644 arch/arm64/kernel/kprobes-arm64.h
 create mode 100644 arch/arm64/kernel/kprobes.c
 create mode 100644 arch/arm64/kernel/kprobes.h
 create mode 100644 arch/arm64/kernel/probes-condn-check.c
 create mode 100644 arch/arm64/kernel/probes-decode.h
 create mode 100644 arch/arm64/kernel/probes-simulate-insn.c
 create mode 100644 arch/arm64/kernel/probes-simulate-insn.h

-- 
1.8.1.2

