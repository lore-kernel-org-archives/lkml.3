Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949Ab3LPQtr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 11:49:47 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:65535 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754889Ab3LPQtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 11:49:42 -0500
From: jean.pihet@linaro.org
To: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Arnaldo <acme@ghostprotocols.net>, Will Deacon <will.deacon@arm.com>
Cc: patches@linaro.org, Jiri Olsa <jolsa@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH 0/3] ARM64: add perf support
Date: Mon, 16 Dec 2013 17:49:19 +0100
Message-Id: <52af2f21.41590e0a.0251.ffffd94c@mx.google.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean Pihet <jean.pihet@linaro.org>

Add perf support for the AARCH64 architecture. This includes the
support for:
- AARCH64 perf registers definition and hooks,
- compat mode registers use, i.e. profiling a 32-bit binary on
   a 64-bit system,
- unwinding using the dwarf information from the .debug_frame
   section of the ELF binary; only in 64-bit mode,
- unwinding using the frame pointer information; in 64-bit and
   compat modes.

ToDo:
- add support for unwinding using the dwarf information in compat
   mode. This requires some changes to the libunwind code.

Tested on ARMv7 and ARMv8 platforms. The compat mode has been tested
on ARMv8 using statically built 32-bit binaries.


Jean Pihet (3):
  ARM64: perf: add support for perf registers API
  ARM64: perf: wire up perf_regs and unwind support
  ARM64: perf: add support for frame pointer unwinding in compat mode

 arch/arm64/Kconfig                        |  2 +
 arch/arm64/include/asm/ptrace.h           |  1 +
 arch/arm64/include/uapi/asm/Kbuild        |  1 +
 arch/arm64/include/uapi/asm/perf_regs.h   | 40 ++++++++++++++
 arch/arm64/kernel/Makefile                |  1 +
 arch/arm64/kernel/perf_event.c            | 75 +++++++++++++++++++++++---
 arch/arm64/kernel/perf_regs.c             | 46 ++++++++++++++++
 tools/perf/arch/arm64/Makefile            |  7 +++
 tools/perf/arch/arm64/include/perf_regs.h | 88 +++++++++++++++++++++++++++++++
 tools/perf/arch/arm64/util/dwarf-regs.c   | 81 ++++++++++++++++++++++++++++
 tools/perf/arch/arm64/util/unwind.c       | 82 ++++++++++++++++++++++++++++
 tools/perf/config/Makefile                |  8 ++-
 12 files changed, 423 insertions(+), 9 deletions(-)
 create mode 100644 arch/arm64/include/uapi/asm/perf_regs.h
 create mode 100644 arch/arm64/kernel/perf_regs.c
 create mode 100644 tools/perf/arch/arm64/Makefile
 create mode 100644 tools/perf/arch/arm64/include/perf_regs.h
 create mode 100644 tools/perf/arch/arm64/util/dwarf-regs.c
 create mode 100644 tools/perf/arch/arm64/util/unwind.c

-- 
1.7.11.7

