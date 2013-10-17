Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504Ab3JQLSr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 07:18:47 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:48980 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab3JQLSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 07:18:44 -0400
From: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, catalin.marinas@arm.com,
        will.deacon@arm.com, steve.capper@linaro.org, nico@linaro.org,
        srikar@linux.vnet.ibm.com, rostedt@goodmis.org,
        masami.hiramatsu.pt@hitachi.com, dsaxena@linaro.org,
        jiang.liu@huawei.com, Vijaya.Kumar@caviumnetworks.com,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
Subject: [PATCH RFC v2 0/6] ARM64: Add kernel probes(Kprobes) support
Date: Thu, 17 Oct 2013 16:47:45 +0530
Message-Id: <1382008671-4515-1-git-send-email-sandeepa.prabhu@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds support for kernel probes(kprobes), jump probes(jprobes)
and return probes(kretprobes) support for ARM64.

Kprobes mechanism make use of software breakpoint and single stepping
support available in ARM v8 kernel.

This patchset make use of (and dependant upon) dynamic kernel patching 
feature published in patch series: https://lkml.org/lkml/2013/10/15/891

changes: v1 -> v2
 1. Implemented review comments on v1
 2. Debug montior hooks implementation is changed to use rwlocks
    instead of rcu and spinlock.
 3. Enabled recursing in kprobes handler for kprobes re-enter support.
 4. Re-split the patchset to seperate single-stepping, simulation and 
    kretprobes features.
 5. instruction simulation is made independent of 'struct kprobes'
 6. Added 'Linaro Copyright' statements in new added files.
 7. Used arm64 instead of aarch64 in file names and comments.

Tested on ARM v8 fast model with sample modules from: samples/kprobes/

Sandeepa Prabhu (6):
  arm64: support single-step and breakpoint handler hooks
  arm64: Kprobes with single stepping support
  arm64: Kprobes instruction simulation support
  arm64: Add kernel return probes support(kretprobes)
  arm64: Enable kprobes support for arm64 platform
  kprobes: Add cases for arm and arm64 in sample module

 arch/arm64/Kconfig                      |   2 +
 arch/arm64/configs/defconfig            |  20 +-
 arch/arm64/include/asm/debug-monitors.h |  21 +
 arch/arm64/include/asm/kprobes.h        |  60 +++
 arch/arm64/include/asm/probes.h         |  50 +++
 arch/arm64/include/asm/ptrace.h         |   6 +
 arch/arm64/kernel/Makefile              |   2 +
 arch/arm64/kernel/condn-helpers.c       | 120 ++++++
 arch/arm64/kernel/debug-monitors.c      |  86 +++-
 arch/arm64/kernel/entry.S               |   2 +
 arch/arm64/kernel/kprobes-arm64.c       | 313 +++++++++++++++
 arch/arm64/kernel/kprobes-arm64.h       |  30 ++
 arch/arm64/kernel/kprobes.c             | 682 ++++++++++++++++++++++++++++++++
 arch/arm64/kernel/kprobes.h             |  30 ++
 arch/arm64/kernel/probes-decode.h       | 110 ++++++
 arch/arm64/kernel/simulate-insn.c       | 184 +++++++++
 arch/arm64/kernel/simulate-insn.h       |  33 ++
 arch/arm64/kernel/vmlinux.lds.S         |   1 +
 samples/kprobes/kprobe_example.c        |  16 +
 19 files changed, 1756 insertions(+), 12 deletions(-)
 create mode 100644 arch/arm64/include/asm/kprobes.h
 create mode 100644 arch/arm64/include/asm/probes.h
 create mode 100644 arch/arm64/kernel/condn-helpers.c
 create mode 100644 arch/arm64/kernel/kprobes-arm64.c
 create mode 100644 arch/arm64/kernel/kprobes-arm64.h
 create mode 100644 arch/arm64/kernel/kprobes.c
 create mode 100644 arch/arm64/kernel/kprobes.h
 create mode 100644 arch/arm64/kernel/probes-decode.h
 create mode 100644 arch/arm64/kernel/simulate-insn.c
 create mode 100644 arch/arm64/kernel/simulate-insn.h

-- 
1.8.1.2

