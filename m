Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830AbaLaPWv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 10:22:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667AbaLaPWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 10:22:48 -0500
From: Pratyush Anand <panand@redhat.com>
To: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk
Cc: tixy@linaro.org, ananth@in.ibm.com, sandeepa.prabhu@linaro.org,
        catalin.marinas@arm.com, will.deacon@arm.com,
        linux-kernel@vger.kernel.org, anil.s.keshavamurthy@intel.com,
        masami.hiramatsu.pt@hitachi.com, wcohen@redhat.com, oleg@redhat.com,
        Pratyush Anand <panand@redhat.com>
Subject: [RFC 0/8] ARM64: Uprobe support added
Date: Wed, 31 Dec 2014 20:51:16 +0530
Message-Id: <cover.1420038188.git.panand@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches have been prepared on top of ARM64 kprobe v3 patches [1]
under review.

Unit test for following has been done so far and they have been found
working
    1. Normal instruction, which can be probed like sub, ldr, add etc.
    2. Instructions which can be simulated like ret.
    3. uretprobe



[1]https://lkml.org/lkml/2014/11/18/33

Pratyush Anand (8):
  ARM64: Move BRK opcodes defines from kprobes.h to insn.h
  ARM64: Refactor kprobes-arm64
  Kernel/uprobe: Define arch_uprobe_exception_notify as __weak
  ARM64: Add instruction_pointer_set function
  ARM64: Re-factor flush_ptrace_access
  ARM64: Handle TRAP_HWBRKPT for user mode as well
  ARM64: Handle TRAP_BRKPT for user mode as well
  ARM64: Add uprobe support

 arch/arm/kernel/uprobes.c                          |   6 -
 arch/arm64/Kconfig                                 |   3 +
 arch/arm64/include/asm/insn.h                      |   8 +
 arch/arm64/include/asm/probes.h                    |  26 ++-
 arch/arm64/include/asm/ptrace.h                    |   7 +
 arch/arm64/include/asm/thread_info.h               |   5 +-
 arch/arm64/include/asm/uprobes.h                   |  43 ++++
 arch/arm64/kernel/Makefile                         |   5 +-
 arch/arm64/kernel/debug-monitors.c                 |  14 +-
 arch/arm64/kernel/kprobes.c                        |  11 +-
 arch/arm64/kernel/kprobes.h                        |   7 +-
 .../kernel/{kprobes-arm64.c => probes-arm64.c}     |  84 +++----
 .../kernel/{kprobes-arm64.h => probes-arm64.h}     |  17 +-
 arch/arm64/kernel/probes-condn-check.c             |   2 +-
 arch/arm64/kernel/probes-decode.h                  |   4 +-
 arch/arm64/kernel/signal.c                         |   4 +-
 arch/arm64/kernel/uprobes.c                        | 255 +++++++++++++++++++++
 arch/arm64/mm/flush.c                              |  30 ++-
 kernel/events/uprobes.c                            |  18 ++
 19 files changed, 445 insertions(+), 104 deletions(-)
 create mode 100644 arch/arm64/include/asm/uprobes.h
 rename arch/arm64/kernel/{kprobes-arm64.c => probes-arm64.c} (79%)
 rename arch/arm64/kernel/{kprobes-arm64.h => probes-arm64.h} (60%)
 create mode 100644 arch/arm64/kernel/uprobes.c

-- 
2.1.0

