Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758759Ab3K1Oix (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 09:38:53 -0500
Received: from mail-qe0-f48.google.com ([209.85.128.48]:53157 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712Ab3K1Oiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 09:38:52 -0500
Date: Thu, 28 Nov 2013 09:38:48 -0500
From: Tejun Heo <htejun@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>, zhang.yi20@zte.com.cn,
        lkml <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH]: exec: avoid propagating PF_NO_SETAFFINITY into
 userspace child
Message-ID: <20131128143848.GD3925@htj.dyndns.org>
References: <20131126180420.GA18172@redhat.com>
 <OF99742718.77495161-ON48257C30.000A8334-48257C30.000BA983@zte.com.cn>
 <20131127183117.GB13098@mtj.dyndns.org>
 <20131128091358.GH10022@twins.programming.kicks-ass.net>
 <20131128114542.GA3826@redhat.com>
 <20131128121748.GN10022@twins.programming.kicks-ass.net>
 <20131128133152.GA821@redhat.com>
 <20131128133947.GR10022@twins.programming.kicks-ass.net>
 <20131128141329.GB3925@htj.dyndns.org>
 <20131128143145.GT10022@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131128143145.GT10022@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Peter.

On Thu, Nov 28, 2013 at 03:31:45PM +0100, Peter Zijlstra wrote:
> But the WQ_UNBOUND thingies should be just that and should thus not have
> the NO_SETAFFINITY flag set because there is no valid reason to have it
> set.
> 
> Regardless of whether the threads are shared between unbound workqueues
> or not.

Hah?  No, we do not want to allow userland to be able to set
affinities on any workqueue workers, period.  That's just inviting
people to do weirdest things and then reporting things like "crypt
jobs on some of our 500 machines end up stuck on a single cpu once in
a while" which will eventually be tracked down to some weird shell
script setting affinity on workers doing something else.

We really want to insulate workers and pool operation from userland.
e.g. unbound workqueues now default to per-NUMA affinity unless
explicitly told not to, which leads to better overall behavior for
most workloads.  We do wanna keep those details from userland so that
they can be improved in the future too.

Thanks.

-- 
tejun
