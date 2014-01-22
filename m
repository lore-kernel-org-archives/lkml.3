Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593AbaAVX3D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 18:29:03 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:52673 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbaAVX3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 18:29:01 -0500
X-AuditID: 9c93017d-b7b51ae000000e33-1e-52e0543586eb
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCHSET 0/5] perf tools: Update on filtered entries' percentage output (v3)
Date: Thu, 23 Jan 2014 08:28:48 +0900
Message-Id: <1390433333-15350-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I added --percentage option to perf report to control display of
percentage of filtered entries.

 usage: perf report [<options>]

        --percentage <relative|absolute>
                          how to display percentage of filtered entries

"relative" means it's relative to filtered entries only so that the
sum of shown entries will be always 100%.  "absolute" means it retains
original value before and after the filter applied.  In patch 5, I
made the "absolute" as default since it makes more sense IMHO.
    
      $ perf report -s comm
      # Overhead       Command
      # ........  ............
      #
          74.19%           cc1
           7.61%           gcc
           6.11%            as
           4.35%            sh
           4.14%          make
           1.13%        fixdep
      ...
    
      $ perf report -s comm -c cc1,gcc --percentage absolute
      # Overhead       Command
      # ........  ............
      #
          74.19%           cc1
           7.61%           gcc
    
      $ perf report -s comm -c cc1,gcc --percentage relative
      # Overhead       Command
      # ........  ............
      #
          90.69%           cc1
           9.31%           gcc
    
Note that it has zero effect if no filter was applied.

I only added the option to perf report for now.  If it looks good to
you I'll add it to perf top too.

Any comments are welcome, thanks
Namhyung


Namhyung Kim (5):
  perf tools: Count filtered entries to total period also
  perf ui/tui: Add support for showing relative percentage
  perf report: Add --percentage option
  perf report: Add report.percentage config option
  perf tools: Show absolute percentage by default

 tools/perf/Documentation/perf-report.txt | 24 ++++++++++++++++++------
 tools/perf/builtin-report.c              | 28 +++++++++++++++++++++++++++-
 tools/perf/util/event.c                  | 18 ++++++++----------
 tools/perf/util/hist.c                   | 27 ++++++++++++++-------------
 tools/perf/util/hist.h                   |  7 +++++++
 tools/perf/util/symbol.h                 |  5 +++--
 6 files changed, 77 insertions(+), 32 deletions(-)

-- 
1.7.11.7

