Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932903AbaE2P1E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 11:27:04 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:49626 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757436AbaE2P1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 11:27:01 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Jacob Shin <jacob.w.shin@gmail.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, xiakaixu <xiakaixu@huawei.com>
Subject: [PATCH 0/4] perf: Support AMD range breakpoints
Date: Thu, 29 May 2014 17:26:49 +0200
Message-Id: <1401377213-24551-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've made it wait too much so I'm posting that for review now. This
implements range breakpoints on some AMD machine by extending the length
field.

Any comment?

Thanks.

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

-- 
1.8.3.1

