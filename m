Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965295AbaDJHga (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 03:36:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32058 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225AbaDJHg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 03:36:28 -0400
Date: Thu, 10 Apr 2014 09:36:00 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [GIT PULL v2] perf/core improvements and fixes
Message-ID: <20140410073600.GA1141@krava.brq.redhat.com>
References: <1396980068-27124-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396980068-27124-1-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Ingo,
please consider pulling.

v2 has fixed SOB chain for following patch:
  Jiri Olsa (1):
      perf tests: Add thread maps lookup automated tests

no functional change, so not including all patches

thanks,
jirka


The following changes since commit 538592ff0b008237ae88f5ce5fb1247127dc3ce5:

  Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/core (2014-03-19 08:05:47 +0100)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git tags/perf-core-for-mingo

for you to fetch changes up to 5c9313860657577d6f6b3489a04bb097faa0184a:

  MAINTAINERS: Change e-mail to kernel.org one (2014-04-09 16:55:37 +0200)

----------------------------------------------------------------
perf/core improvements and fixes:

Documentation:

. Fix documentation of invalid 'perf top -s' option (Namhyung Kim)

. Change e-mail to kernel.org one in MAINTAINERS file (Arnaldo Carvalho de Melo)

Developer stuff:

. Disable unwind libraries when libelf isn't found (Arnaldo Carvalho de Melo)

. Add thread maps lookup automated tests (Jiri Olsa)

. Print event name when showing libtraceevent warnings if possible (Namhyung Kim)

. Add --list-cmds to 'kmem', 'mem', 'lock' and 'sched', for use by completion scripts (Ramkumar
+Ramachandra)

----------------------------------------------------------------
Arnaldo Carvalho de Melo (2):
      perf callchains: Disable unwind libraries when libelf isn't found
      MAINTAINERS: Change e-mail to kernel.org one

Jiri Olsa (1):
      perf tests: Add thread maps lookup automated tests

Namhyung Kim (3):
      perf top: Fix documentation of invalid -s option
      tools lib traceevent: Print event name when show warning if possible
      tools lib traceevent: Do not call warning() directly

Ramkumar Ramachandra (4):
      perf kmem: Introduce --list-cmds for use by scripts
      perf mem: Introduce --list-cmds for use by scripts
      perf lock: Introduce --list-cmds for use by scripts
      perf sched: Introduce --list-cmds for use by scripts

 MAINTAINERS                           |   2 +-
 tools/lib/traceevent/event-parse.c    | 109 +++++++++-------
 tools/perf/Documentation/perf-top.txt |   1 -
 tools/perf/Makefile.perf              |   1 +
 tools/perf/builtin-kmem.c             |   8 +-
 tools/perf/builtin-lock.c             |  10 +-
 tools/perf/builtin-mem.c              |  15 ++-
 tools/perf/builtin-sched.c            |  10 +-
 tools/perf/config/Makefile            |   2 +
 tools/perf/perf-completion.sh         |   4 +-
 tools/perf/perf.h                     |   6 +
 tools/perf/tests/builtin-test.c       |   4 +
 tools/perf/tests/mmap-thread-lookup.c | 233 ++++++++++++++++++++++++++++++++++
 tools/perf/tests/tests.h              |   1 +
 14 files changed, 341 insertions(+), 65 deletions(-)
 create mode 100644 tools/perf/tests/mmap-thread-lookup.c
