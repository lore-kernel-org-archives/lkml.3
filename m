Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181Ab3IYKpB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 06:45:01 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:57687 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594Ab3IYKo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 06:44:59 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v1 0/7] Optimize jump label implementation on ARM64
Date: Wed, 25 Sep 2013 18:44:20 +0800
Message-Id: <1380105868-31985-1-git-send-email-liuj97@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

This patchset tries to optimize arch specfic jump label implementation
for ARM64 by dynamic kernel text patching.

To enable this feature, your toolchain must support "asm goto" extension
and "%c" constraint extesion. Current GCC for AARCH64 doesn't support
"%c", so you need a GCC patch similiar to this:
http://gcc.gnu.org/viewcvs/gcc/trunk/gcc/config/arm/arm.c?view=patch&r1=175293&r2=175565&pathrev=175565
http://gcc.gnu.org/bugzilla/show_bug.cgi?id=48637

It has been tested on ARM Fast mode, but not on real hardware yet.

Any comments are welcomed!

Jiang Liu (7):
  arm64: introduce basic aarch64 instruction decoding helpers
  arm64: introduce interfaces to hotpatch kernel and module code
  arm64: move encode_insn_immediate() from module.c to insn.c
  arm64: introduce aarch64_insn_gen_{nop|branch_imm}() helper functions
  arm64, jump label: detect %c support for ARM64
  arm64, jump label: optimize jump label implementation
  jump_label: use defined macros instead of hard-coding for better
    readability

 arch/arm64/Kconfig                  |   1 +
 arch/arm64/include/asm/insn.h       |  75 ++++++++++++
 arch/arm64/include/asm/jump_label.h |  52 ++++++++
 arch/arm64/kernel/Makefile          |   3 +-
 arch/arm64/kernel/insn.c            | 238 ++++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/jump_label.c      |  60 +++++++++
 arch/arm64/kernel/module.c          | 151 +++++------------------
 include/linux/jump_label.h          |   3 +-
 scripts/gcc-goto.sh                 |   2 +-
 9 files changed, 463 insertions(+), 122 deletions(-)
 create mode 100644 arch/arm64/include/asm/insn.h
 create mode 100644 arch/arm64/include/asm/jump_label.h
 create mode 100644 arch/arm64/kernel/insn.c
 create mode 100644 arch/arm64/kernel/jump_label.c

-- 
1.8.1.2

