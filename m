Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117AbaDZLRN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 07:17:13 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:3585 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751569AbaDZLRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 07:17:11 -0400
Date: Sat, 26 Apr 2014 07:17:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC PATCH] rtmutex: Do not prio boost when timeout is used
Message-ID: <20140426071702.2a866fc5@gandalf.local.home>
In-Reply-To: <20140426110437.GK26782@laptop.programming.kicks-ass.net>
References: <20140425162848.0e1deed8@gandalf.local.home>
	<20140426110437.GK26782@laptop.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Apr 2014 13:04:37 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, Apr 25, 2014 at 04:28:48PM -0400, Steven Rostedt wrote:
> > I've been discussing an issue on IRC with deadlock checking and found
> > something wrong with it. Mainly, if any of the locks have a timeout,
> > then even if the chain loops, there is no real deadlock. If one of the
> > locks in the chain times out, then things will move forward again.
> 
> 
> POSIX (opengroup):
> 
>  http://pubs.opengroup.org/onlinepubs/009695399/functions/pthread_mutex_timedlock.html
> 
> Explicitly states that pthread_mutex_timedlock() should participate in
> the PI chain, it also states that its perfectly valid for this function
> to return -EDEADLK.
> 
> Therefore, there's nothing wrong. If this behaviour breaks userspace,
> its already broken for not actually expecting the right thing.

Fair enough. Thanks for the link.

-- Steve
