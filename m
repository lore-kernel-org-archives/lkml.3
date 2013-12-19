Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773Ab3LSNmd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 08:42:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40951 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754417Ab3LSNm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 08:42:29 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 0/9] tools: Factor traceevent/perf Makefile
Date: Thu, 19 Dec 2013 14:41:58 +0100
Message-Id: <1387460527-15030-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
sending out the change to introduce single:
  INSTALL trace_plugins
build output line. Some more code factoring was needed.

Also updated the tests/make install tests to check for
installed plugins.

thanks,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: David Ahern <dsahern@gmail.com>
---
Jiri Olsa (9):
      perf tests: Factor make install tests
      perf tools: Making QUIET_(CLEAN|INSTAL) variables global
      tools lib traceevent: Remove print_app_build variable
      tools lib traceevent: Use global QUIET_CC build output
      tools lib traceevent: Add global QUIET_CC_FPIC build output
      tools lib traceevent: Use global QUIET_LINK build output
      tools lib traceevent: Use global QUIET_INSTALL build output
      tools lib traceevent: Use global QUIET_CLEAN build output
      tools lib traceevent: Use global 'O' processing code

 tools/lib/traceevent/Makefile   | 85 ++++++++++++++++++++++++++++---------------------------------------------------------
 tools/perf/config/utilities.mak |  7 -------
 tools/perf/tests/make           | 38 ++++++++++++++++++++++++++++++++------
 tools/scripts/Makefile.include  |  4 ++++
 4 files changed, 64 insertions(+), 70 deletions(-)
