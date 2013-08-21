Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150Ab3HUPXO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 11:23:14 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59683 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574Ab3HUPXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 11:23:13 -0400
Date: Wed, 21 Aug 2013 17:23:05 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jiejing Zhang <kzjeef@gmail.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Eric Miao <emiao@nvidia.com>, Jiejing Zhang <jiejzhang@nvidia.com>
Subject: Re: [PATCH] ftrace: add tgid information in task switch event.
Message-ID: <20130821152305.GD31370@twins.programming.kicks-ass.net>
References: <1377097520-24898-1-git-send-email-jasozhang@nvidia.com>
 <20130821110944.32bdf03a@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130821110944.32bdf03a@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 11:09:44AM -0400, Steven Rostedt wrote:
> > From: Jiejing Zhang <jiejzhang@nvidia.com>
> > 
> > ftrace only report pid in task switch event, which is
> > actually thread ID in user space view, the comm of
> > the thread will be like "Thread-1", "Compiler", etc
> > in android system, it's useful if we can add tgid
> > information in ftrace event to find out the process
> > id, and the process id's comm will help us to figure
> > out the application, which was useful on data analysis
> > tools.

Meh.. are you telling me you really can't do that otherwise?

Adding this information makes the tracepoint slower for everybody else.
How about you enable trace_sched_process_fork() and track things that
way?

Also, last time I tried to change one of these stupid tracepoints
userspace broke.. Rostedt says people should be using libtraceevent but
I'm sceptical.

> > Change-Id: Ia99f58a56d691d770b3beb2f76de0351e6194a4a

That needs to die.
