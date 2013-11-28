Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758893Ab3K1PST (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 10:18:19 -0500
Received: from mail-yh0-f49.google.com ([209.85.213.49]:62905 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757871Ab3K1PSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 10:18:17 -0500
Date: Thu, 28 Nov 2013 10:10:35 -0500
From: Tejun Heo <htejun@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>, zhang.yi20@zte.com.cn,
        lkml <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH]: exec: avoid propagating PF_NO_SETAFFINITY into
 userspace child
Message-ID: <20131128151035.GK3925@htj.dyndns.org>
References: <20131128121748.GN10022@twins.programming.kicks-ass.net>
 <20131128133152.GA821@redhat.com>
 <20131128133947.GR10022@twins.programming.kicks-ass.net>
 <20131128141329.GB3925@htj.dyndns.org>
 <20131128143145.GT10022@twins.programming.kicks-ass.net>
 <20131128144359.GL3694@twins.programming.kicks-ass.net>
 <20131128145325.GG3925@htj.dyndns.org>
 <20131128145755.GY10022@twins.programming.kicks-ass.net>
 <20131128150210.GI3925@htj.dyndns.org>
 <20131128150704.GB10022@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131128150704.GB10022@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 28, 2013 at 04:07:04PM +0100, Peter Zijlstra wrote:
> On Thu, Nov 28, 2013 at 10:02:10AM -0500, Tejun Heo wrote:
> > > So far I just see you breaking existing setups because you don't want to
> > > support things that work perfectly well.
> > 
> > It doesn't work as explained multiple times in this thread.
> 
> It used to.. just not on recent kernels. You know 'enterprise' latency.

If you're talking about khelfper and wanna restore it, it really
should be broken out into a separate kthread.  It doesn't make any
sense to implement that in the workqueue framework.  Why would you
implement a dedicated task inside a worker pool implementation which
makes use of the said tasks?  There's even kthread_work interface
which pretty much provides workqueue-equivalent interface on top of a
single task for cases like this.

-- 
tejun
