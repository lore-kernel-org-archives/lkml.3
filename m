Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab3GVNsZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 09:48:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7466 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755194Ab3GVNsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 09:48:24 -0400
Date: Mon, 22 Jul 2013 15:43:13 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Alexander Z Lam <azl@google.com>, David Sharp <dhsharp@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] tracing: Kill the buggy trace_cpu
Message-ID: <20130722134313.GA18328@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Only slightly tested so far. I'll try to test more and report
the results.

Meanwhile it would be nice if you can take a look and review.


This series kills tracing_open_generic_tc/trace_cpu/etc.

trace_array_get(inode->i_private) is mostly fine, we do not
dereference this pointer untill trace_array_get() succeeds.
But trace_array_get(tc->tr) is wrong by the same reason why
tracing_open_generic_file/etc are wrong, see 1/7.

And not only trace_cpu is buggy, we can simplify the code if
we kill this member.

Oleg.

 kernel/trace/trace.c |  192 ++++++++++++++++++++------------------------------
 kernel/trace/trace.h |    8 --
 2 files changed, 76 insertions(+), 124 deletions(-)

