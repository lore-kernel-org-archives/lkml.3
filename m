Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbaE1U21 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 16:28:27 -0400
Received: from www.linutronix.de ([62.245.132.108]:40188 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbaE1U20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 16:28:26 -0400
Date: Wed, 28 May 2014 22:28:23 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [patch 4/6] rtmutex: Confine deadlock logic to futex
In-Reply-To: <20140522071039.GO30445@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1405282227130.3952@nanos>
References: <20140522031841.797415507@linutronix.de> <20140522031950.044848781@linutronix.de> <20140522071039.GO30445@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2014, Peter Zijlstra wrote:
> On Thu, May 22, 2014 at 03:25:50AM -0000, Thomas Gleixner wrote:
> > The builtin tester is gone,, so the deadlock logic is now only
> > required for futexes.
> > 
> > Remove the extra arguments for the public functions and also for the
> > futex specific ones which get always called with deadlock detection
> > enabled.
> 
> This reminds me, the raw rt_mutex primitives have no lockdep support,
> and we've grown a few users in-tree. We should fix that.

It shouldn't be that hard. We just need to exclude the futex mess ...

Thanks,

	tglx

