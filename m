Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034Ab3KYOTg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 09:19:36 -0500
Received: from merlin.infradead.org ([205.233.59.134]:42781 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757985Ab3KYOSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 09:18:13 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        Stanislav Fomichev <stfomichev@yandex-team.ru>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 00/25] perf/core improvements and fixes
Date: Mon, 25 Nov 2013 11:17:30 -0300
Message-Id: <1385389075-7989-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>

Hi Ingo,

	Please consider pulling,

	This is based on top of a recent tip/perf/urgent.

- Arnaldo

The following changes since commit e98a6e59dff885eb387163b1a7abe019a44ba90b:

  Merge tag 'perf-urgent-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/urgent (2013-11-20 14:29:46 +0100)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo

for you to fetch changes up to 33d7da61e10ad7d43c60d4a5f4adb712361e5131:

  perf script: Print callchains and symbols if they exist (2013-11-22 15:47:41 -0300)

----------------------------------------------------------------
perf/core improvements and fixes:

. Make per-cpu mmaps the default in 'perf record', from Adrian Hunter.

. Default -t/--thread 'perf record' option to no inheritance,
  from Adrian Hunter.

. Make 'perf top -g' refer to callchains, for consistency with other tools,
  from David Ahern.

. Skip ignored symbols while printing callchain, from David Ahern.

. Print callchains and symbols if they exist in 'perf script',
  from David Ahern.

. Remove thread summary coloring in 'perf trace', from Pekka Enberg.

. zsh completion support, from Ramkumar Ramachandra.

. 'perf timechart' improvements, including backtrace support,
  from Stanislav Fomichev.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Adrian Hunter (4):
      perf record: Make per-cpu mmaps the default.
      perf tools: Allow '--inherit' as the negation of '--no-inherit'
      perf tools: Add option macro OPT_BOOLEAN_SET
      perf record: Default -t option to no inheritance

David Ahern (6):
      perf top: Make -g refer to callchains
      perf evsel: Skip ignored symbols while printing callchain
      perf symbols: Move idle syms check from top to generic function
      perf thread: Move comm_list check into function
      perf tools: Export setup_list
      perf script: Print callchains and symbols if they exist

Namhyung Kim (1):
      perf script: Move evname print code to process_event()

Pekka Enberg (1):
      perf trace: Remove thread summary coloring

Ramkumar Ramachandra (5):
      perf completion: Introduce a layer of indirection
      perf completion: Factor out compgen stuff
      perf completion: Factor out call to __ltrim_colon_completions
      perf completion: Introduce zsh support
      perf completion: Rename file to reflect zsh support

Stanislav Fomichev (7):
      perf timechart: Always try to print at least 15 tasks
      perf timechart: Add option to limit number of tasks
      perf timechart: Use proc_num to implement --power-only
      perf timechart: Add support for displaying only tasks related data
      perf timechart: Group figures and add title with details
      perf timechart: Add support for -P and -T in timechart recording
      perf timechart: Add backtrace support

Steven Rostedt (1):
      tools lib traceevent: Use helper trace-seq in print functions like kernel does

 tools/lib/traceevent/event-parse.c                 |   7 +-
 tools/perf/Documentation/perf-record.txt           |  12 +-
 tools/perf/Documentation/perf-timechart.txt        |  26 +-
 tools/perf/Documentation/perf-top.txt              |   5 +-
 tools/perf/Makefile.perf                           |   4 +-
 tools/perf/builtin-record.c                        |  13 +-
 tools/perf/builtin-script.c                        |  35 ++-
 tools/perf/builtin-timechart.c                     | 306 +++++++++++++++++----
 tools/perf/builtin-top.c                           |  29 +-
 tools/perf/builtin-trace.c                         |  13 +-
 tools/perf/{bash_completion => perf-completion.sh} | 100 ++++++-
 tools/perf/perf.h                                  |   1 +
 tools/perf/tests/attr/test-record-no-inherit       |   2 +-
 tools/perf/util/event.c                            |   3 +-
 tools/perf/util/evlist.c                           |   6 +-
 tools/perf/util/evsel.c                            |   5 +-
 tools/perf/util/parse-options.c                    |  21 ++
 tools/perf/util/parse-options.h                    |   8 +
 tools/perf/util/session.c                          |  10 +-
 tools/perf/util/svghelper.c                        |  77 +++++-
 tools/perf/util/svghelper.h                        |  11 +-
 tools/perf/util/symbol.c                           |  32 ++-
 tools/perf/util/symbol.h                           |   4 +
 tools/perf/util/target.c                           |  11 +-
 tools/perf/util/target.h                           |   4 +-
 tools/perf/util/thread.h                           |  12 +
 26 files changed, 603 insertions(+), 154 deletions(-)
 rename tools/perf/{bash_completion => perf-completion.sh} (65%)
