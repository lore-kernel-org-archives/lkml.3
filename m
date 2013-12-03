Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919Ab3LCHPn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 02:15:43 -0500
Received: from mga09.intel.com ([134.134.136.24]:44013 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247Ab3LCHPj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 02:15:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,816,1378882800"; 
   d="scan'208";a="445838527"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 0/7] perf script: Add an option to print the source line number
Date: Tue,  3 Dec 2013 09:23:03 +0200
Message-Id: <1386055390-13757-1-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Here are some patches to add an option to perf script that will
print the source file name and line number.


Adrian Hunter (7):
      perf script: Do not call perf_event__preprocess_sample() twice)
      perf script: Add an option to print the source line number
      perf tools: Use asprintf instead of malloc plus snprintf
      perf tools: Retain bfd reference to lookup source line numbers
      perf tools: Retain symbol source file name to lookup source line numbers
      perf tools: Do not need to read symbols for source line lookup
      perf tools: Do not disable source line lookup just because of 1 failure

 tools/perf/Documentation/perf-script.txt |   2 +-
 tools/perf/builtin-script.c              |  40 +++++++++--
 tools/perf/util/dso.c                    |   3 +
 tools/perf/util/dso.h                    |   5 ++
 tools/perf/util/session.c                |  33 +++++----
 tools/perf/util/session.h                |   3 +-
 tools/perf/util/srcline.c                | 119 +++++++++++++------------------
 tools/perf/util/symbol.c                 |   2 +
 8 files changed, 113 insertions(+), 94 deletions(-)


Regards
Adrian
