Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758459Ab3K1Kc4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 05:32:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51134 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754257Ab3K1Ka4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 05:30:56 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCHv2 0/7] perf tools: Add data file write interface
Date: Thu, 28 Nov 2013 11:30:12 +0100
Message-Id: <1385634619-8129-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
adding perf_data_file__write function to centralize
output file writes. Using it in record and inject
commands.

v2 changes:
  - changes for readn function, suggested by Ingo
  - added writen function, suggested by Arnaldo
  - spliting record change into 2 separated patches
  - omiting some unnecessary changes in the inject change
 
thanks,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
---
Jiri Olsa (7):
      perf record: Unify data output code into perf_record__write function
      perf tools: Use correct return type for readn function
      perf tools: Fine tune readn function
      perf tools: Add writen function
      perf tools: Add perf_data_file__write interface
      perf record: Use perf_data_file__write for output file
      perf inject: Handle output file via perf_data_file object

 tools/perf/builtin-inject.c | 65 +++++++++++++++++++++++++++--------------------------------------
 tools/perf/builtin-record.c | 41 +++++++++++++----------------------------
 tools/perf/util/data.c      |  6 ++++++
 tools/perf/util/data.h      | 14 ++++++++------
 tools/perf/util/header.c    | 18 +++++++++---------
 tools/perf/util/session.c   |  2 +-
 tools/perf/util/util.c      | 32 ++++++++++++++++++++++++++------
 tools/perf/util/util.h      |  3 ++-
 8 files changed, 92 insertions(+), 89 deletions(-)
