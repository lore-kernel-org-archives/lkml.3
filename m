Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751728AbaLCDVM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 22:21:12 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:54951 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751077AbaLCDVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 22:21:08 -0500
Message-Id: <20141203031334.174087814@goodmis.org>
User-Agent: quilt/0.61-1
Date: Tue, 02 Dec 2014 22:13:34 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Theodore Tso <tytso@mit.edu>, Alexei Starovoitov <ast@plumgrid.com>
Subject: [PATCH 0/3] tracing: Add event filter logic for !(...)
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no changes to the first patch that you can see from here:

  http://lkml.kernel.org/r/20141202153548.1ce7177e@gandalf.local.home

But I added two more patches:

 1) adds the logic to do ! with the AND and OR cases. Like:

  !(prev_pid == 0 && next_pid == 1)

 2) I added ftracetests selftest to test a bunch of filter cases.
    I can probably add more, but this is a start.

Steven Rostedt (Red Hat) (3):
      tracing: Add NOT to filtering logic
      tracing: Allow NOT to filter AND and OR clauses
      ftracetests: Add test to test event filter logic

----
 kernel/trace/trace_events_filter.c                 |  29 ++-
 .../selftests/ftrace/test.d/ftrace/filter.tc       | 200 +++++++++++++++++++++
 2 files changed, 223 insertions(+), 6 deletions(-)
