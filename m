Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199Ab3G2Rzk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 13:55:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31994 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752597Ab3G2Rzj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 13:55:39 -0400
Date: Mon, 29 Jul 2013 19:50:08 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Alexander Z Lam <azl@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Sharp <dhsharp@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/1] tracing: trace_remove_event_call() should fail if
	call/file is in use
Message-ID: <20130729175008.GA26284@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On top of "[PATCH v2 0/6] tracing: open/delete fixes" series.

Perhaps this series should be updated, Masami has some concerns.
But it seems that you both mostly agree with these changes, so
let me send the "last" patch for review.

The last change in kernel/trace/trace_events.c we need to close the
problems with create/use/delete (at least those which I know ;).

Now we are ready to change trace_kprobe.c and trace_uprobe.c, Steven
already has the patches.

Changes:

	- remove the TRACE_EVENT_FL_REF_MASK (which we do not have)
	  check.

	  We rely on the previous changes, we do not care if someone
	  have an opened file, event_enable_write/etc can do nothing
	  but fail after we do remove_event_file_dir().

	- Add the comment and a note into the changelog to explain
	  why we still need to check FTRACE_EVENT_FL_ENABLED.

Oleg.

 include/linux/ftrace_event.h |    2 +-
 kernel/trace/trace_events.c  |   35 +++++++++++++++++++++++++++++++++--
 2 files changed, 34 insertions(+), 3 deletions(-)

