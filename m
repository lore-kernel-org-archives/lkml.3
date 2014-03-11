Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092AbaCKSgP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 14:36:15 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:65362 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754897AbaCKSgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 14:36:12 -0400
Message-ID: <531F5799.2070302@linaro.org>
Date: Tue, 11 Mar 2014 14:36:09 -0400
From: David Long <dave.long@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>
CC: Rabin Vincent <rabin@rab.in>, "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        davem@davemloft.net, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] uprobes: Add uprobes support for ARM
References: <1394223040-17129-1-git-send-email-dave.long@linaro.org>
In-Reply-To: <1394223040-17129-1-git-send-email-dave.long@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following changes since commit 2d100bc71fcada9e8252fbee3e414add292d118c:

  Merge tag 'v3.14-rc5' of https://github.com/torvalds/linux (2014-03-02 23:04:25 -0500)

are available in the git repository at:


  git://git.linaro.org/people/dave.long/linux.git uprobes-v7

for you to fetch changes up to e55c35236b8adf79453a998506ec6081833b9484:

  ARM: add uprobes support (2014-03-11 11:40:29 -0400)

----------------------------------------------------------------
David A. Long (15):
      uprobes: Kconfig dependency fix
      ARM: Fix missing includes in kprobes sources
      uprobes: allow ignoring of probe hits
      ARM: move shared uprobe/kprobe definitions into new include file
      ARM: Move generic arm instruction parsing code to new files for sharing between features
      ARM: move generic thumb instruction parsing code to new files for use by other feature
      ARM: use a function table for determining instruction interpreter action
      ARM: Remove use of struct kprobe from generic probes code
      ARM: Make the kprobes condition_check symbol names more generic
      ARM: Change more ARM kprobes symbol names to something more generic
      ARM: Rename the shared kprobes/uprobe return value enum
      ARM: Change the remaining shared kprobes/uprobes symbols to something generic
      ARM: Add an emulate flag to the kprobes/uprobes instruction decode functions
      ARM: Make arch_specific_insn a define for new arch_probes_insn structure
      ARM: add uprobes support

 arch/Kconfig                       |    6 +-
 arch/arm/Kconfig                   |    3 +
 arch/arm/include/asm/kprobes.h     |   17 +-
 arch/arm/include/asm/probes.h      |   43 ++
 arch/arm/include/asm/ptrace.h      |    6 +
 arch/arm/include/asm/thread_info.h |    5 +-
 arch/arm/include/asm/uprobes.h     |   45 ++
 arch/arm/kernel/Makefile           |    7 +-
 arch/arm/kernel/kprobes-arm.c      |  806 +++----------------------
 arch/arm/kernel/kprobes-common.c   |  469 +--------------
 arch/arm/kernel/kprobes-test-arm.c |    1 +
 arch/arm/kernel/kprobes-test.c     |   12 +-
 arch/arm/kernel/kprobes-thumb.c    | 1145 ++++++------------------------------
 arch/arm/kernel/kprobes.c          |   25 +-
 arch/arm/kernel/kprobes.h          |  400 +------------
 arch/arm/kernel/probes-arm.c       |  734 +++++++++++++++++++++++
 arch/arm/kernel/probes-arm.h       |   73 +++
 arch/arm/kernel/probes-thumb.c     |  882 +++++++++++++++++++++++++++
 arch/arm/kernel/probes-thumb.h     |   97 +++
 arch/arm/kernel/probes.c           |  455 ++++++++++++++
 arch/arm/kernel/probes.h           |  407 +++++++++++++
 arch/arm/kernel/signal.c           |    4 +
 arch/arm/kernel/uprobes-arm.c      |  234 ++++++++
 arch/arm/kernel/uprobes.c          |  210 +++++++

