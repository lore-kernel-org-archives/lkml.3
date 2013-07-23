Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933949Ab3GWVES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 17:04:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39635 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932567Ab3GWVER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 17:04:17 -0400
Date: Tue, 23 Jul 2013 22:58:54 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Alexander Z Lam <azl@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Sharp <dhsharp@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] tracing: open/delete fixes
Message-ID: <20130723205854.GA9036@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Untested again, only for review. Sorry, I know this is annoying.
Will try to test tomorrow.

The only essential change is that "clear d_subdirs->i_private"
comes as a last patch, this needs the additional comment in the
changelogs of 1-4 but avoids the temporary complications.

I am sending this series right now because:

	- I promised to do this today ;)

	- Whatever I do, correctness-wise this needs your review
	  anyway.

	- Even if correct, the very intent needs an ack from Masami
	  who seems to disagree with this approach.

	  This series shifts the validation from f_op->open() (which
	  currently doesn't work) to ->read/write.

	  While I personally think this makes more sense (simpler
	  and does not block rmdir/event_remove), I understand that
	  this is subjective, so I won't argue too much if you prefer
	  to add the additional ref-counts instead.

>From 6/6:

	Note: this doesn't not fix other problems, event_remove() can
	destroy the active ftrace_event_call, we need more changes but
	those changes are completely orthogonal.

Oleg.

 kernel/trace/trace.h               |    4 +-
 kernel/trace/trace_events.c        |  176 ++++++++++++++++++------------------
 kernel/trace/trace_events_filter.c |   21 ++---
 3 files changed, 99 insertions(+), 102 deletions(-)

