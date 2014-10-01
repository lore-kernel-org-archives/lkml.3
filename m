Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbaJAVhL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 17:37:11 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:36818 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbaJAVhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 17:37:09 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, xiakaixu <xiakaixu@huawei.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jacob Shin <jacob.w.shin@gmail.com>, Jiri Olsa <jolsa@kernel.org>
Subject: [GIT PULL] hw_breakpoints: Support AMD range breakpoints
Date: Wed,  1 Oct 2014 23:37:00 +0200
Message-Id: <1412199424-15059-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the perf/core-v2 branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	perf/core-v2

HEAD: 33252c1bb36dd7405f412a9ef8fc05dec995064a

It has been acked by Jiri and Oleg.
---
Summary:

* Extend breakpoint tools and core to support address range through perf
  event with initial backend support for AMD extended breakpoints.
  Syntax is:

	perf record -e mem:addr/len:type

  For example set write breakpoint from 0x1000 to 0x1200 (0x1000 + 512)

	perf record -e mem:0x1000/512:w

* Clean up a bit breakpoint code validation
---

Thanks,
	Frederic
---

Jacob Shin (4):
      perf/x86/amd: AMD support for bp_len > HW_BREAKPOINT_LEN_8
      perf tools: allow user to specify hardware breakpoint bp_len
      perf tools: add hardware breakpoint bp_len test cases
      perf/x86: Remove get_hbp_len and replace with bp_len


 arch/x86/include/asm/cpufeature.h        |  2 ++
 arch/x86/include/asm/debugreg.h          |  5 +++
 arch/x86/include/asm/hw_breakpoint.h     |  1 +
 arch/x86/include/uapi/asm/msr-index.h    |  4 +++
 arch/x86/kernel/cpu/amd.c                | 19 +++++++++++
 arch/x86/kernel/hw_breakpoint.c          | 45 ++++++++++---------------
 tools/perf/Documentation/perf-record.txt |  7 ++--
 tools/perf/tests/parse-events.c          | 58 ++++++++++++++++++++++++++++++++
 tools/perf/util/parse-events.c           | 21 ++++++------
 tools/perf/util/parse-events.h           |  2 +-
 tools/perf/util/parse-events.l           |  1 +
 tools/perf/util/parse-events.y           | 26 ++++++++++++--
 12 files changed, 148 insertions(+), 43 deletions(-)
