Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496AbaEFP0j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 11:26:39 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:51436 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbaEFP0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 11:26:37 -0400
From: Jean Pihet <jean.pihet@linaro.org>
To: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>, will.deacon@arm.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH 0/3] perf tools: Add libdw DWARF post unwind support for ARM
Date: Tue,  6 May 2014 17:26:16 +0200
Message-Id: <1399389979-11279-1-git-send-email-jean.pihet@linaro.org>
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
 tools/perf/arch/arm/tests/dwarf-unwind.c | 59 +++++++++++++++++++++++++++++++
 tools/perf/arch/arm/tests/regs_load.S    | 60 ++++++++++++++++++++++++++++++++
 tools/perf/arch/arm/util/unwind-libdw.c  | 36 +++++++++++++++++++
 tools/perf/tests/builtin-test.c          |  2 +-
 tools/perf/tests/tests.h                 |  2 +-
 8 files changed, 170 insertions(+), 3 deletions(-)
 create mode 100644 tools/perf/arch/arm/tests/dwarf-unwind.c
 create mode 100644 tools/perf/arch/arm/tests/regs_load.S
 create mode 100644 tools/perf/arch/arm/util/unwind-libdw.c

---
Rebased on the latest jolsa/perf/core

-- 
1.7.11.7

