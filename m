Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758976Ab3K1Pd6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 10:33:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18160 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754555Ab3K1Pd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 10:33:57 -0500
Date: Thu, 28 Nov 2013 16:34:43 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <htejun@gmail.com>, zhang.yi20@zte.com.cn,
        lkml <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH]: exec: avoid propagating PF_NO_SETAFFINITY into
	userspace child
Message-ID: <20131128153443.GB11956@redhat.com>
References: <20131126180420.GA18172@redhat.com> <OF99742718.77495161-ON48257C30.000A8334-48257C30.000BA983@zte.com.cn> <20131127183117.GB13098@mtj.dyndns.org> <20131128091358.GH10022@twins.programming.kicks-ass.net> <20131128114542.GA3826@redhat.com> <20131128121748.GN10022@twins.programming.kicks-ass.net> <20131128133152.GA821@redhat.com> <20131128133947.GR10022@twins.programming.kicks-ass.net> <20131128141329.GB3925@htj.dyndns.org> <20131128143857.GU10022@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131128143857.GU10022@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28, Peter Zijlstra wrote:
>
> On Thu, Nov 28, 2013 at 09:13:29AM -0500, Tejun Heo wrote:
> > > A single parent process for all usermode helpers makes so much sense;
> > > not doing it is just weird.
> >
> > If we're gonna allow userland to play with the parent attributes,
> > yeah, that'd make sense.  I'm not sure whether that's an interface
> > that we'd want to commit to tho?  Do we really want to tell userland
> > "there will always be a kernel task khelper and if you change that
> > one's attributes all processes forked from it will inherit those
> > attributes no matter what they are."  I think we'd want something more
> > specific cause that's a lot of commitment to things that we haven't
> > carefully thought about.
>
> It seems like a perfectly fine interface to me. And much preferable to
> creating yet another weird interface to manage tasks.

OK. I am not sure, but perhaps this makes sense.

(Although this means that we will always have the problem with the
 recursive UMH_WAIT_* requests).

In this case khelper should be turned into kthread_worker, this looks
simple.

But note that in the longer term we might want even more. We probably
want a non-daemonized thread controlled by the user-space. And even
more, this thread should be per-namespace (this needs a lot more
discussion).

But whataver we do later, I believe that the patch from Zhang should
be applied now.

Oleg.

