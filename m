Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759195Ab3K1Oxa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 09:53:30 -0500
Received: from mail-qe0-f45.google.com ([209.85.128.45]:59546 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335Ab3K1Ox3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 09:53:29 -0500
Date: Thu, 28 Nov 2013 09:53:25 -0500
From: Tejun Heo <htejun@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>, zhang.yi20@zte.com.cn,
        lkml <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH]: exec: avoid propagating PF_NO_SETAFFINITY into
 userspace child
Message-ID: <20131128145325.GG3925@htj.dyndns.org>
References: <OF99742718.77495161-ON48257C30.000A8334-48257C30.000BA983@zte.com.cn>
 <20131127183117.GB13098@mtj.dyndns.org>
 <20131128091358.GH10022@twins.programming.kicks-ass.net>
 <20131128114542.GA3826@redhat.com>
 <20131128121748.GN10022@twins.programming.kicks-ass.net>
 <20131128133152.GA821@redhat.com>
 <20131128133947.GR10022@twins.programming.kicks-ass.net>
 <20131128141329.GB3925@htj.dyndns.org>
 <20131128143145.GT10022@twins.programming.kicks-ass.net>
 <20131128144359.GL3694@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131128144359.GL3694@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 28, 2013 at 03:43:59PM +0100, Peter Zijlstra wrote:
> On Thu, Nov 28, 2013 at 03:31:45PM +0100, Peter Zijlstra wrote:
> > Sure, we absolutely must set it for per-cpu workqueues (and their
> > workers) otherwise we cannot guarantee correctness. Same for per-node if
> > we have that.
> 
> On that, the per-node thing is debatable. There's no correctness issues
> with per-node stuff as we have with per-cpu storage.
> 
> And if there's no correctness implications we should not force things.

That's true iff you confine the "correctness" to not crashing.  That's
an extremely narrow definition tho and most will argue against that.

-- 
tejun
