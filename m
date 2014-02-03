Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672AbaBCSSp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 13:18:45 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:35016 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460AbaBCSSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 13:18:42 -0500
From: Jean Pihet <jean.pihet@linaro.org>
To: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org,
        Will Deacon <will.deacon@arm.com>
Cc: Arnaldo <acme@ghostprotocols.net>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, patches@linaro.org,
        Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH v6 0/3] perf: AARCH64 arch support
Date: Mon,  3 Feb 2014 19:18:26 +0100
Message-Id: <1391451509-31265-1-git-send-email-jean.pihet@linaro.org>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add AARCH64 specific support. This includes the following:
- AARCH64 perf registers definition and hooks,
- compat mode registers use, i.e. profiling a 32-bit binary on
   a 64-bit system,
- unwinding using the dwarf information from the .debug_frame
   section of the ELF binary,
- unwinding using the frame pointer information; in 64-bit and
   compat modes.

Notes:
- the tools/perf change is submitted separately on LKML,
- support for unwinding using the dwarf information in compat
mode requires some changes to the libunwind code. Those changes
have been submitted on the libunwind ML and are in discussion.

Tested on ARMv7, ARMv8 and x86_64 platforms. The compat mode has been
tested on ARMv8 using statically built 32-bit binaries.


Jean Pihet (3):
  ARM64: perf: add support for perf registers API
  ARM64: perf: add support for frame pointer unwinding in compat mode
  ARM64: perf: support dwarf unwinding in compat mode

 arch/arm64/Kconfig                      |  2 +
 arch/arm64/include/asm/compat.h         |  2 +-
 arch/arm64/include/asm/ptrace.h         |  3 +-
 arch/arm64/include/uapi/asm/Kbuild      |  1 +
 arch/arm64/include/uapi/asm/perf_regs.h | 40 ++++++++++++++++++
 arch/arm64/kernel/Makefile              |  1 +
 arch/arm64/kernel/perf_event.c          | 75 +++++++++++++++++++++++++++++----
 arch/arm64/kernel/perf_regs.c           | 44 +++++++++++++++++++
 8 files changed, 158 insertions(+), 10 deletions(-)
 create mode 100644 arch/arm64/include/uapi/asm/perf_regs.h
 create mode 100644 arch/arm64/kernel/perf_regs.c

-- 
1.7.11.7

