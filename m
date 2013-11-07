Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981Ab3KGPEp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 10:04:45 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55622 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961Ab3KGPEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 10:04:37 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 0/7] perf/core improvements and fixes
Date: Thu,  7 Nov 2013 12:04:11 -0300
Message-Id: <1383836658-10518-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>

Hi Ingo,

	Please consider pulling,

- Arnaldo

The following changes since commit 8a4d0b56b031455adcbe4a9383c3b497456fcfac:

  Merge branch 'uprobes/core' of git://git.kernel.org/pub/scm/linux/kernel/git/oleg/misc into perf/core (2013-11-07 08:46:13 +0100)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo

for you to fetch changes up to 8ce000e83848578a621d64eccdc88bd34c2fc70c:

  perf tools: Remove unneeded include (2013-11-07 11:51:19 -0300)

----------------------------------------------------------------
perf/core improvements and fixes:

. Fix version when building out of tree, as when using one of these:

  $ make help | grep perf
    perf-tar-src-pkg    - Build perf-3.12.0.tar source tarball
    perf-targz-src-pkg  - Build perf-3.12.0.tar.gz source tarball
    perf-tarbz2-src-pkg - Build perf-3.12.0.tar.bz2 source tarball
    perf-tarxz-src-pkg  - Build perf-3.12.0.tar.xz source tarball
  $

  from David Ahern.

. Don't relookup fields by name in each sample in 'trace'.

. 'perf record' code cleanups, from David Ahern.

. Remove unneeded include in sort.h, from Rodrigo Campos.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Arnaldo Carvalho de Melo (2):
      perf evsel: Ditch evsel->handler.data field
      perf trace: Don't relookup fields by name in each sample

David Ahern (4):
      perf tools: Fix version when building out of tree
      perf record: Refactor feature handling into a separate function
      perf record: Remove advance_output function
      perf record: Remove post_processing_offset variable

Rodrigo Campos (1):
      perf tools: Remove unneeded include

 scripts/package/Makefile         |   4 +-
 tools/perf/builtin-inject.c      |  10 +-
 tools/perf/builtin-kmem.c        |   4 +-
 tools/perf/builtin-lock.c        |   4 +-
 tools/perf/builtin-record.c      |  48 ++++-----
 tools/perf/builtin-sched.c       |   4 +-
 tools/perf/builtin-timechart.c   |   4 +-
 tools/perf/builtin-trace.c       | 205 ++++++++++++++++++++++++++++++++++++---
 tools/perf/util/PERF-VERSION-GEN |   3 +
 tools/perf/util/evlist.c         |   2 +-
 tools/perf/util/evsel.h          |   5 +-
 tools/perf/util/session.c        |   4 +-
 tools/perf/util/sort.h           |   1 -
 13 files changed, 239 insertions(+), 59 deletions(-)
