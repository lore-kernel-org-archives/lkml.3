Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948AbaFJOqR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 10:46:17 -0400
Received: from mail.kernel.org ([198.145.19.201]:53627 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798AbaFJOqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 10:46:16 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        Stanislav Fomichev <stfomichev@yandex-team.ru>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 0/7] perf/core improvements
Date: Tue, 10 Jun 2014 11:45:57 -0300
Message-Id: <1402411564-3303-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@kernel.org>

Hi Ingo,

	Getting back at pushing some stuff, should not conflict with Jiri's
perf/core and was branched from tip/perf/core.

	Please let me know if you find any issue,

- Arnaldo

The following changes since commit 82b897782d10fcc4930c9d4a15b175348fdd2871:

  perf: Differentiate exec() and non-exec() comm events (2014-06-06 07:56:22 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git tags/perf-core-for-mingo

for you to fetch changes up to f48e00cead1f7574147e6bd0d203c8331714d35b:

  perf timechart: Reflow documentation (2014-06-10 10:03:18 -0300)

----------------------------------------------------------------
perf/core improvements:

User visible:

. Improve 'perf probe' error messages, moving some diagnostic messages to
  only appear in --verbose mode and fixing up some error reporting related
  to variables and struct members. (Masami Hiramatsu)

. Reflow 'perf timechart' man page. (Stanislav Fomichev)

Developer stuff:

. Be more precise when reporting missing libraries in a static tool build.
  (Arnaldo Carvalho de Melo)

. Show error messages from the multiple make invoked from 'make build-test'.
  (Arnaldo Carvalho de Melo)

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Arnaldo Carvalho de Melo (2):
      perf tools: Emit more precise message for missing glibc static library
      perf tests: Show the inner make output when an error happens

Masami Hiramatsu (4):
      perf probe: Improve error message for unknown member of data structure
      perf probe: Show error code and description in verbose mode
      perf probe: Improve an error message of perf probe --vars mode
      perf probe: Improve error messages in --line option

Stanislav Fomichev (1):
      perf timechart: Reflow documentation

 tools/perf/Documentation/perf-timechart.txt | 41 ++++++++++++++---------------
 tools/perf/builtin-probe.c                  | 23 +++++++++-------
 tools/perf/config/Makefile                  |  6 ++++-
 tools/perf/tests/make                       |  7 ++---
 tools/perf/util/probe-event.c               | 13 ++++++---
 tools/perf/util/probe-finder.c              | 11 +++++---
 6 files changed, 57 insertions(+), 44 deletions(-)
