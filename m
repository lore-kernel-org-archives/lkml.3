Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759876Ab3JOVEf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 17:04:35 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:46834 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759545Ab3JOVEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 17:04:33 -0400
From: David Long <dave.long@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Rabin Vincent <rabin@rab.in>, "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 00/13] uprobes: Add uprobes support for ARM
Date: Tue, 15 Oct 2013 17:04:15 -0400
Message-Id: <1381871068-27660-1-git-send-email-dave.long@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "David A. Long" <dave.long@linaro.org>

This patch series adds basic uprobes support to ARM. It is based on patches
developed earlier by Rabin Vincent. That approach of adding hooks into
the kprobes instruction parsing code was not well received. This approach
separates the ARM instruction parsing code in kprobes out into a separate set
of functions which can be used by both kprobes and uprobes. Both kprobes and
uprobes then provide their own semantic action tables to process the results of
the parsing.

The following changes have been made for v2:

1) The last dependencies of uprobes on kprobes have been removed and the two
features may now be independently configured.
2) The larger changes have been separated into a few stages.
3) Use of "void *" has been replaced with an appropriate pointer type
in various places.
4) The arm kprobes-test module has been changed to work better with a
thumb-mode kernel.

These patches are based on v3.12-rc5.


David A. Long (11):
  uprobes: move function declarations out of arch
  uprobes: allow ignoring of probe hits
  uprobes: allow arch access to xol slot
  ARM: move shared uprobe/kprobe definitions into new include file
  ARM: move generic thumb instruction parsing code to new files for use
    by other features
  ARM: use a function table for determining instruction interpreter
    actions
  ARM: Disable jprobe selftests in thumb kernels
  kprobes: Remove uneeded kernel dependency on struct arch_specific_insn
  ARM: Finish renaming ARM kprobes APIs for sharing with uprobes
  ARM: add uprobes support
  ARM: Remove uprobes dependency on kprobes

Rabin Vincent (2):
  uprobes: allow arch-specific initialization
  uprobes: add arch write opcode hook

 arch/arm/Kconfig                   |    3 +
 arch/arm/include/asm/kprobes.h     |   15 +-
 arch/arm/include/asm/probes.h      |   25 +
 arch/arm/include/asm/ptrace.h      |    6 +
 arch/arm/include/asm/thread_info.h |    5 +-
 arch/arm/include/asm/uprobes.h     |   34 ++
 arch/arm/kernel/Makefile           |    7 +-
 arch/arm/kernel/kprobes-arm.c      |  813 +++----------------------
 arch/arm/kernel/kprobes-common.c   |  469 +--------------
 arch/arm/kernel/kprobes-test.c     |   13 +-
 arch/arm/kernel/kprobes-thumb.c    | 1156 ++++++------------------------------
 arch/arm/kernel/kprobes.c          |   25 +-
 arch/arm/kernel/kprobes.h          |  397 +------------
 arch/arm/kernel/probes-arm.c       |  742 +++++++++++++++++++++++
 arch/arm/kernel/probes-arm.h       |   72 +++
 arch/arm/kernel/probes-thumb.c     |  877 +++++++++++++++++++++++++++
 arch/arm/kernel/probes-thumb.h     |   95 +++
 arch/arm/kernel/probes.c           |  459 ++++++++++++++
 arch/arm/kernel/probes.h           |  395 ++++++++++++
 arch/arm/kernel/signal.c           |    4 +
 arch/arm/kernel/uprobes-arm.c      |  220 +++++++
 arch/arm/kernel/uprobes.c          |  201 +++++++
 arch/arm/kernel/uprobes.h          |   25 +
 arch/powerpc/include/asm/uprobes.h |    1 -
 arch/x86/include/asm/uprobes.h     |    7 -
 include/linux/kprobes.h            |    7 +-
 include/linux/uprobes.h            |   17 +
 kernel/events/uprobes.c            |   58 +-
 28 files changed, 3573 insertions(+), 2575 deletions(-)
 create mode 100644 arch/arm/include/asm/probes.h
 create mode 100644 arch/arm/include/asm/uprobes.h
 create mode 100644 arch/arm/kernel/probes-arm.c
 create mode 100644 arch/arm/kernel/probes-arm.h
 create mode 100644 arch/arm/kernel/probes-thumb.c
 create mode 100644 arch/arm/kernel/probes-thumb.h
 create mode 100644 arch/arm/kernel/probes.c
 create mode 100644 arch/arm/kernel/probes.h
 create mode 100644 arch/arm/kernel/uprobes-arm.c
 create mode 100644 arch/arm/kernel/uprobes.c
 create mode 100644 arch/arm/kernel/uprobes.h

-- 
1.8.1.2

