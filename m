Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbaAIOBR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 09:01:17 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:34615 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbaAIOBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 09:01:07 -0500
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCHSET 0/8] tools lib traceevent: Get rid of *die finally!! (v3)
Date: Thu,  9 Jan 2014 23:00:51 +0900
Message-Id: <1389276059-8829-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

* changes in v3)
 - move related header files to tools/include/ (Arnaldo)
 - add WARN_ONCE() when a trace_seq misused (Jiri)
 - add ack's from Jiri

You can also get this on the 'libtraceevent/die-removal-v6' branch in my tree

  git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git

Any comments are welcome, thanks
Namhyung


Namhyung Kim (8):
  tools include: Move perf's linux/compiler.h to a generic place
  tools include: Define likely/unlikely in linux/compiler.h
  tools include: Move perf's bug.h to a generic place
  tools include: Include <linux/compiler.h> from asm/bug.h
  tools lib traceevent: Add state member to struct trace_seq
  tools lib traceevent: Check return value of realloc()
  tools lib traceevent: Get rid of malloc_or_die() in trace_seq_init()
  tools lib traceevent: Get rid of die() finally!!

 tools/include/asm/bug.h                  |   25 +++++++++++++
 tools/include/linux/compiler.h           |   38 ++++++++++++++++++++
 tools/lib/traceevent/Makefile            |    2 +-
 tools/lib/traceevent/event-parse.h       |    7 ++++
 tools/lib/traceevent/event-utils.h       |    4 ---
 tools/lib/traceevent/parse-utils.c       |   44 -----------------------
 tools/lib/traceevent/trace-seq.c         |   58 ++++++++++++++++++++++++++----
 tools/perf/Makefile.perf                 |    4 +--
 tools/perf/config/Makefile               |    1 +
 tools/perf/util/include/asm/bug.h        |   22 ------------
 tools/perf/util/include/linux/compiler.h |   30 ----------------
 11 files changed, 125 insertions(+), 110 deletions(-)
 create mode 100644 tools/include/asm/bug.h
 create mode 100644 tools/include/linux/compiler.h
 delete mode 100644 tools/perf/util/include/asm/bug.h
 delete mode 100644 tools/perf/util/include/linux/compiler.h

-- 
1.7.9.2

