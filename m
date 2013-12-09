Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760036Ab3LIFeR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 00:34:17 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:61198 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608Ab3LIFeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 00:34:14 -0500
X-AuditID: 9c930197-b7bdbae000000e78-58-52a55653edcc
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCHSET 00/14] tools lib traceevent: Get rid of *die() calls from parse-filter.c
Date: Mon,  9 Dec 2013 14:33:57 +0900
Message-Id: <1386567251-22751-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset tries to remove all die() calls in event filter parsing
code.  The only remaining bits are in trace-seq.c which implement
print functions and I want to hear what's the best way we can handle
the error case during the print.

I also put this patches on libtraceevent/die-removal-v1 branch in my tree

  git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git


Any comments are welcome, thanks
Namhyung


Namhyung Kim (14):
  tools lib traceevent: Get rid of malloc_or_die() in show_error()
  tools lib traceevent: Get rid of die in add_filter_type()
  tools lib traceevent: Get rid of malloc_or_die() in
    pevent_filter_alloc()
  tools lib traceevent: Get rid of malloc_or_die() allocate_arg()
  tools lib traceevent: Get rid of malloc_or_die() in read_token()
  tools lib traceevent: Get rid of malloc_or_die() in find_event()
  tools lib traceevent: Get rid of malloc_or_die() in add_event()
  tools lib traceevent: Get rid of die() in create_arg_item()
  tools lib traceevent: Get rid of die() in add_right()
  tools lib traceevent: Get rid of die() in reparent_op_arg()
  tools lib traceevent: Get rid of malloc_or_die() in
    pevent_filter_add_filter_str()
  tools lib traceevent: Get rid of die() in
    pevent_filter_clear_trivial()
  tools lib traceevent: Refactor test_filter() to get rid of die()
  tools lib traceevent: Get rid of die() in some string conversion
    funcitons

 tools/lib/traceevent/event-parse.h  |   3 +-
 tools/lib/traceevent/parse-filter.c | 432 +++++++++++++++++++++++++-----------
 2 files changed, 303 insertions(+), 132 deletions(-)

-- 
1.7.11.7

