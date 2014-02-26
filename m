Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150AbaBZTGu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 14:06:50 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:41269 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753419AbaBZTGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 14:06:45 -0500
Message-Id: <20140226190140.590029589@goodmis.org>
User-Agent: quilt/0.61-1
Date: Wed, 26 Feb 2014 14:01:40 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFA][PATCH 0/4] tracing: Request for acks on fixing tracepoint code
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Request for Acks ]

Due to module tainting, we have tracepoints that silently do not work.
That will be solved another way. But the trace event infrastructure should
not be created for tainted modules. That is, the debugfs files should
not exist for them.

By moving the tracepoint module taint test into tracepoint.h, we can
reuse that same test when creating the module tracepoint events.

Note, I had to remove the tracepoint.h include from module.h as there
was nothing in module.h that required tracepoint.h, but this broke
a couple of event files (migrate.h and writeback.h) because they did
not include tracepoint.h, and were just lucky that it was included
by module.h.

Steven Rostedt (Red Hat) (4):
      tracing: Fix event header writeback.h to include tracepoint.h
      tracing: Fix event header migrate.h to include tracepoint.h
      tracing/module: Remove include of tracepoint.h from module.h
      tracing: Do not add event files for modules that fail tracepoints

----
 include/linux/module.h           |  1 -
 include/linux/tracepoint.h       |  7 +++++++
 include/trace/events/migrate.h   |  2 ++
 include/trace/events/writeback.h |  1 +
 kernel/trace/trace_events.c      |  4 ++++
 kernel/tracepoint.c              |  2 +-
 6 files changed, 23 insertions(+), 21 deletions(-)
