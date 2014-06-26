Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757102AbaFZQq4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 12:46:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24303 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754485AbaFZQqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 12:46:55 -0400
Date: Thu, 26 Jun 2014 18:45:16 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Christopher Covington <cov@codeaurora.org>, Ingo Molnar <mingo@redhat.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Vagin <avagin@openvz.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RFC: Add signal command to trace events
Message-ID: <20140626164516.GA24731@redhat.com>
References: <1403791044-2214-1-git-send-email-cov@codeaurora.org> <20140626111749.3234d4d4@gandalf.local.home> <20140626162943.GA9970@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140626162943.GA9970@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26, Oleg Nesterov wrote:
>
> > > +//ifdef CONFIG_TRACER_SIGNAL
> > > +static void
> > > +signal_trigger(struct event_trigger_data *data)
> > > +{
> > > +	force_sig(SIGSTOP, current);
>
> Well, I don't like this. Imho, it would be nice to avoid signals here.
>
> And SIGSTOP in particular. It can interfere with the "real" SIGSTOP
> sent by user, with ptrace, with tty.

And I forgot to mention, note that SIGSTOP stops the whole thread group,
this is not what we want.

> I think we need something else... "STOP" is actually simple, but we need
> some interface which allows to wakeup a task sleeping in TASK_KILLABLE
> after it hits ETT_FREEZE.

Yes...

Oleg.

