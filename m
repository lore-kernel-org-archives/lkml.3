Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580AbbAFNwo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 08:52:44 -0500
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:52837 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885AbbAFNwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 08:52:41 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <acme@redhat.com>, <peterz@infradead.org>
CC: <jolsa@kernel.org>, <mingo@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-perf-users@vger.kernel.org>, <bp@suse.de>,
        <linux-arch@vger.kernel.org>, <Alexey.Brodkin@synopsys.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH 0/5] Perf fixes for ARC + uClibc
Date: Tue, 6 Jan 2015 19:22:10 +0530
Message-ID: <1420552335-26886-1-git-send-email-vgupta@synopsys.com>
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

Thx,
-Vineet

Alexey Brodkin (1):
  perf tools: [uclibc] fix statfs.f_type data type mismatch build error

Vineet Gupta (4):
  perf tools: [uclibc] Elide strlcpy warning
  perf tools: [uclibc] Avoid build splat for syscall numbers
  perf tools: [uclibc] don't rely on glibc malloc working for sz 0
  perf tools: [uclibc] provide stub for pthread_attr_setaffinity_np

 tools/lib/api/fs/debugfs.c                  |  2 +-
 tools/lib/api/fs/fs.c                       |  2 +-
 tools/perf/bench/futex.h                    | 13 +++++++++++++
 tools/perf/bench/sched-pipe.c               |  1 -
 tools/perf/builtin-top.c                    |  1 -
 tools/perf/config/Makefile                  |  6 ++++++
 tools/perf/config/feature-checks/Makefile   |  4 ++++
 tools/perf/config/feature-checks/test-all.c |  5 +++++
 tools/perf/perf-sys.h                       |  1 -
 tools/perf/util/cache.h                     |  2 ++
 tools/perf/util/header.c                    |  2 +-
 11 files changed, 33 insertions(+), 6 deletions(-)

-- 
1.9.1

