Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101Ab3L3QZq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 11:25:46 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64804 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab3L3QZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 11:25:45 -0500
From: Jean Pihet <jean.pihet@linaro.org>
To: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo <acme@ghostprotocols.net>, Will Deacon <will.deacon@arm.com>
Cc: patches@linaro.org, Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH v4 0/3] perf: add AARCH64 arch support
Date: Mon, 30 Dec 2013 17:25:29 +0100
Message-Id: <1388420732-13961-1-git-send-email-jean.pihet@linaro.org>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add AARCH64 specific support. This includes the following:
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
 arch/arm64/kernel/perf_regs.c             | 44 ++++++++++++++++
 tools/perf/arch/arm64/Makefile            |  7 +++
 tools/perf/arch/arm64/include/perf_regs.h | 88 +++++++++++++++++++++++++++++++
 tools/perf/arch/arm64/util/dwarf-regs.c   | 80 ++++++++++++++++++++++++++++
 tools/perf/arch/arm64/util/unwind.c       | 82 ++++++++++++++++++++++++++++
 tools/perf/config/Makefile                |  8 ++-
 12 files changed, 420 insertions(+), 9 deletions(-)
 create mode 100644 arch/arm64/include/uapi/asm/perf_regs.h
 create mode 100644 arch/arm64/kernel/perf_regs.c
 create mode 100644 tools/perf/arch/arm64/Makefile
 create mode 100644 tools/perf/arch/arm64/include/perf_regs.h
 create mode 100644 tools/perf/arch/arm64/util/dwarf-regs.c
 create mode 100644 tools/perf/arch/arm64/util/unwind.c

-- 
1.7.11.7

