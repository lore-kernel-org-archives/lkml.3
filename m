Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030329Ab3HIG2O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 02:28:14 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:51561 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030199Ab3HIG2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 02:28:12 -0400
X-AuditID: 9c930179-b7c0bae0000040ac-ed-52048bfa132b
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 0/3] perf ui/gtk: Separate out GTK code to a shared object (v4)
Date: Fri,  9 Aug 2013 15:28:06 +0900
Message-Id: <1376029689-32593-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is v3 of gtk code separation patchset to reduce library
dependencies of the perf executable.

I only built libperf-gtk.so with -fPIC, and it's not linked to libperf
at build time.  All unresolved symbols used for perf should be
resolved at runtime via perf executable (so libperf.a) - I didn't know
that the linker permits unresolved symbols in a shared library at
build time.

Tested on my x86-64 machine only.  It seems work well for me.

v4 changes:
 * create output directory for ui/gtk

You can find it on my 'perf/separate-v4' branch in my tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git


Any comments are welcome, thanks
Namhyung


Cc: Pekka Enberg <penberg@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>

Namhyung Kim (3):
  perf tools: Separate out GTK codes to libperf-gtk.so
  perf tools: Setup GTK browser dynamically
  perf tools: Run dynamic loaded GTK browser

 tools/perf/Makefile           | 42 +++++++++++++++++++++++++-----------
 tools/perf/builtin-annotate.c | 26 +++++++++++++++++++---
 tools/perf/builtin-report.c   | 16 ++++++++++++--
 tools/perf/config/Makefile    | 12 ++++++++---
 tools/perf/ui/gtk/annotate.c  | 13 ++++++++---
 tools/perf/ui/gtk/gtk.h       | 16 ++++++++++++++
 tools/perf/ui/setup.c         | 50 +++++++++++++++++++++++++++++++++++++++++--
 tools/perf/ui/ui.h            | 12 +----------
 tools/perf/util/annotate.h    | 24 ---------------------
 tools/perf/util/hist.h        | 15 -------------
 10 files changed, 151 insertions(+), 75 deletions(-)

-- 
1.7.11.7

