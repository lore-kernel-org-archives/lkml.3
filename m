Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199Ab3GQToO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 15:44:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757109Ab3GQToM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 15:44:12 -0400
Date: Wed, 17 Jul 2013 21:39:00 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/4] tracing: Turn "id"->i_private into
	call->event.type
Message-ID: <20130717193900.GA15667@redhat.com>
References: <20130716185723.GA21193@redhat.com> <1374004146.6458.57.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374004146.6458.57.camel@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16, Steven Rostedt wrote:
>
> On Tue, 2013-07-16 at 20:57 +0200, Oleg Nesterov wrote:
> > ftrace_event_id_fops and event_id_read() is overcomplicated.
> >
> > 1. Change event_create_dir() to pass "data = call->event.type"
> >    to debugfs_create_file().
> >
> >    This means that ftrace_event_id_fops doesn't need .open()
> >    and event_id_read() can simply print (int)i_private
> >
> > 2. event_id_read() has no reason to kmalloc "struct trace_seq"
> >    (more than PAGE_SIZE!), it can use a small buffer.
>
> Make #2 a separate patch. You can add it before this one.

OK. I'll extract #2 and re-send.

Oleg.

