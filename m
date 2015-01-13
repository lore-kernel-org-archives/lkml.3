Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453AbbAMNnt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 08:43:49 -0500
Received: from us01smtprelay-2.synopsys.com ([198.182.47.9]:38982 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbbAMNnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 08:43:47 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <acme@redhat.com>, <namhyung@kernel.org>, <jolsa@kernel.org>
CC: <peterz@infradead.org>, <mingo@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-perf-users@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        <Alexey.Brodkin@synopsys.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH v3 0/5] Perf tool fixes for ARC + uClibc
Date: Tue, 13 Jan 2015 19:13:19 +0530
Message-ID: <1421156604-30603-1-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.196.223]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series based off linux-next of 20150105 allows us to build/use perf
for ARC with uClibc based userland.

v3: Changes since v2 [2]
* 1/5	: Ack from Jiri
* 2/5	: no changes
* 3/5	: sys/syscall.h included	  [Jiri]
* 4/5	: no changes
* 5/5	: -lpthread added to link target  [Jiri]
* {1,5} : Changelog updated so scissor lines don't start at column 1

v2: Change since v1 [1]
* [1-3]/5 : no changes
* 4/5     : Make perf_evsel__alloc_id agnostic of zero threads [Namhyung Kim]
* 5/5     : Add missing test file

v1:
* 1/5 is really a resend of old patch posted by Alexey a while back
* 2/5 is uClibc build spew seen on ARM as well
* 3/5 likewise
* 4/5 is uClibc config specific
* 5/5 is uClibc pthread library flavour specific
  It adds a stub for pthread_attr_setaffinity_np
  I can rework it to disable the futex tests altogether if people think that is
  cleaner

Please review and consider applying.
W/o these perf doesn't build and/or work for ARC.

[1] http://www.spinics.net/linux/lists/kernel/msg1897268.html
[2] http://www.spinics.net/linux/lists/kernel/msg1900706.html

Thx,
-Vineet


Alexey Brodkin (1):
  perf tools: [uclibc] fix statfs.f_type data type mismatch build error

Vineet Gupta (4):
  perf tools: [uclibc] Elide strlcpy warning
  perf tools: [uclibc] Avoid build splat for syscall numbers
  perf tools: [uclibc] don't rely on glibc malloc working for sz 0
  perf tools: [uclibc] provide stub for pthread_attr_setaffinity_np

 tools/lib/api/fs/debugfs.c                                 |  2 +-
 tools/lib/api/fs/fs.c                                      |  2 +-
 tools/perf/bench/futex.h                                   | 13 +++++++++++++
 tools/perf/bench/sched-pipe.c                              |  2 +-
 tools/perf/builtin-top.c                                   |  1 -
 tools/perf/config/Makefile                                 |  6 ++++++
 tools/perf/config/feature-checks/Makefile                  |  4 ++++
 tools/perf/config/feature-checks/test-all.c                |  5 +++++
 .../feature-checks/test-pthread-attr-setaffinity-np.c      | 14 ++++++++++++++
 tools/perf/perf-sys.h                                      |  1 -
 tools/perf/util/cache.h                                    |  2 ++
 tools/perf/util/evsel.c                                    |  3 +++
 12 files changed, 50 insertions(+), 5 deletions(-)
 create mode 100644 tools/perf/config/feature-checks/test-pthread-attr-setaffinity-np.c

-- 
1.9.1

