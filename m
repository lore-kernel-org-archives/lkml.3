Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555AbaCBP5M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 10:57:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45049 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519AbaCBP5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 10:57:10 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 0/3] perf: Disable user space dumps for function trace event
Date: Sun,  2 Mar 2014 16:56:37 +0100
Message-Id: <1393775800-13524-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
recent issues with user space callchains processing within
page fault handler tracing showed as Peter said 'there's
just too much fail surface'.

Related list discussions:
  http://marc.info/?t=139302086500001&r=1&w=2
  http://marc.info/?t=139301437300003&r=1&w=2

Disabling user space callchain and stack dump for
function trace event. Plus updating the perf tool
to keep up with those changes.

Reachable here:

thanks,
jirka


Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
Jiri Olsa (3):
      perf: Disallow user space callchains for function trace event
      perf: Disallow user space stack dump for function trace event
      perf tools: Disable user space callchain/stack for function trace event

 kernel/trace/trace_event_perf.c | 22 +++++++++++++++++++---
 tools/perf/util/evsel.c         | 41 ++++++++++++++++++++++++++++++-----------
 tools/perf/util/evsel.h         | 18 ++++++++++++++++++
 3 files changed, 67 insertions(+), 14 deletions(-)
