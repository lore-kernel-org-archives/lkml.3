Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761939Ab3DCM0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 08:26:24 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:48225 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761171Ab3DCM0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 08:26:22 -0400
X-AuditID: 9c93016f-b7c18ae000002f5f-7a-515c1fecd821
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCHSET 00/10] perf tools: Cleanup for sort keys (v2)
Date: Wed,  3 Apr 2013 21:26:09 +0900
Message-Id: <1364991979-3008-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is a second version of my sort key cleanup series.  I Added
helper function for adding sort key and used unmap_ip() function for
printing symbol address as Jiri commented.  But didn't change name of
the sort keys to 'ip'.  If you really think I should change, I'm okay
to do it though.  I also cleaned up sort__has_sym and sort key eliding
code in this version.

You can get it from 'perf/sort-v4' branch on my tree at:

  git://git.kernel.org/pub/scm/linux/kernel/namhyung/linux-perf.git


Any comments are welcome, thanks.
Namhyung


Namhyung Kim (10):
  perf sort: Factor out common code in sort_dimension__add()
  perf sort: Separate out memory-specific sort keys
  perf sort: Add 'addr' sort key
  perf sort: Add 'addr_to/from' sort key
  perf sort: Update documentation for sort keys
  perf hists: Move column length setting code
  perf sort: Cleanup sort__has_sym setting
  perf top: Use sort__has_sym
  perf hist browser: Use sort__has_sym
  perf sort: Consolidate sort_entry__setup_elide()

 tools/perf/Documentation/perf-diff.txt   |   2 +-
 tools/perf/Documentation/perf-report.txt |   5 +-
 tools/perf/Documentation/perf-top.txt    |   2 +-
 tools/perf/builtin-diff.c                |   6 +-
 tools/perf/builtin-report.c              |  28 +----
 tools/perf/builtin-top.c                 |  19 +--
 tools/perf/ui/browsers/hists.c           |   9 +-
 tools/perf/util/hist.c                   |  17 +--
 tools/perf/util/hist.h                   |   5 +-
 tools/perf/util/sort.c                   | 201 +++++++++++++++++++++++++------
 tools/perf/util/sort.h                   |  25 ++--
 tools/perf/util/top.h                    |   1 -
 12 files changed, 218 insertions(+), 102 deletions(-)

-- 
1.7.11.7

