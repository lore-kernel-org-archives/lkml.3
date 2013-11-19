Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab3KSUmV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 15:42:21 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48644 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111Ab3KSUmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 15:42:18 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 0/5] perf/urgent fixes
Date: Tue, 19 Nov 2013 17:41:53 -0300
Message-Id: <1384893718-18762-1-git-send-email-acme@infradead.org>
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

The following changes since commit 801a76050bcf8d4e500eb8d048ff6265f37a61c8:

  seq_file: always clear m->count when we free m->buf (2013-11-18 19:07:53 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-urgent-for-mingo

for you to fetch changes up to 6b5fa0ba4f85a8499287aefaf3f1375450c40c6d:

  tools lib traceevent: Fix conversion of pointer to integer of different size (2013-11-19 16:37:59 -0300)

----------------------------------------------------------------
perf/urgent fixes:

. Tag thread comm as overriden, showing the right comm for threads after forks,
  fix from Frederic Weisbecker.

. Fix memory leak when processing perf.data file header, from Namhyung Kim.

. Don't try to free string constant used for anonymous event groups, fix from Namhyung Kim.

. Fix use of multiple options in processing field in libtraceevent, fix from Steven Rostedt.

. Fix conversion of pointer to integer of different size in libtraceevent.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Arnaldo Carvalho de Melo (1):
      tools lib traceevent: Fix conversion of pointer to integer of different size

Frederic Weisbecker (1):
      perf tools: Tag thread comm as overriden

Namhyung Kim (2):
      perf header: Fix bogus group name
      perf header: Fix possible memory leaks in process_group_desc()

Steven Rostedt (1):
      tools lib traceevent: Fix use of multiple options in processing field

 tools/lib/traceevent/event-parse.c | 25 ++++++++++++++++++++++---
 tools/perf/util/header.c           |  6 ++++--
 tools/perf/util/thread.c           | 11 +++++------
 3 files changed, 31 insertions(+), 11 deletions(-)
