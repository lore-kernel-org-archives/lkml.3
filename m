Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147Ab3HFFOp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 01:14:45 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:60494 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574Ab3HFFOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 01:14:44 -0400
X-AuditID: 9c93017e-b7b62ae000000eeb-cb-520086429d23
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Pekka Enberg <penberg@kernel.org>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH/RFC 0/4] perf ui/gtk: Separate out GTK code to a shared object (v2)
Date: Tue,  6 Aug 2013 14:14:12 +0900
Message-Id: <1375766056-19377-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is v2 of gtk code separation patchset to reduce library
dependencies of the perf executable.

I only built libperf-gtk.so with -fPIC, and it's not linked to libperf
at build time.  All unresolved symbols used for perf should be
resolved at runtime via perf executable (so libperf.a) - I didn't know
that the linker permits unresolved symbols in a shared library at
build time.

Tested on my x86-64 machine only.  It seems work well for me.

The patch 1 is a bug fix and can be applied independently.

You can find it on my 'perf/separate-v2' branch in my tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git


Any comments are welcome, thanks
Namhyung


Cc: Pekka Enberg <penberg@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>

Namhyung Kim (4):
  perf ui/gtk: Fix segmentation fault on perf_hpp__for_each_format loop
  perf tools: Separate out GTK codes to libperf-gtk.so
  perf tools: Setup GTK browser dynamically
  perf tools: Run dynamic loaded GTK browser

 tools/perf/Makefile           | 39 +++++++++++++++++++++++----------
 tools/perf/builtin-annotate.c | 26 +++++++++++++++++++---
 tools/perf/builtin-report.c   | 16 ++++++++++++--
 tools/perf/config/Makefile    | 12 +++++++---
 tools/perf/ui/gtk/annotate.c  | 13 ++++++++---
 tools/perf/ui/gtk/gtk.h       | 16 ++++++++++++++
 tools/perf/ui/gtk/hists.c     |  2 --
 tools/perf/ui/setup.c         | 51 +++++++++++++++++++++++++++++++++++++++++--
 tools/perf/ui/ui.h            | 12 +---------
 tools/perf/util/annotate.h    | 24 --------------------
 tools/perf/util/hist.h        | 15 -------------
 11 files changed, 150 insertions(+), 76 deletions(-)

-- 
1.7.11.7

