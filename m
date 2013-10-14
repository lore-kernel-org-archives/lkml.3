Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab3JNIYa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 04:24:30 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:65160 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab3JNIY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 04:24:28 -0400
X-AuditID: 9c93016f-b7c63ae00000696f-0d-525baa3ae562
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCHSET 0/4] ftrace: Add support to set_graph_notrace filter (v2)
Date: Mon, 14 Oct 2013 17:24:22 +0900
Message-Id: <1381739066-7531-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

I broke the patch into pieces so that it can address what you said.
The patch 1 and 2 are cleanup and preparation you mentioned.  Patch 3
is an one more cleanup I found during the work.  Patch 4 is core of
this patchset and main diferrence to prior version is added comments.

This is based on the current linux-trace/for-next.

I also put this on 'ftrace/nograph-v2' branch in my tree

  git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git

Any comments are welcome, thanks.
Namhyung


Namhyung Kim (4):
  ftrace: Get rid of ftrace_graph_filter_enabled
  ftrace: Introduce struct ftrace_graph_data
  ftrace: Narrow down the protected area of graph_lock
  ftrace: Add set_graph_notrace filter

 include/linux/ftrace.h               |   1 +
 kernel/trace/ftrace.c                | 140 ++++++++++++++++++++++++++---------
 kernel/trace/trace.h                 |  25 ++++++-
 kernel/trace/trace_functions_graph.c |  56 +++++++++++++-
 4 files changed, 181 insertions(+), 41 deletions(-)

-- 
1.7.11.7

