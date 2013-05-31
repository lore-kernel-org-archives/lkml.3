Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757051Ab3EaQX3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 12:23:29 -0400
Received: from one.firstfloor.org ([193.170.194.197]:43134 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756784Ab3EaQXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 12:23:14 -0400
Date: Fri, 31 May 2013 18:23:12 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/5] perf, x86: Add Haswell PEBS record support v5
Message-ID: <20130531162312.GO6123@two.firstfloor.org>
References: <1363895995-12967-1-git-send-email-andi@firstfloor.org>
 <1363895995-12967-2-git-send-email-andi@firstfloor.org>
 <CABPqkBSuiWCLyXkNhuq6wXFP2G+4rOQv_H4134R55CqcVFAAUA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBSuiWCLyXkNhuq6wXFP2G+4rOQv_H4134R55CqcVFAAUA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 03:02:29PM +0200, Stephane Eranian wrote:
> Hi,
> 
> So looked at this patch again. There is nothing wrong with the code.
> But there is something bothering me with the usage model. I think
> the choice of having pebs->ip for precise=1 or pebs->real_ip for
> precise=2 is too restrictive.
> 
> There are situations where you want BOTH the real_ip AND the
> off-by-one ip. This is when you're sampling call branches.
> The real_ip gives you the call site, the off-by-one gives you
> the target of the branch. This is very handy because you do
> not need to use the LBR to get this, unlike with SandyBridge.

It's also useful for TSX: critical section versus abort point
inside transaction.

> So we need to find an extension or a way to return both IPs
> without invoking LBR. Easiest would be to add another
> PERF_SAMPLE_*.
> 
> Any better idea?

For TSX I just use two different events. It works.

I'm not disagreeing with it, but I think it's an orthogonal issue to my
patchkit.   Adding a new SAMPLE type seems reasonable to me.

-Andi
