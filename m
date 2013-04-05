Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766007Ab3DEB0m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 21:26:42 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:50216 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765987Ab3DEB0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 21:26:41 -0400
X-AuditID: 9c93016f-b7c18ae000002f5f-c9-515e284e6078
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCHSET 0/8] perf tools: Cleanup for sort keys (v3)
Date: Fri,  5 Apr 2013 10:26:30 +0900
Message-Id: <1365125198-8334-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In this version, I've fixed up the last minute bug on hex print and
separate out SRCLINE reordering.

  $ perf report -s addr | grep -v ^# | sort -k2 -n


     0.00%            0x400523
     0.00%  0xffffffff81018140
     0.00%  0xffffffff810181a2
     0.00%  0xffffffff8101a41a
     0.00%  0xffffffff8101a977
     0.00%  0xffffffff810229da
     0.00%  0xffffffff8103becf
     ... 

The patches are in 'perf/sort-v5' branch on my tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git

Any comments are welcome, thanks.
Namhyung


Namhyung Kim (8):
  perf sort: Reorder HISTC_SRCLINE index
  perf sort: Add 'addr' sort key
  perf sort: Add 'addr_to/from' sort key
  perf sort: Update documentation for sort keys
  perf hists: Move column length setting code
  perf sort: Cleanup sort__has_sym setting
  perf top: Use sort__has_sym
  perf hist browser: Use sort__has_sym

 tools/perf/Documentation/perf-diff.txt   |  2 +-
 tools/perf/Documentation/perf-report.txt |  5 +-
 tools/perf/Documentation/perf-top.txt    |  2 +-
 tools/perf/builtin-diff.c                |  2 +-
 tools/perf/builtin-report.c              |  6 +--
 tools/perf/builtin-top.c                 | 15 ++----
 tools/perf/ui/browsers/hists.c           |  9 +---
 tools/perf/util/hist.c                   | 17 ++++---
 tools/perf/util/hist.h                   |  5 +-
 tools/perf/util/sort.c                   | 82 ++++++++++++++++++++++++++++++--
 tools/perf/util/sort.h                   |  3 ++
 tools/perf/util/top.h                    |  1 -
 12 files changed, 112 insertions(+), 37 deletions(-)

-- 
1.7.11.7

