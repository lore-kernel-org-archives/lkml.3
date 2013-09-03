Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab3ICOeJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 10:34:09 -0400
Received: from a10-51.smtp-out.amazonses.com ([54.240.10.51]:53259 "EHLO
	a10-51.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753275Ab3ICOeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 10:34:07 -0400
Date: Tue, 3 Sep 2013 14:34:04 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Steven Rostedt <rostedt@goodmis.org>
cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [gcv v3 08/35] tracing: Replace __get_cpu_var uses
In-Reply-To: <20130829172622.3b458a80@gandalf.local.home>
Message-ID: <00000140e43e9da0-5a024162-7eb8-4642-a801-30b8a8153138-000000@email.amazonses.com>
References: <20130828193457.140443630@linux.com> <00000140c6781ceb-6c3e93f5-45d6-4b04-8034-e7cd4b5a77b5-000000@email.amazonses.com> <20130829172622.3b458a80@gandalf.local.home>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="376175846-1778199093-1378218876=:17065"
X-SES-Outgoing: 2013.09.03-54.240.10.51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--376175846-1778199093-1378218876=:17065
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 29 Aug 2013, Steven Rostedt wrote:

> On Wed, 28 Aug 2013 19:48:16 +0000
>
> > Index: linux/kernel/trace/trace.c
> > ===================================================================
> > --- linux.orig/kernel/trace/trace.c	2013-08-26 14:25:53.000000000 -0500
> > +++ linux/kernel/trace/trace.c	2013-08-26 14:26:29.464993617 -0500
> > @@ -1676,7 +1676,7 @@ static void __ftrace_trace_stack(struct
> >  	 */
> >  	barrier();
> >  	if (use_stack == 1) {
> > -		trace.entries		= &__get_cpu_var(ftrace_stack).calls[0];
> > +		trace.entries		= this_cpu_ptr(ftrace_stack.calls);
> >  		trace.max_entries	= FTRACE_STACK_MAX_ENTRIES;
> >
> >  		if (regs)
>
>
> This patch fails to build:
>
> kernel/trace/trace.c: In function ‘__ftrace_trace_stack’:
> kernel/trace/trace.c:1679:20: error: cast specifies array type

That is because you did not apply the first patch of this series that
fixes a bug in the macros.

--376175846-1778199093-1378218876=:17065--
