Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796Ab3GIII7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 04:08:59 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49645 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218Ab3GIII5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 04:08:57 -0400
Date: Tue, 9 Jul 2013 10:07:45 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Andrew Morton <akpm@linux-foundation.org>, jovi.zhangwei@huawei.com,
        Jiri Olsa <jolsa@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH] tracing/kprobe: Wait for disabling all running
 kprobe handlers
Message-ID: <20130709080744.GH25631@dyad.programming.kicks-ass.net>
References: <20130708142533.GA23749@redhat.com>
 <20130709080145.7975.83164.stgit@mhiramat-M0-7522>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130709080145.7975.83164.stgit@mhiramat-M0-7522>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 09, 2013 at 05:01:45PM +0900, Masami Hiramatsu wrote:
> +	if (wait) {
> +		/*
> +		 * synchronize with kprobe_trace_func/kretprobe_trace_func
> +		 * to ensure disabled (all running handlers are finished)
> +		 */
> +		synchronize_sched();
> +		kfree(link);	/* Ignored if link == NULL */
> +	}

What's not clear to me from this comment is if we're only waiting for kfree()?
In that case shouldn't we use call_rcu() to free the thing? Or do we need the
sync_sched() for other purposes as well?
