Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933632AbaFLPfT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 11:35:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50927 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752984AbaFLPbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 11:31:15 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [GIT PULL 00/14] perf/core improvements and fixes
Date: Thu, 12 Jun 2014 17:30:31 +0200
Message-Id: <1402587045-5461-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Ingo,
please consider pulling

thanks,
jirka

The following changes since commit 7184062b94b4bfac08715fb786fd2df399c5d6ee:

  Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/core (2014-06-12 13:54:42 +0200)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git tags/perf-core-for-mingo

for you to fetch changes up to 45dc1bb5c1d47f9519e2101f6b073bb4bb1d1f99:

  perf tests: Add test for closing dso objects on EMFILE error (2014-06-12 16:53:23 +0200)

----------------------------------------------------------------
perf/core improvements and fixes:

. Honor user freq/interval properly in record command (Namhyung Kim)

. Speedup DWARF unwind (Jiri Olsa)

Signed-off-by: Jiri Olsa <jolsa@kernel.org>

----------------------------------------------------------------
Jiri Olsa (13):
      perf tools: Cache register accesses for unwind processing
      perf tools: Separate dso data related variables
      perf tools: Add data_fd into dso object
      perf tools: Add global list of opened dso objects
      perf tools: Add global count of opened dso objects
      perf tools: Cache dso data file descriptor
      perf tools: Add file size check and factor dso__data_read_offset
      perf tools: Allow to close dso fd in case of open failure
      perf tools: Add dso__data_* interface descriptons
      perf tests: Spawn child for each test
      perf tests: Allow reuse of test_file function
      perf tests: Add test for caching dso file descriptors
      perf tests: Add test for closing dso objects on EMFILE error

Namhyung Kim (1):
      perf record: Fix to honor user freq/interval properly

 tools/perf/tests/builtin-test.c    |  42 +++++-
 tools/perf/tests/dso-data.c        | 214 +++++++++++++++++++++++++++-
 tools/perf/tests/tests.h           |   2 +
 tools/perf/util/dso.c              | 279 +++++++++++++++++++++++++++++++++----
 tools/perf/util/dso.h              |  50 ++++++-
 tools/perf/util/event.h            |   5 +
 tools/perf/util/evsel.c            |   4 +-
 tools/perf/util/perf_regs.c        |  10 +-
 tools/perf/util/perf_regs.h        |   4 +-
 tools/perf/util/unwind-libunwind.c |   2 -
 10 files changed, 574 insertions(+), 38 deletions(-)
