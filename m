Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759150Ab3K1OvU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 09:51:20 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:63433 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631Ab3K1OvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 09:51:18 -0500
Date: Thu, 28 Nov 2013 09:51:15 -0500
From: Tejun Heo <htejun@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>, zhang.yi20@zte.com.cn,
        lkml <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH]: exec: avoid propagating PF_NO_SETAFFINITY into
 userspace child
Message-ID: <20131128145115.GF3925@htj.dyndns.org>
References: <20131127183117.GB13098@mtj.dyndns.org>
 <20131128091358.GH10022@twins.programming.kicks-ass.net>
 <20131128114542.GA3826@redhat.com>
 <20131128121748.GN10022@twins.programming.kicks-ass.net>
 <20131128133152.GA821@redhat.com>
 <20131128133947.GR10022@twins.programming.kicks-ass.net>
 <20131128141329.GB3925@htj.dyndns.org>
 <20131128143145.GT10022@twins.programming.kicks-ass.net>
 <20131128143848.GD3925@htj.dyndns.org>
 <20131128144714.GV10022@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131128144714.GV10022@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 28, 2013 at 03:47:14PM +0100, Peter Zijlstra wrote:
> Bah, windows mentality of we know better.
> 
> If they do stupid they get stupid; the only thing we should be concerned
> about is correctness, they shouldn't be able to crash the system.

It isn't about that we know better but more that we do not want to
leak implementation details to userland.  "Whatever isn't crashing is
okay" doesn't work because we aren't supposed to change behaviors
which are depended upon from userland.  Unless what's exposed is
actively managed, we end up being locked into specific unintended
characteristics of the current implementation.  It hurts both the
kernel and userland.  We end up having to hack around silly
constraints in the future and userland gets surprised when such hacks
inevitably falls apart in corner cases.

So, no, it's not about which part knows better or windows mentaility.
It's about having proper separation between implementation details and
exposed interface.

Thanks.

-- 
tejun
