Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950Ab3LLHgY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 02:36:24 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:63830 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab3LLHgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 02:36:20 -0500
X-AuditID: 9c93016f-b7c57ae0000070d3-c3-52a96771d8ad
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCHSET 00/14] tools lib traceevent: Get rid of *die() calls from parse-filter.c (v2)
Date: Thu, 12 Dec 2013 16:36:03 +0900
Message-Id: <1386833777-3790-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset tries to remove all die() calls in event filter parsing
code.  I changed two main functions of pevent_filter_add_filter_str()
and pevent_filter_match() to return a proper error code (pevent_errno).

The actual error message might be saved in a static buffer in pevent_
filter and it can be accessed by new pevent_filter_strerror() function.
The old pevent_strerror() still works for them too.

The only remaining bits are in trace-seq.c which implement print
functions and I want to hear what's the best way we can handle the
error case during the print.

I also put this patches on libtraceevent/die-removal-v2 branch in my tree

  git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git


Any comments are welcome, thanks
Namhyung


Namhyung Kim (14):
  tools lib traceevent: Get rid of malloc_or_die() in show_error()
  tools lib traceevent: Get rid of die in add_filter_type()
  tools lib traceevent: Get rid of malloc_or_die() allocate_arg()
  tools lib traceevent: Get rid of malloc_or_die() in read_token()
  tools lib traceevent: Get rid of malloc_or_die() in find_event()
  tools lib traceevent: Get rid of die() in add_right()
  tools lib traceevent: Make add_left() return pevent_errno
  tools lib traceevent: Get rid of die() in reparent_op_arg()
  tools lib traceevent: Refactor create_arg_item()
  tools lib traceevent: Refactor process_filter()
  tools lib traceevent: Make pevent_filter_add_filter_str() return
    pevent_errno
  tools lib traceevent: Refactor pevent_filter_match() to get rid of
    die()
  tools lib traceevent: Get rid of die() in some string conversion
    funcitons
  tools lib traceevent: Introduce pevent_filter_strerror()

 tools/lib/traceevent/event-parse.c  |  17 +-
 tools/lib/traceevent/event-parse.h  |  48 ++-
 tools/lib/traceevent/parse-filter.c | 615 ++++++++++++++++++++++--------------
 3 files changed, 417 insertions(+), 263 deletions(-)

-- 
1.7.11.7

