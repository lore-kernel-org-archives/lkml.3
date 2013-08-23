Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295Ab3HWKM4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 06:12:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46463 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754276Ab3HWKMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 06:12:55 -0400
Date: Fri, 23 Aug 2013 12:12:49 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jiejing Zhang <jiejzhang@nvidia.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Jiejing Zhang <kzjeef@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eric Miao <emiao@nvidia.com>
Subject: Re: [PATCH] ftrace: add tgid information in task switch event.
Message-ID: <20130823101249.GR31370@twins.programming.kicks-ass.net>
References: <1377097520-24898-1-git-send-email-jasozhang@nvidia.com>
 <20130821110944.32bdf03a@gandalf.local.home>
 <20130821152305.GD31370@twins.programming.kicks-ass.net>
 <52171E4F.2020109@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52171E4F.2020109@nvidia.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 04:33:19PM +0800, Jiejing Zhang wrote:
> 
> On 08/21/2013 11:23 PM, Peter Zijlstra wrote:
> >On Wed, Aug 21, 2013 at 11:09:44AM -0400, Steven Rostedt wrote:
> >>>From: Jiejing Zhang <jiejzhang@nvidia.com>
> >>>
> >>>ftrace only report pid in task switch event, which is
> >>>actually thread ID in user space view, the comm of
> >>>the thread will be like "Thread-1", "Compiler", etc
> >>>in android system, it's useful if we can add tgid
> >>>information in ftrace event to find out the process
> >>>id, and the process id's comm will help us to figure
> >>>out the application, which was useful on data analysis
> >>>tools.
> >Meh.. are you telling me you really can't do that otherwise?
> >
> >Adding this information makes the tracepoint slower for everybody else.
> >How about you enable trace_sched_process_fork() and track things that
> >way?
> Thanks for the tip, I have tried fix this by avoid add tgid in ftrace,
> actually the relationship between thread and process can be figure by
> analysis these two command's output:
> `ps aTH -F` and `ps a -F`

Yeah, or prod around in /proc yourself.

> also with fork event, it can totally avoid add such a patch in kernel.

Kinda depends on when you start tracing, if you start tracing when
everything is already running you'll need a /proc state dump for the
current state and the fork tracepoint can then update you on new tasks.

Anyway, good to hear this works for you.
