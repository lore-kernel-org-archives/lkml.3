Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbaCGUKz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 15:10:55 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:63659 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299AbaCGUKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 15:10:52 -0500
From: David Long <dave.long@linaro.org>
To: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>
Cc: Rabin Vincent <rabin@rab.in>, "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        <davem@davemloft.net>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v7 00/15] uprobes: Add uprobes support for ARM
Date: Fri,  7 Mar 2014 15:10:25 -0500
Message-Id: <1394223040-17129-1-git-send-email-dave.long@linaro.org>
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

Changes for v7:
1) Fix uprobes dependencies in Kconfig's.
2) Fix incomplete include's in kprobes/uprobes.
3) Now based on v3.14-rc5.

David A. Long (15):
  uprobes: Kconfig dependency fix
  ARM: Fix missing includes in kprobes sources
  uprobes: allow ignoring of probe hits
  ARM: move shared uprobe/kprobe definitions into new include file
  ARM: Move generic arm instruction parsing code to new files for
    sharing between features
  ARM: move generic thumb instruction parsing code to new files for use
    by other feature
  ARM: use a function table for determining instruction interpreter
    action
  ARM: Remove use of struct kprobe from generic probes code
  ARM: Make the kprobes condition_check symbol names more generic
  ARM: Change more ARM kprobes symbol names to something more generic
  ARM: Rename the shared kprobes/uprobe return value enum
  ARM: Change the remaining shared kprobes/uprobes symbols to something
    generic
  ARM: Add an emulate flag to the kprobes/uprobes instruction decode
    functions
  ARM: Make arch_specific_insn a define for new arch_probes_insn
    structure
  ARM: add uprobes support

 arch/Kconfig                                       |    6 +-
 arch/arm/Kconfig                                   |    3 +
 arch/arm/include/asm/kprobes.h                     |   17 +-
 arch/arm/include/asm/probes.h                      |   43 +
 arch/arm/include/asm/ptrace.h                      |    6 +
 arch/arm/include/asm/thread_info.h                 |    5 +-
 arch/arm/include/asm/uprobes.h                     |   45 +
 arch/arm/kernel/Makefile                           |    7 +-
 arch/arm/kernel/kprobes-arm.c                      |  806 ++------------
 arch/arm/kernel/kprobes-common.c                   |  469 +-------
 arch/arm/kernel/kprobes-test-arm.c                 |    1 +
 arch/arm/kernel/kprobes-test.c                     |   12 +-
 arch/arm/kernel/kprobes-thumb.c                    | 1145 +++-----------------
 arch/arm/kernel/kprobes.c                          |   25 +-
 arch/arm/kernel/kprobes.h                          |  400 +------
 arch/arm/kernel/{kprobes-arm.c => probes-arm.c}    |  441 ++------
 arch/arm/kernel/probes-arm.h                       |   73 ++
 .../arm/kernel/{kprobes-thumb.c => probes-thumb.c} |  771 ++-----------
 arch/arm/kernel/probes-thumb.h                     |   97 ++
 arch/arm/kernel/{kprobes-common.c => probes.c}     |  207 +---
 arch/arm/kernel/{kprobes.h => probes.h}            |  127 +--
 arch/arm/kernel/signal.c                           |    4 +
 arch/arm/kernel/uprobes-arm.c                      |  234 ++++
 arch/arm/kernel/uprobes.c                          |  210 ++++
 arch/arm/kernel/uprobes.h                          |   35 +
 include/linux/uprobes.h                            |    1 +
 kernel/events/uprobes.c                            |    9 +
 kernel/trace/Kconfig                               |    1 +
 28 files changed, 1354 insertions(+), 3846 deletions(-)
 create mode 100644 arch/arm/include/asm/probes.h
 create mode 100644 arch/arm/include/asm/uprobes.h
 copy arch/arm/kernel/{kprobes-arm.c => probes-arm.c} (65%)
 create mode 100644 arch/arm/kernel/probes-arm.h
 copy arch/arm/kernel/{kprobes-thumb.c => probes-thumb.c} (56%)
 create mode 100644 arch/arm/kernel/probes-thumb.h
 copy arch/arm/kernel/{kprobes-common.c => probes.c} (67%)
 copy arch/arm/kernel/{kprobes.h => probes.h} (80%)
 create mode 100644 arch/arm/kernel/uprobes-arm.c
 create mode 100644 arch/arm/kernel/uprobes.c
 create mode 100644 arch/arm/kernel/uprobes.h

-- 
1.8.1.2

