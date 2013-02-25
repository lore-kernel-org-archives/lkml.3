Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759217Ab3BYJxW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 04:53:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18485 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759078Ab3BYJxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 04:53:17 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 0/5] perf tools: Fix -C option for record command
Date: Mon, 25 Feb 2013 10:52:47 +0100
Message-Id: <1361785972-7431-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
Oleg reported the -C option in record not work properly:
http://marc.info/?l=linux-kernel&m=136017986313315&w=2

The issue seems to be that the '-C X' target is considered
as task related when it comes to synthetizing threads. Adding
the fix plus some automated test cases.

Available in:
git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/linux.git
perf/oleg1

jirka


Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
---
Jiri Olsa (5):
      perf tools: Fix -C option for record command
      perf tests: Make attr script verbose friendly
      perf tests: Make attr script test event cpu
      perf tests: Add attr record -C cpu test
      perf tests: Add attr stat -C cpu test

 tools/perf/builtin-record.c          |  6 ++++--
 tools/perf/tests/attr.c              |  9 +++++++--
 tools/perf/tests/attr.py             |  5 +++--
 tools/perf/tests/attr/base-record    |  1 +
 tools/perf/tests/attr/base-stat      |  1 +
 tools/perf/tests/attr/test-record-C0 | 13 +++++++++++++
 tools/perf/tests/attr/test-stat-C0   |  9 +++++++++
 7 files changed, 38 insertions(+), 6 deletions(-)
 create mode 100644 tools/perf/tests/attr/test-record-C0
 create mode 100644 tools/perf/tests/attr/test-stat-C0
