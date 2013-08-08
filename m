Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757633Ab3HHCvK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 22:51:10 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:44525 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512Ab3HHCvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 22:51:09 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org, mingo@kernel.org
Cc: David Ahern <dsahern@gmail.com>
Subject: [PATCH 00/19] perf sched: Add timehist subcommand
Date: Wed,  7 Aug 2013 22:50:42 -0400
Message-Id: <1375930261-77273-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo/Arnaldo:

I have a lot of patches queued up on top of this set. Before I go much farther
and the queue grows longer I wanted to throw out this set for comments, review
and inclusion where possible. Most of the patches are cleanups and re-workings
leading up to the new command. The patches I have after this continue to add
more features and options to the timehist command to match what I have been
using for the past few years.

David Ahern (19):
  perf: sample after exit loses thread correlation - v3
  perf sched: simplify arguments to read_events
  perf sched: remove thread lookup in sample handler
  perf sched: remove sched_process_exit tracepoint
  perf sched: remove sched_process_fork tracepoint
  perf symbol: add optimization for idle kernel symbols
  perf top: use new idle_sym check
  perf symbol: save vmlinux or kallsyms path loaded
  perf tool: Simplify options to perf_evsel__print_ip
  perf tool: Add option to print stack trace on single line
  perf tool: Add option to limit stack depth in callchain dumps
  perf tool: Add support for exclude symbol list to symbol_conf
  perf tool: Skip symbols in exclude list while printing callchain
  perf sched: pass event to evsel handlers using data element
  perf sched: Add timehist command
  perf tool: Change perf_session__has_traces to actually check for tracepoints
  perf sched timehist: add support for context-switch event
  perf sched timehist: print all events in verbose mode
  perf sched timehist: add pid/tid option

 tools/perf/builtin-sched.c  |  959 ++++++++++++++++++++++++++++++++++++++++---
 tools/perf/builtin-script.c |   29 +-
 tools/perf/builtin-top.c    |   25 +-
 tools/perf/util/machine.c   |   37 +-
 tools/perf/util/session.c   |   39 +-
 tools/perf/util/session.h   |    8 +-
 tools/perf/util/symbol.c    |   71 +++-
 tools/perf/util/symbol.h    |    8 +-
 8 files changed, 1063 insertions(+), 113 deletions(-)

-- 
1.7.10.1

