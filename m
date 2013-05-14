Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925Ab3ENCJM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 22:09:12 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:60661 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755732Ab3ENCJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 22:09:09 -0400
X-AuditID: 9c93017d-b7b62ae000004f69-4e-51919cc3c989
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: [PATCHSET 0/9] perf tools: Assorted fixes and changes on perf top/report
Date: Tue, 14 May 2013 11:08:58 +0900
Message-Id: <1368497347-9628-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset is a collection of 3 changes on perf top and report
tools.  I wanted to make them independent, but failed due to laziness. :)

Patch 1 is a fix for -E option handling in perf top.  IIUC it only
shows a given number of entries.  Patch 2 is a simple fix.

Patch 3-5 remove a set of _threaded() functions and also remove
unnecessary locking on perf report path.  It leads to a small
performance gain.

Patch 6-9 implement a long-requested --percent-limit option.  I
preserve the default value to 0 but an user can set it to a different
value using the .perfconfig file.

You can get it from 'perf/top-v1' branch on my tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git

Any comments are welcome, thanks.
Namhyung


Namhyung Kim (9):
  perf top: Fix -E option behavior
  perf top: Fix percent output when no samples collected
  perf top: Get rid of *_threaded() functions
  perf hists: Move locking to its call-sites
  perf report: Don't be bothered with locking when adding hist entries
  perf report: Add --percent-limit option
  perf top: Add --percent-limit option
  perf report: Add report.percent-limit config variable
  perf top: Reuse report.percent-limit config variable

 tools/perf/Documentation/perf-report.txt |  4 ++
 tools/perf/Documentation/perf-top.txt    |  4 ++
 tools/perf/builtin-diff.c                |  2 +-
 tools/perf/builtin-report.c              | 50 +++++++++++------
 tools/perf/builtin-top.c                 | 73 ++++++++++++++++--------
 tools/perf/ui/browsers/hists.c           | 95 +++++++++++++++++++++++++++-----
 tools/perf/ui/gtk/hists.c                | 13 ++++-
 tools/perf/ui/stdio/hist.c               |  7 ++-
 tools/perf/util/hist.c                   | 50 +++--------------
 tools/perf/util/hist.h                   | 14 ++---
 tools/perf/util/top.c                    | 23 ++++++--
 tools/perf/util/top.h                    |  1 +
 12 files changed, 222 insertions(+), 114 deletions(-)

-- 
1.7.11.7

