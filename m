Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933527Ab3GVUXF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 16:23:05 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52116 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933483Ab3GVUXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 16:23:02 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, Borislav Petkov <bp@alien8.de>,
        Clark Williams <williams@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Feng Tang <feng.tang@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Hitoshi Mitake <h.mitake@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [GIT PULL 00/11] perf/core improvements and fixes
Date: Mon, 22 Jul 2013 17:22:28 -0300
Message-Id: <1374524559-9839-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Hi Ingo,

	Please consider pulling.

	Tomorrow I'll try to process Jiri's group leader patches and David's 'kvm live'
kits and continue looking for patches not processed during my vacations.

Thanks,

- Arnaldo

The following changes since commit 5a9821321e0a61674fd5c4b5a9e95007d0e7e052:

  Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/core (2013-07-19 09:35:30 +0200)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo

for you to fetch changes up to f9ea55d0ddf66ed030b2a478625cd5792d30df16:

  perf tools: Move weight back to common sort keys (2013-07-22 16:58:28 -0300)

----------------------------------------------------------------
perf/core improvements and fixes.

. Fix memcpy benchmark for large sizes, from Andi Kleen.

. Support callchain sorting based on addresses, from Andi Kleen

. Move weight back to common sort keys, From Andi Kleen.

. Fix named threads support in 'perf script', from David Ahern.

. Handle ENODEV on default cycles event, fix from David Ahern.

. More install tests, from Jiri Olsa.

. Fix build with perl 5.18, from Kirill A. Shutemov.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Andi Kleen (3):
      perf bench: Fix memcpy benchmark for large sizes
      perf tools: Support callchain sorting based on addresses
      perf tools: Move weight back to common sort keys

David Ahern (2):
      perf script: Fix named threads support
      perf evsel: Handle ENODEV on default cycles event

Jiri Olsa (5):
      perf tests: Run ctags/cscope make tests only with needed binaries
      perf tests: Rename TMP to TMP_O tests/make variable
      perf tests: Add DESTDIR=TMP_DEST tests/make variable
      perf tests: Add 'make install/install-bin' tests into tests/make
      perf tests: Add broken install-* tests into tests/make

Kirill A. Shutemov (1):
      perf tools: Fix build with perl 5.18

 tools/perf/Documentation/perf-report.txt           |  8 ++-
 tools/perf/Makefile                                |  4 +-
 tools/perf/bench/mem-memcpy.c                      |  2 +
 tools/perf/builtin-report.c                        | 19 ++++--
 tools/perf/builtin-script.c                        |  6 +-
 tools/perf/tests/make                              | 67 +++++++++++++++++++---
 tools/perf/util/callchain.c                        |  7 ++-
 tools/perf/util/callchain.h                        |  6 ++
 tools/perf/util/evsel.c                            |  2 +-
 tools/perf/util/hist.c                             |  3 +-
 .../perf/util/scripting-engines/trace-event-perl.c | 14 +++--
 .../util/scripting-engines/trace-event-python.c    |  9 +--
 tools/perf/util/sort.c                             |  4 +-
 tools/perf/util/sort.h                             |  6 +-
 tools/perf/util/trace-event-scripting.c            |  3 +-
 tools/perf/util/trace-event.h                      |  4 +-
 16 files changed, 124 insertions(+), 40 deletions(-)
