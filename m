Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004Ab3KRUdA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 15:33:00 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:60054 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140Ab3KRUc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 15:32:58 -0500
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>
Subject: [PATCH 0/8] perf: sched timehist command
Date: Mon, 18 Nov 2013 13:32:43 -0700
Message-Id: <1384806771-2945-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.8.3.4 (Apple Git-47)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the latest incarnation of the timehist command; this time integrated
into perf-sched. Patches can also be found here:

    https://github.com/dsahern/linux perf-timehist

I have other options ready to go, but this seems like a good point to push
out for review.

David Ahern (8):
  perf tool: Skip ignored symbols while printing callchain
  perf symbols: Move idle syms check from top to generic function
  perf symbol: Save vmlinux or kallsyms path loaded
  perf thread: Move comm_list check into function
  perf tool: export setup_list
  perf sched: Introduce timehist command
  perf sched timehist: Add support for context-switch event
  perf sched : Add documentation for timehist options

 tools/perf/Documentation/perf-sched.txt |   60 +-
 tools/perf/builtin-sched.c              | 1002 ++++++++++++++++++++++++++++++-
 tools/perf/builtin-top.c                |   25 +-
 tools/perf/util/event.c                 |    3 +-
 tools/perf/util/session.c               |   10 +-
 tools/perf/util/symbol.c                |   39 +-
 tools/perf/util/symbol.h                |    4 +
 tools/perf/util/thread.h                |   12 +
 8 files changed, 1124 insertions(+), 31 deletions(-)

-- 
1.8.3.4 (Apple Git-47)

