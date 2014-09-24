Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137AbaIXNqB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 09:46:01 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:51759 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbaIXNp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 09:45:59 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, xiakaixu <xiakaixu@huawei.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jacob Shin <jacob.w.shin@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 0/4] perf: Support AMD range breakpoints v2
Date: Wed, 24 Sep 2014 15:45:47 +0200
Message-Id: <1411566351-10987-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm following up on this patchset.
If that's ok for you I may do a pull request in a few days. I'll just
need to make sure it doesn't break anything on the tooling side which I
can't test right now due to some obscure build errors.

Ah it would be nice if someone who knows well perf test and bison sides
can check those particular bits.

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	perf/core

HEAD: 6dba1406bb46939ef42501450d6bfbd4e154280c

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
