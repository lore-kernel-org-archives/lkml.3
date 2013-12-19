Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648Ab3LSPt4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:49:56 -0500
Received: from mail-ea0-f170.google.com ([209.85.215.170]:34205 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab3LSPty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:49:54 -0500
Date: Thu, 19 Dec 2013 16:49:51 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Sasha Levin <sasha.levin@oracle.com>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: lockdep: BUG: MAX_LOCKDEP_ENTRIES too low!
Message-ID: <20131219154951.GB24658@gmail.com>
References: <52B289F4.7060205@oracle.com>
 <20131219103401.GE30183@twins.programming.kicks-ass.net>
 <52B2FC66.9010309@oracle.com>
 <20131219152002.GK16438@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131219152002.GK16438@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, Dec 19, 2013 at 09:02:14AM -0500, Sasha Levin wrote:
> > On 12/19/2013 05:34 AM, Peter Zijlstra wrote:
> > >On Thu, Dec 19, 2013 at 12:53:56AM -0500, Sasha Levin wrote:
> > >>Hi all,
> > >>
> > >>I think that my bloated kernel managed to create way too many entries in the
> > >>dependency table. If that sounds right, I can send a patch to increase those.
> > >>
> > >>Attached /proc/lock_stat as requested as well.
> > >
> > >/proc/lockdep_stats not lock_stat :-)
> > >
> > >Do you still happen to have that?
> > 
> > Is the BUG message intentional ("Please attach the output of /proc/lock_stat to the bug report")?
> 
> It does? This happened when I wasn't looking..
> 
> Commit 199e371f59d31 did that; and the Changelog fails to mention why or
> what. Ingo, Dave?

Simple oversight I think, should be fixed.

> [...]
>
> One might argue that the validator should be modified to allow lock 
> classes to be reused.  However, if you are tempted to make this 
> argument, first review the code and think through the changes that 
> would be required, keeping in mind that the lock classes to be 
> removed are likely to be linked into the lock-dependency graph.  
> This turns out to be harder to do than to say.

Yes, an append-only data structure was a conscious simplification I 
decided on very early. (It also increases general robustness if your 
data structure can never go away.)

Thanks,

	Ingo
