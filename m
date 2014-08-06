Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702AbaHFMOs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 08:14:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64411 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588AbaHFMOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 08:14:44 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Dominique Toupin <dominique.toupin@ericsson.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jeremie Galarneau <jgalar@efficios.com>, Jiri Olsa <jolsa@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [RFC 0/5] perf tools: Add perf data CTF conversion
Date: Wed,  6 Aug 2014 14:13:54 +0200
Message-Id: <1407327239-3493-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
this is initial post of the CTF converter for perf.
Basically adding 'perf data convert' command to allow
conversion of perf data file into CTF [1] data.

To convert perf data file run:
  $ perf data convert --to-ctf=./ctf-data/
  [ perf data convert: Converted 'perf.data' into CTF data './ctf-data/' ]
  [ perf data convert: Converted and wrote 11.268 MB (100230 samples) ]

To display converted CTF data run [2]:
  $ babeltrace ./ctf-data/
  [03:19:13.962125533] (+?.?????????) cycles: { }, { ip = 0xFFFFFFFF8105443A, tid = 20714, pid = 20714, period = 1 }
  [03:19:13.962130001] (+0.000004468) cycles: { }, { ip = 0xFFFFFFFF8105443A, tid = 20714, pid = 20714, period = 1 }
  [03:19:13.962131936] (+0.000001935) cycles: { }, { ip = 0xFFFFFFFF8105443A, tid = 20714, pid = 20714, period = 8 }
  [03:19:13.962133732] (+0.000001796) cycles: { }, { ip = 0xFFFFFFFF8105443A, tid = 20714, pid = 20714, period = 114 }
  [03:19:13.962135557] (+0.000001825) cycles: { }, { ip = 0xFFFFFFFF8105443A, tid = 20714, pid = 20714, period = 2087 }
  [03:19:13.962137627] (+0.000002070) cycles: { }, { ip = 0xFFFFFFFF81361938, tid = 20714, pid = 20714, period = 37582 }
  [03:19:13.962161091] (+0.000023464) cycles: { }, { ip = 0xFFFFFFFF8124218F, tid = 20714, pid = 20714, period = 600246 }
  [03:19:13.962517569] (+0.000356478) cycles: { }, { ip = 0xFFFFFFFF811A75DB, tid = 20714, pid = 20714, period = 1325731 }
  [03:19:13.969518008] (+0.007000439) cycles: { }, { ip = 0x34080917B2, tid = 20714, pid = 20714, period = 1144298 }

It has still some limitations (noted in patches), but it has
reached the point of the useful perf feature. More features
and supports are about to come and it'll be better to continue
publicly.

Also reachable in here:
  git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
  perf/core_ctf_convert

thanks for comments,
jirka

[1] Common Trace Format - http://www.efficios.com/ctf
[2] babeltrace - http://www.efficios.com/babeltrace


Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Dominique Toupin <dominique.toupin@ericsson.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jeremie Galarneau <jgalar@efficios.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Tom Zanussi <tzanussi@gmail.com>
---
Jiri Olsa (3):
      perf tools: Add feature check for libbabeltrace
      perf tools: Add new perf data command
      perf tools data: Add perf data to CTF convertion support

Sebastian Andrzej Siewior (2):
      perf tools data: Add a 'perf' prefix to the generic fields
      perf tools data: Add tracepoint events fields CTF convertion support

 tools/perf/Documentation/perf-data.txt                |  40 ++++
 tools/perf/Documentation/perf.txt                     |   7 +-
 tools/perf/Makefile.perf                              |   8 +
 tools/perf/builtin-data.c                             | 112 ++++++++++
 tools/perf/builtin.h                                  |   1 +
 tools/perf/command-list.txt                           |   1 +
 tools/perf/config/Makefile                            |  28 ++-
 tools/perf/config/feature-checks/Makefile             |  10 +-
 tools/perf/config/feature-checks/test-all.c           |   5 +
 tools/perf/config/feature-checks/test-libbabeltrace.c |   8 +
 tools/perf/perf.c                                     |   1 +
 tools/perf/util/data-bt.c                             | 859 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/data-bt.h                             |   8 +
 tools/perf/util/debug.c                               |   4 +-
 tools/perf/util/debug.h                               |   1 +
 15 files changed, 1086 insertions(+), 7 deletions(-)
 create mode 100644 tools/perf/Documentation/perf-data.txt
 create mode 100644 tools/perf/builtin-data.c
 create mode 100644 tools/perf/config/feature-checks/test-libbabeltrace.c
 create mode 100644 tools/perf/util/data-bt.c
 create mode 100644 tools/perf/util/data-bt.h
