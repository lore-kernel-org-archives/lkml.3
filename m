Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761468Ab3EAPRU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 11:17:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54396 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761456Ab3EAPRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 11:17:10 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>,
        Ulrich Drepper <drepper@gmail.com>, Will Deacon <will.deacon@arm.com>,
        Stephane Eranian <eranian@google.com>
Subject: [RFCv2 0/8] perf tools: Adding formula support
Date: Wed,  1 May 2013 17:15:38 +0200
Message-Id: <1367421346-18257-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
adding support to define counters for stat command,
by using user defined events and counters.

Initial RFC is here:
http://marc.info/?l=linux-kernel&m=135825930106535&w=2

v2 main changes:
  - counter formula grammar changed
    (details in patch 4 changelog)
  - using -e 'formula-<name>' way of using configured <name> set
    for stat command
    (details in patch 7 changelog)

thanks for comments,
jirka

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ulrich Drepper <drepper@gmail.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Stephane Eranian <eranian@google.com>
---
Jiri Olsa (8):
      perf tools: Move start conditions to start of the flex file
      perf tools: Factorize event parsing to be more general
      perf tools: Add formula-* parsing support for events
      perf tools: Add formula interface to interface formula definitions
      perf tools: Add support to preload default formulas
      perf tests: Add automated tests for formula object
      perf stat: Add support to process formulas
      perf list: List formulas counters

 tools/perf/Makefile              |  20 ++++
 tools/perf/builtin-list.c        |   3 +
 tools/perf/builtin-stat.c        |  83 +++++++++++++-
 tools/perf/formulas/default.conf |  26 +++++
 tools/perf/tests/builtin-test.c  |   4 +
 tools/perf/tests/formula.c       | 183 ++++++++++++++++++++++++++++++
 tools/perf/tests/parse-events.c  |   8 --
 tools/perf/tests/tests.h         |  10 ++
 tools/perf/util/evlist.c         |  13 +++
 tools/perf/util/evlist.h         |   9 ++
 tools/perf/util/formula.c        | 600 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/formula.h        | 142 +++++++++++++++++++++++
 tools/perf/util/formula.l        | 119 ++++++++++++++++++++
 tools/perf/util/formula.y        | 249 +++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/parse-events.c   |  56 ++++++++++
 tools/perf/util/parse-events.h   |  20 ++++
 tools/perf/util/parse-events.l   |  73 ++++++------
 tools/perf/util/parse-events.y   |  80 +++++++++++--
 18 files changed, 1646 insertions(+), 52 deletions(-)
 create mode 100644 tools/perf/formulas/default.conf
 create mode 100644 tools/perf/tests/formula.c
 create mode 100644 tools/perf/util/formula.c
 create mode 100644 tools/perf/util/formula.h
 create mode 100644 tools/perf/util/formula.l
 create mode 100644 tools/perf/util/formula.y
