Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081AbaFFOMm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 10:12:42 -0400
Received: from mail.kernel.org ([198.145.19.201]:54490 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791AbaFFOMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 10:12:00 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 0/2] perf/tests improvements
Date: Fri,  6 Jun 2014 11:11:47 -0300
Message-Id: <1402063909-13859-1-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

	Experimenting with more topic branches, this time for things you're the
are the original developer and de facto maintainer, the tools/perf/tests/ harness.

	This was done on top of your perf/core branch, please let me know if all is
ok and then you can try pulling from it or perhaps you could just ack it and then
Ingo could pull it directly, opinions? Ingo?

- Arnaldo

The following changes since commit 1bb7b24b0457eeea549262780c0b9d0755416e2f:

  perf tools: Support spark lines in perf stat (2014-06-06 11:54:06 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git tags/perf-tests-for-jirka

for you to fetch changes up to 38b8d135293e110780eaa02b021eb9c13c4009a6:

  perf tests: Show the inner make output when an error happens (2014-06-06 10:45:09 -0300)

----------------------------------------------------------------
perf/tests improvements:

Developer stuff.

. Emit more precise message for missing glibc static library,
  from Arnaldo Carvalho de Melo.

. Show the 'make -f tests/make' inner make output when an error happens.

  The perf build tests harness, invoked with:

    make -C tools/perf -f tests/make

  Will call many combinations of builds, trying to check if all of them
  continue to work over time, for instance, if removing perl support, or
  if building using static libraries still builds fine.

  But one would have to check the contents of a per build test entry
  file to figure out what the error was about. Do it automatically,
  speeding up the process of, for instance, installing missing static
  libraries.

  from Arnaldo Carvalho de Melo.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Arnaldo Carvalho de Melo (2):
      perf tools: Emit more precise message for missing glibc static library
      perf tests: Show the inner make output when an error happens

 tools/perf/config/Makefile | 6 +++++-
 tools/perf/tests/make      | 3 +--
 2 files changed, 6 insertions(+), 3 deletions(-)
