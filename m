Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162AbaCCJxi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 04:53:38 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:34921 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917AbaCCJxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 04:53:37 -0500
From: Jean Pihet <jean.pihet@linaro.org>
To: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org,
        Arnaldo <acme@ghostprotocols.net>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>
Cc: Will Deacon <will.deacon@arm.com>, steve.capper@linaro.org,
        patches@linaro.org, Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH 0/3] perf tools: Add libdw DWARF post unwind support for ARM
Date: Mon,  3 Mar 2014 10:53:20 +0100
Message-Id: <1393840403-26639-1-git-send-email-jean.pihet@linaro.org>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding libdw DWARF post unwind support, which is part
of elfutils-devel/libdw-dev package from version 0.158.

Also includes the test suite for dwarf unwinding, by adding the
arch specific test code and the perf_regs_load function.

Jean Pihet (3):
  perf tests: Introduce perf_regs_load function on ARM
  perf tests: Add dwarf unwind test on ARM
  perf tools: Add libdw DWARF post unwind support for ARM

 tools/perf/Makefile.perf                 |  2 +-
 tools/perf/arch/arm/Makefile             |  7 ++++
 tools/perf/arch/arm/include/perf_regs.h  |  5 +++
 tools/perf/arch/arm/tests/dwarf-unwind.c | 59 ++++++++++++++++++++++++++++++++
 tools/perf/arch/arm/tests/regs_load.S    | 51 +++++++++++++++++++++++++++
 tools/perf/arch/arm/util/unwind-libdw.c  | 36 +++++++++++++++++++
 tools/perf/tests/builtin-test.c          |  2 +-
 tools/perf/tests/tests.h                 |  2 +-
 8 files changed, 161 insertions(+), 3 deletions(-)
 create mode 100644 tools/perf/arch/arm/tests/dwarf-unwind.c
 create mode 100644 tools/perf/arch/arm/tests/regs_load.S
 create mode 100644 tools/perf/arch/arm/util/unwind-libdw.c

---

- Rebased on latest acme/perf/core git tree,
- Tested on quad-core ARMv7 machine

-- 
1.7.11.7

