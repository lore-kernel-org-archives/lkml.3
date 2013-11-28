Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778Ab3K1QiM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 11:38:12 -0500
Received: from merlin.infradead.org ([205.233.59.134]:53526 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754818Ab3K1QiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 11:38:11 -0500
Date: Thu, 28 Nov 2013 17:38:03 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <htejun@gmail.com>, zhang.yi20@zte.com.cn,
        lkml <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH]: exec: avoid propagating PF_NO_SETAFFINITY into
 userspace child
Message-ID: <20131128163803.GG10022@twins.programming.kicks-ass.net>
References: <20131128091358.GH10022@twins.programming.kicks-ass.net>
 <20131128114542.GA3826@redhat.com>
 <20131128121748.GN10022@twins.programming.kicks-ass.net>
 <20131128133152.GA821@redhat.com>
 <20131128133947.GR10022@twins.programming.kicks-ass.net>
 <20131128141329.GB3925@htj.dyndns.org>
 <20131128143857.GU10022@twins.programming.kicks-ass.net>
 <20131128153443.GB11956@redhat.com>
 <20131128154035.GE10022@twins.programming.kicks-ass.net>
 <20131128162025.GA14937@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131128162025.GA14937@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 28, 2013 at 05:20:25PM +0100, Oleg Nesterov wrote:
> On 11/28, Peter Zijlstra wrote:
> >
> > On Thu, Nov 28, 2013 at 04:34:43PM +0100, Oleg Nesterov wrote:
> > > But note that in the longer term we might want even more. We probably
> > > want a non-daemonized thread controlled by the user-space. And even
> > > more, this thread should be per-namespace (this needs a lot more
> > > discussion).
> >
> > Which namespace? PID namespace I presume where we can have a 'new' init
> > task and everything.
> >
> > I'm not sure, are any of these things (workqueues, userspace helpers)
> > pid namespace aware? If not it doesn't seem to make sense to expose this
> > to nested PID namespaces and would be something special for the root
> > namespace.
> 
> Not sure I understand correctly. But yes, of course, it is not that
> call_usermodehelper() should be namespace-friendly "unconditionally".
> 
> We need another API (although perhaps we can simply add UMH_NAMESPACE
> flag, this doesn't matter).
> 
> Just for example, the piped core handler. Currently it is hardly useful
> in containers.

I'm afraid I'm not much familiar with the entire namespace thing other
than broad concepts.

But if there's specific per-pid-namespace functionality for
usermode-helpers, then yes it makes sense to have per-pid-namespace
parents.

So in specific, you say that piping a core file into a usermode helper
is currently busted in pid-namespaces and that fixing that would indeed
introduce such pid-namespace awareness to the usermode-helper stuff?
