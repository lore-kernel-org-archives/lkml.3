Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667AbbAOWsA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 17:48:00 -0500
Received: from ozlabs.org ([103.22.144.67]:60636 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752896AbbAOWr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 17:47:58 -0500
Message-ID: <1421362067.23332.4.camel@ellerman.id.au>
Subject: Re: [PATCH] tracing: Allow raw_syscall tracepoints to work from boot
From: Michael Ellerman <mpe@ellerman.id.au>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, paulmck@linux.vnet.ibm.com,
        Andrew Morton <akpm@osdl.org>, tglx@linutronix.de,
        mathieu.desnoyers@efficios.com, xiakaixu@huawei.com
Date: Fri, 16 Jan 2015 09:47:47 +1100
In-Reply-To: <20150115085817.46708f7f@grimm.local.home>
References: <1421188517-18312-1-git-send-email-mpe@ellerman.id.au>
	 <20150114130300.75c5d2ce@gandalf.local.home>
	 <1421302240.11409.6.camel@ellerman.id.au>
	 <20150115085817.46708f7f@grimm.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2015-01-15 at 08:58 -0500, Steven Rostedt wrote:
> On Thu, 15 Jan 2015 17:10:40 +1100
> Michael Ellerman <mpe@ellerman.id.au> wrote:
> > 
> > I like my version better, but your call.
> 
> Of course you do :-)

You've got to admit mine is a lot neater looking :)

> I thought about it a bit, and both versions are really hacks. But in
> the end, I'd rather not touch the swapper task because that might give
> us some unwanted side effects.

Yeah that's true. I don't *think* there would be, but touching swapper is
certainly something one should do with caution.

> I don't really like my approach where I need to disable and re-enable
> all tracepoints. I was thinking of only enabling and disabling just the
> syscall ones, but I could imagine another tracepoint with a reg that
> could be affected by early boot as well, so I left it touching all
> events. My patch is fine for mainline, but I could make a patch for
> 3.20 that will only restart a tracepoint if it has its own reg/unreg
> functions and does not use the default ones.
> 
> Your patch fixes syscall events. I wanted something that will fix any
> event with its own special registration that might also use
> for_each_process_thread() or some other call that does not work before
> init is created.

Yep, that is definitely a benefit. I don't think there are heaps of folks using
tracepoints from boot, so it's possible something else was broken and we
haven't noticed yet.

cheers


