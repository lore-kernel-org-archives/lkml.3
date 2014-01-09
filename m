Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703AbaAIWMl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 17:12:41 -0500
Received: from merlin.infradead.org ([205.233.59.134]:45369 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbaAIWMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 17:12:32 -0500
Date: Thu, 9 Jan 2014 23:12:21 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC][PATCH] lockdep: Introduce wait-type checks
Message-ID: <20140109221221.GG7572@laptop.programming.kicks-ass.net>
References: <20140109111516.GE7572@laptop.programming.kicks-ass.net>
 <20140109173326.GA10105@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140109173326.GA10105@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 12:33:26PM -0500, Dave Jones wrote:
> On Thu, Jan 09, 2014 at 12:15:16PM +0100, Peter Zijlstra wrote:
>  > Subject: lockdep: Introduce wait-type checks
>  > From: Peter Zijlstra <peterz@infradead.org>
>  > Date: Tue, 19 Nov 2013 21:45:48 +0100
>  > 
>  > This patch extends lockdep to validate lock wait-type context.
> 
> ooh, a new toy.
> 
> *boom*
> 

Oh cute, I'll have to stare at slub. ISTR there's a current slub-rt
patch floating about.

I'd have to just blindly convert slub to raw_spinlocks (although that'll
get rid of the warning) without trying to limit the lock hold time of
raw_spinlocks.

> nitpick: Why is the backtrace printed twice ?

Because I'm an idiot, lemme fix that ;-)
