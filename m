Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab3KRU2b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 15:28:31 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50621 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614Ab3KRU2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 15:28:24 -0500
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
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 00/16] perf/core improvements and fixes
Date: Mon, 18 Nov 2013 17:27:48 -0300
Message-Id: <1384806484-29869-1-git-send-email-acme@infradead.org>
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

The following changes since commit 89b4be142bf2491a94af325f5206fc2f2aa18960:

  Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/urgent (2013-11-15 07:35:50 +0100)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo

for you to fetch changes up to b4070e339cd39e4b56604eddc3e93ee355027d45:

  tools lib traceevent: Fix use of multiple options in processing field (2013-11-18 17:09:51 -0300)

----------------------------------------------------------------
perf/core improvements and fixes:

. Make per-cpu mmaps the default, having inheritance turned on for
  all targets but --tid/-t. From Adrian Hunter.

. Make 'perf top -g' refer to callchains, not --groups, to be consistent
  with 'perf record -g'. From David Ahern.

. Tag thread comm as overriden, fix from Frederic Weisbecker.

. Fix bogus group name when processing the perf.data file header, from Namhyung Kim.

. Fix possible memory leaks in process_group_desc(), from Namhyung Kim.

. Remove 'perf trace' thread summary coloring, from Pekka Enberg.

. Generalize the bash completion scripts and make it work with zsh too, from
  Ramkumar Ramachandra.

. Fix use of multiple options in processing field in libtraceevent, from Steven Rostedt.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Adrian Hunter (4):
      perf record: Make per-cpu mmaps the default.
      perf tools: Allow '--inherit' as the negation of '--no-inherit'
      perf tools: Add option macro OPT_BOOLEAN_SET
      perf record: Default -t option to no inheritance

David Ahern (1):
      perf top: Make -g refer to callchains

Frederic Weisbecker (1):
      perf tools: Tag thread comm as overriden

Namhyung Kim (3):
      perf header: Fix bogus group name
      perf header: Fix possible memory leaks in process_group_desc()
      perf script: Move evname print code to process_event()

Pekka Enberg (1):
      perf trace: Remove thread summary coloring

Ramkumar Ramachandra (5):
      perf completion: introduce a layer of indirection
      perf completion: factor out compgen stuff
      perf completion: factor out call to __ltrim_colon_completions
      perf completion: introduce zsh support
      perf completion: rename file to reflect zsh support

Steven Rostedt (1):
      tools lib traceevent: Fix use of multiple options in processing field

 tools/lib/traceevent/event-parse.c                 |  23 ++++-
 tools/perf/Documentation/perf-record.txt           |  12 +--
 tools/perf/Documentation/perf-top.txt              |   5 +-
 tools/perf/Makefile.perf                           |   4 +-
 tools/perf/builtin-record.c                        |  13 ++-
 tools/perf/builtin-script.c                        |  11 ++-
 tools/perf/builtin-top.c                           |   4 +-
 tools/perf/builtin-trace.c                         |  13 +--
 tools/perf/{bash_completion => perf-completion.sh} | 100 ++++++++++++++++++---
 tools/perf/perf.h                                  |   1 +
 tools/perf/tests/attr/test-record-no-inherit       |   2 +-
 tools/perf/util/evlist.c                           |   6 +-
 tools/perf/util/evsel.c                            |   5 +-
 tools/perf/util/header.c                           |   6 +-
 tools/perf/util/parse-options.c                    |  21 +++++
 tools/perf/util/parse-options.h                    |   8 ++
 tools/perf/util/target.c                           |  11 ++-
 tools/perf/util/target.h                           |   4 +-
 tools/perf/util/thread.c                           |  11 ++-
 19 files changed, 198 insertions(+), 62 deletions(-)
 rename tools/perf/{bash_completion => perf-completion.sh} (65%)
