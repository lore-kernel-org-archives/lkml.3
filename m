Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab3KAHdS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 03:33:18 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:62010 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928Ab3KAHdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 03:33:17 -0400
X-AuditID: 9c930179-b7c9bae000000e4c-10-5273593ba198
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCHSET 0/5] perf tools: Enhance option parsing error message
Date: Fri,  1 Nov 2013 16:33:10 +0900
Message-Id: <1383291195-24386-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset tries to enhance error message when perf failed to parse
option argument.  Currently it just shows entire usage and options
which may fill two pages of screen.  It's hard for me to say it's
really helpful to users. ;-)

With this patch series, it changed to show only related option(s).
There're also more points to improve yet - like auto-breaking long
lines, dealing with UIs and so on.  But I believe this will be a good
start.

  $ perf report -g help

   usage: perf report [<options>]

      -g, --call-graph <output_type,min_percent[,print_limit],call_order>
                          Display callchains using output_type (graph, flat, fractal, or none) , min percent threshold, optional print limit, callchain order, key (function or address). Default: fractal,0.5,callee,function

  $ perf stat -Bx, ls
  -B option not supported with -x

   usage: perf stat [<options>] [<command>]

      -B, --big-num         print large numbers with thousands' separators
      -x, --field-separator <separator>
                            print counts with custom separator


You can get this on 'perf/option-v1' branch in my tree

  git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git


Thanks,
Namhyung


Namhyung Kim (5):
  perf tools: Show single option when failed to parse
  perf report: Postpone setting up browser after parsing options
  perf report: Use parse_options_usage() for -s option failure
  perf top: Use parse_options_usage() for -s option failure
  perf stat: Enhance option parse error message

 tools/perf/builtin-report.c     |  30 +++---
 tools/perf/builtin-stat.c       |  42 +++++---
 tools/perf/builtin-top.c        |   8 +-
 tools/perf/util/parse-options.c | 218 ++++++++++++++++++++++++----------------
 tools/perf/util/parse-options.h |   4 +-
 5 files changed, 181 insertions(+), 121 deletions(-)

-- 
1.7.11.7

