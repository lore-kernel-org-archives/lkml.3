Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759353Ab3GZRbv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 13:31:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61403 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080Ab3GZRbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 13:31:47 -0400
Date: Fri, 26 Jul 2013 19:25:13 +0200
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
Subject: [PATCH v2 0/6] tracing: open/delete fixes
Message-ID: <20130726172513.GA3586@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Testing: seems to work, but assumes that debugs was fixed too. Hopefully
"debugfs: debugfs_remove_recursive() must not rely on list_empty(d_subdirs)"
is fine.

(We should probably make debugfs_remove_recursive() to return the error
 and trace_events.c should warn if it fails)

However: I am still testing this patches, so this is still mostly for
review. I'll report if I find anything, but to remind we have other
bugs which need more fixes. And in fact I need to re-read this series
to convince myself it should work, I was distracted by the unexpected
problem in debugfs.

Changes: a lot but all cosmetic, addresses the comments from Steven.

Steven, 1/6 was not changed, I assume you agreed with my reply.

Masami, I'll appreciate your review ;)

Oleg.

 kernel/trace/trace_events.c        |  155 +++++++++++++++++++-----------------
 kernel/trace/trace_events_filter.c |   17 ++---
 2 files changed, 87 insertions(+), 85 deletions(-)

