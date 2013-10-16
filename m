Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934518Ab3JPNV3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 09:21:29 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:41945 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934451Ab3JPNV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 09:21:26 -0400
Date: Wed, 16 Oct 2013 15:21:23 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Liu Chuansheng <chuansheng.liu@intel.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 2/3] core: Convert printk_once to use DO_ONCE
Message-ID: <20131016132121.GA14938@localhost.localdomain>
References: <1381870252-5430-1-git-send-email-fweisbec@gmail.com>
 <1381870252-5430-3-git-send-email-fweisbec@gmail.com>
 <1381870805.22110.37.camel@joe-AO722>
 <20131015211251.GE3269@localhost.localdomain>
 <1381872280.22110.41.camel@joe-AO722>
 <20131016115354.GC12773@localhost.localdomain>
 <20131016085928.5b8f9d95@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131016085928.5b8f9d95@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 08:59:28AM -0400, Steven Rostedt wrote:
> On Wed, 16 Oct 2013 13:53:56 +0200
> Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
>  
> > static int done;
> > 
> > if (!done) {
> >     trace_printk(something);
> >     trace_printk(something else);
> >     trace_dump_stack();
> >     done = 1;
> > }
> > 
> > Having a DO_ONCE() would help a lot I think.
> > 
> > Now we can rename it to __DO_ONCE() and put a big fat comment to avoid it
> > to be misused.
> 
> I wonder if we should make it just ONCE(), with no arguments that
> should go into an if statement.
> 
> 
> if (ONCE())
> 	do_this_function_once();

Or TRUE_ONCE() may be?
But what don't you like in DO_ONCE()? Its upside is that it consolidate the whole
call.

Also there is still the COND() part to handle. Note that COND things
need to return the condition as well.

Thanks.

> 
> 
> Where ONCE() is:
> 
> ({
> 	static int __once;
> 	int __old_once = __once;
> 
> 	__once = 1;
> 	__old_once;
> })
> 
> Or the xchg version:
> 
> ({
> 	static int __once;
> 
> 	if (!__once)
> 		xchg(&__once, 1);
> 	else
> 		1;
> })
> 
> -- Steve
