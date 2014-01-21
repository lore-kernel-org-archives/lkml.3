Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989AbaAUUnn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 15:43:43 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37289 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268AbaAUUni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 15:43:38 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alan Cox <alan@linux.intel.com>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>,
        Andi Kleen <andi@firstfloor.org>, Baruch Siach <baruch@tkos.co.il>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Gaurav Jain <gjain@fb.com>,
        Jiri Olsa <jolsa@redhat.com>, linux-xtensa@linux-xtensa.org,
        Max Filippov <jcmvbkbc@gmail.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Peter Zijlstra <peterz@infradead.org>,
        Stanislav Fomichev <stfomichev@yandex-team.ru>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 0/8] perf/core fixes
Date: Tue, 21 Jan 2014 17:42:56 -0300
Message-Id: <1390336984-1553-1-git-send-email-acme@infradead.org>
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

The following changes since commit 45e6af06367e7b2eb8dc49671092462d8f8a5f47:

  Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/core (2014-01-19 13:09:01 +0100)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo

for you to fetch changes up to 578c03c86fadcc6fd7319ddf41dd4d1d88aab77a:

  perf symbols: Fix JIT symbol resolution on heap (2014-01-21 10:56:05 -0300)

----------------------------------------------------------------
perf/core fixes:

. Fix JIT symbol resolution on heap (Namhyung Kim)

. Fix wrong SVG height in 'timechart' (Stanislav Fomichev)

. Free temp cpu_map in perf_session__cpu_bitmap (Stanislav Fomichev)

. Fix NULL pointer reference bug with event unit in 'stat' (Stephane Eranian)

. Fix memory corruption of xyarray when cpumask is used (Stephane Eranian)

. Ensure sscanf does not overrun the "mem" field (Alan Cox)

. Add support for the xtensa architecture (Baruch Siach)

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Alan Cox (1):
      perf tools: Ensure sscanf does not overrun the "mem" field

Baruch Siach (1):
      perf tools: Add support for the xtensa architecture

Namhyung Kim (1):
      perf symbols: Fix JIT symbol resolution on heap

Stanislav Fomichev (2):
      perf timechart: Fix wrong SVG height
      perf session: Free cpu_map in perf_session__cpu_bitmap

Stephane Eranian (3):
      perf stat: fix NULL pointer reference bug with event unit
      perf evsel: Remove duplicate member zeroing after free
      perf stat: Fix memory corruption of xyarray when cpumask is used

 tools/perf/builtin-timechart.c |  3 +++
 tools/perf/perf.h              |  7 +++++++
 tools/perf/util/evlist.c       |  7 +++++--
 tools/perf/util/evsel.c        |  1 -
 tools/perf/util/header.c       |  2 +-
 tools/perf/util/map.c          |  4 ++--
 tools/perf/util/parse-events.c |  2 +-
 tools/perf/util/pmu.c          | 24 ++++++++++++++++++++----
 tools/perf/util/pmu.h          |  2 +-
 tools/perf/util/session.c      | 10 +++++++---
 10 files changed, 47 insertions(+), 15 deletions(-)
