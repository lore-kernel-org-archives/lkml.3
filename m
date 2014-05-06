Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994AbaEFPzu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 11:55:50 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:58521 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757861AbaEFPzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 11:55:49 -0400
From: Jean Pihet <jean.pihet@linaro.org>
To: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>, will.deacon@arm.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH 0/3] perf tools: Add libdw DWARF post unwind support for ARM64
Date: Tue,  6 May 2014 17:55:30 +0200
Message-Id: <1399391733-11927-1-git-send-email-jean.pihet@linaro.org>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding libdw DWARF post unwind support, which is part
of elfutils-devel/libdw-dev package from version 0.158.

Also includes the test suite for dwarf unwinding, by adding the
arch specific test code and the perf_regs_load function.

This series depends on the following kernel patches series:
- AARCH64 unwinding support [1]. Already mainlined.
- ARM libdw integration [2],
and on the changes from the branch for:
- libdw AARCH64 unwinding support [3].

[1] http://www.spinics.net/lists/arm-kernel/msg304483.html
[2] https://lkml.org/lkml/2014/5/6/366
[3] https://git.fedorahosted.org/cgit/elfutils.git/log/?h=mjw/aarch64-unwind

ToDo: investigate the libdw unwinding problem with compat binaries (i.e.
ARMv7 binaries running on ARMv8). Since this functionality works ok with
libunwind, the problem should be in libdw compat support [3].


Jean Pihet (3):
  perf tests: Introduce perf_regs_load function on ARM64
  perf tests: Add dwarf unwind test on ARM64
  perf tools: Add libdw DWARF post unwind support for ARM64

 tools/perf/Makefile.perf                   |  2 +-
 tools/perf/arch/arm64/Makefile             |  7 ++++
 tools/perf/arch/arm64/include/perf_regs.h  |  5 +++
 tools/perf/arch/arm64/tests/dwarf-unwind.c | 59 ++++++++++++++++++++++++++++++
 tools/perf/arch/arm64/tests/regs_load.S    | 39 ++++++++++++++++++++
 tools/perf/arch/arm64/util/unwind-libdw.c  | 53 +++++++++++++++++++++++++++
 tools/perf/tests/builtin-test.c            |  3 +-
 tools/perf/tests/tests.h                   |  3 +-
 8 files changed, 168 insertions(+), 3 deletions(-)
 create mode 100644 tools/perf/arch/arm64/tests/dwarf-unwind.c
 create mode 100644 tools/perf/arch/arm64/tests/regs_load.S
 create mode 100644 tools/perf/arch/arm64/util/unwind-libdw.c

---
Rebased on the latest jolsa/perf/core

-- 
1.7.11.7

