Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757900Ab3DALf2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 07:35:28 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:59262 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757727Ab3DALf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 07:35:27 -0400
X-AuditID: 9c930179-b7c78ae000000e4b-81-515970fd1857
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCHSET 0/9] perf tools: Bug fix and cleanup for sort keys
Date: Mon,  1 Apr 2013 20:35:16 +0900
Message-Id: <1364816125-12212-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a couple of bugfix, cleanup and enhancement for sort keys.

When I rebased previous --sort addr* patches, I found that separating
sort mode might be helpful to users so I did the cleanup.  But during
the test I, in turn, found a bug in freeing the branch info of a hist
entry.  And the mem info patch is only compile-tested - it'd be great
if Stephane could take a look and help to test.

You can get it from 'perf/sort-v3' branch on my tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git


Any comments are welcome, thanks.
Namhyung


Namhyung Kim (9):
  perf hists: Fix an invalid memory free on he->branch_info
  perf hists: Free unused mem info of a matched hist entry
  perf report: Fix alignment of symbol column when -v is given
  perf sort: Introduce sort__mode variable
  perf sort: Separate out memory-specific sort keys
  perf sort: Add 'addr' sort key
  perf sort: Add 'addr_to/from' sort key
  perf sort: Update documentation for sort keys
  perf hists: Move column length setting code

 tools/perf/Documentation/perf-diff.txt   |   2 +-
 tools/perf/Documentation/perf-report.txt |   5 +-
 tools/perf/Documentation/perf-top.txt    |   2 +-
 tools/perf/builtin-diff.c                |   2 +-
 tools/perf/builtin-report.c              |  40 ++++++----
 tools/perf/builtin-top.c                 |   3 +-
 tools/perf/ui/browsers/hists.c           |   4 +-
 tools/perf/util/hist.c                   |  63 ++++++++++-----
 tools/perf/util/hist.h                   |   5 +-
 tools/perf/util/sort.c                   | 129 ++++++++++++++++++++++++++++---
 tools/perf/util/sort.h                   |  30 ++++---
 11 files changed, 223 insertions(+), 62 deletions(-)

-- 
1.7.11.7

