Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611Ab3BDTDn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 14:03:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55056 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753593Ab3BDTDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 14:03:42 -0500
Date: Mon, 4 Feb 2013 20:02:25 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Anton Arapov <anton@redhat.com>, Frank Eigler <fche@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Josh Stone <jistone@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] uprobes/perf: pre-filtering
Message-ID: <20130204190225.GA10840@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Based on git://git.kernel.org/pub/scm/linux/kernel/git/oleg/misc uprobes/core,
on top of "[PATCH 0/5] uprobes: kill uprobe_trace_consumer and other cleanups"
series.

With this series 'perf record -e uprobe ...' does not install the breakpoints
into the processes it doesn't want to probe.

Probably this all needs more testing (the last patch for sure) but please
review. I'll try to do more testing tomorrow.

A special note about 1/7. It was actually needed for initial implementation,
this version doesn't need it. Still I am sending it at least for review, it
looks "natural" and potentially useful, and I would like to know if it is
correct or not.

Oleg.

 include/linux/perf_event.h  |    9 ++-
 include/linux/uprobes.h     |    6 ++
 kernel/events/core.c        |   29 +++++----
 kernel/events/uprobes.c     |   39 ++++++++++-
 kernel/trace/trace_uprobe.c |  152 ++++++++++++++++++++++++++++++++++++++++---
 5 files changed, 206 insertions(+), 29 deletions(-)

