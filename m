Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965622AbaCSPrU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 11:47:20 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37432 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965160AbaCSPrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 11:47:19 -0400
Date: Wed, 19 Mar 2014 16:47:05 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: davidlohr@hp.com, torvalds@linux-foundation.org, tglx@linutronix.de,
        mingo@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org, benh@kernel.crashing.org,
        paulus@samba.org
Subject: Re: Tasks stuck in futex code (in 3.14-rc6)
Message-ID: <20140319154705.GB8557@laptop.programming.kicks-ass.net>
References: <20140319152619.GB10406@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140319152619.GB10406@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 08:56:19PM +0530, Srikar Dronamraju wrote:
> There are 332 tasks all stuck in futex_wait_queue_me().
> I am able to reproduce this consistently.
> 
> Infact I can reproduce this if the java_constraint is either node, socket, system.
> However I am not able to reproduce if java_constraint is set to core.

What's any of that mean?

> I ran git bisect between v3.12 and v3.14-rc6 and found that
> 
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=b0c29f79ecea0b6fbcefc999e70f2843ae8306db
> 
> commit b0c29f79ecea0b6fbcefc999e70f2843ae8306db
> Author: Davidlohr Bueso <davidlohr@hp.com>
> Date:   Sun Jan 12 15:31:25 2014 -0800
> 
> futexes: Avoid taking the hb->lock if there's nothing to wake up
> 
> was the commit thats causing the threads to be stuck in futex.
> 
> I reverted b0c29f79ecea0b6fbcefc999e70f2843ae8306db on top of v3.14-rc6 and confirmed that
> reverting the commit solved the problem.

Joy,.. let me look at that with ppc in mind.
