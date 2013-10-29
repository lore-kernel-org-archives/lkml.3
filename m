Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819Ab3J2TJF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 15:09:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29244 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195Ab3J2TJC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 15:09:02 -0400
Date: Tue, 29 Oct 2013 20:10:16 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Dave Sullivan <dsulliva@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] hung_task debugging: Add tracepoint to report the
	hang
Message-ID: <20131029191016.GB27834@redhat.com>
References: <20131019161807.GA7431@redhat.com> <20131019161828.GA7439@redhat.com> <20131020084837.GB16236@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131020084837.GB16236@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20, Ingo Molnar wrote:
>
> * Oleg Nesterov <oleg@redhat.com> wrote:
>
> > Currently check_hung_task() prints a warning if it detects the problem,
> > but it is not convenient to watch the system logs if user-space wants to
> > be notified about the hang.
> >
> > Add the new trace_sched_process_hang() into check_hung_task(), this way
> > a user-space monitor can easily wait for the hang and potentially
> > resolve a problem.
>
> I'm wondering, is the data of trace_console() in kernel/printk/printk.c
> not sufficient?

Probably yes... I do not think they disable CONFIG_PRINTK.

But this is obviously much less convenient, they will need to parse the
text. And the user-space watchdog will be woken up much more often than
necessary. And they could probably simply read /var/log or interact with
syslogd somehow, but they specially asked for something better and more
robust.

But of course, I understand that every tracepoint should be justified.
So if you do not like this change I try to convince them to use
trace_console().

> If it's not enough then it might be better to add a higher level printk
> tracepoint instead - that can catch hung_task messages and (much) more.

Not sure I understand... I mean I do not understand why this is really
better for them, except this will simplify the parsing a bit. Anyway
I'd prefer to not send another doubtful patch ;)

Thanks.

Oleg.

