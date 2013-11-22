Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846Ab3KVOZU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 09:25:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22169 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755781Ab3KVOZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 09:25:14 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>, David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 0/3] perf tools: Add data file write interface
Date: Fri, 22 Nov 2013 15:24:25 +0100
Message-Id: <1385130268-10664-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
adding perf_data_file__write function to centralize
output file writes. Using it in record and inject
commands.

David,
patch 2 could colide with your mmap changes, not sure
what's your plan with that in near future, let me know
and I can rebase if needed.

thanks,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Stephane Eranian <eranian@google.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
---
Jiri Olsa (3):
      perf tools: Add perf_data_file__write interface
      perf record: Use perf_data_file__write for output file
      perf inject: Handle output file via perf_data_file object

 tools/perf/builtin-inject.c | 71 +++++++++++++++++++++++++++++++----------------------------------------
 tools/perf/builtin-record.c | 42 +++++++++++++-----------------------------
 tools/perf/util/data.c      | 20 ++++++++++++++++++++
 tools/perf/util/data.h      | 15 ++++++++-------
 4 files changed, 72 insertions(+), 76 deletions(-)
