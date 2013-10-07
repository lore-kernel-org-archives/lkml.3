Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606Ab3JGTDZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 15:03:25 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44583 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755316Ab3JGTCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 15:02:52 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sonny Rao <sonnyrao@chromium.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 0/6] perf/urgent fixes
Date: Mon,  7 Oct 2013 16:02:23 -0300
Message-Id: <1381172549-3210-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>

Hi Ingo,

	Please consider pulling,

- Arnaldo

The following changes since commit d8b11a0cbd1c66ce283eb9dabe0498dfa6483f32:

  perf/x86: Clean up cap_user_time* setting (2013-10-04 09:58:55 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-urgent-for-mingo

for you to fetch changes up to b314e5cfd11fd78545ce6c2be42646254390c1aa:

  perf session: Fix infinite loop on invalid perf.data file (2013-10-04 15:17:46 -0300)

----------------------------------------------------------------
perf/urgent fixes:

. The libaudit test was failing in some systems due to a unescaped newline, fix
  it so that the 'trace' tool can be built in such systems.

. Fix installation of libexec components.

. Add default handler for mmap2 events so that tools that don't explicitely
  define an MMAP2 handler don't crash, fix from David Ahern.

. Fix to find line information for probe list, from Masami Hiramatsu.

. Set child_pid after perf_evlist__prepare_workload(), fix from Namhyung Kim.

. Fix infinite loop on invalid perf.data file, from Namhyung Kim.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Arnaldo Carvalho de Melo (2):
      perf tools: Fix libaudit test
      perf tools: Fix installation of libexec components

David Ahern (1):
      perf tools: Add default handler for mmap2 events

Masami Hiramatsu (1):
      perf probe: Fix to find line information for probe list

Namhyung Kim (2):
      perf stat: Set child_pid after perf_evlist__prepare_workload()
      perf session: Fix infinite loop on invalid perf.data file

 tools/perf/Makefile                 |  1 +
 tools/perf/builtin-stat.c           |  1 +
 tools/perf/config/feature-tests.mak |  2 +-
 tools/perf/util/dwarf-aux.c         | 25 ++++++++++++++++---
 tools/perf/util/dwarf-aux.h         |  6 ++++-
 tools/perf/util/header.c            | 12 +++++++++
 tools/perf/util/probe-finder.c      | 49 +++++++++++++++++++++++++------------
 tools/perf/util/session.c           |  4 ++-
 8 files changed, 77 insertions(+), 23 deletions(-)
