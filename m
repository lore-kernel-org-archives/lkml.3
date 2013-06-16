Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab3FPRZu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 13:25:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14335 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755324Ab3FPRZt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 13:25:49 -0400
Date: Sun, 16 Jun 2013 19:21:28 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] tracing/kprobes: trace_probe->files cleanups
Message-ID: <20130616172128.GA8515@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I simply can't understand why trace_kprobe.c uses
"struct ftrace_event_file **", the simple list_head looks much
more natural and simple.

And we do not want to copy-and-paste this code to trace_uprobe.c.
If there is a reason for array-of-pointers we should create the
helpers in the common trace_probe.c so that uprobes can use them
too.

Oleg.

 kernel/trace/trace_kprobe.c |  171 ++++++++++++------------------------------
 1 files changed, 49 insertions(+), 122 deletions(-)

