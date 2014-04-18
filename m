Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826AbaDRIo1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 04:44:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59077 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbaDRIoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 04:44:22 -0400
Date: Fri, 18 Apr 2014 10:44:01 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Denys Vlasenko <vda.linux@googlemail.com>, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] nohz: use delayed iowait accounting to avoid race on
 idle time stats
Message-ID: <20140418084401.GC11096@twins.programming.kicks-ass.net>
References: <53465F54.708@jp.fujitsu.com>
 <534660D2.1080505@jp.fujitsu.com>
 <20140415101910.GN11096@twins.programming.kicks-ass.net>
 <534E2422.1040706@jp.fujitsu.com>
 <20140417100519.GF11096@twins.programming.kicks-ass.net>
 <5350BD85.4050302@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5350BD85.4050302@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 02:52:05PM +0900, Hidetoshi Seto wrote:
> I think it also works... but I have some concerns here:
> 
>  - it changes golden path in scheduler core.
>     impact for performance is questionable.

We should be able to measure that, but like said, it shouldn't change
the number of atomic ops and makes sure its all in the same cacheline,
so the additional code is all cheap.

>  - it forces managing last_iowait even if system is in busy
>     I guess it will drop max performance of the system
>     while my proposed fix only touches procedure for idle
>     with nohz. 

That could be fixed by looking to see if the remote rq is idle.

> By the way, I have posted my v4 patch set:
> https://lkml.org/lkml/2014/4/17/120
> 
> I'll happy if you could give your comments on it too!

Yeah, I saw that, didn't have time yet, will hopefully get to it soon
:-)
