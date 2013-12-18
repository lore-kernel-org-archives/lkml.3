Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab3LRP6P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 10:58:15 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:64772 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754204Ab3LRP6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 10:58:14 -0500
Date: Wed, 18 Dec 2013 16:58:10 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Stultz <john.stultz@linaro.org>, Alex Shi <alex.shi@linaro.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH 05/13] rcu: Fix unraised IPI to timekeeping CPU
Message-ID: <20131218155808.GG18464@localhost.localdomain>
References: <1387320692-28460-1-git-send-email-fweisbec@gmail.com>
 <1387320692-28460-6-git-send-email-fweisbec@gmail.com>
 <20131217232100.GC19211@linux.vnet.ibm.com>
 <20131218141348.GA18464@localhost.localdomain>
 <20131218142240.GP19211@linux.vnet.ibm.com>
 <20131218145610.GE18464@localhost.localdomain>
 <20131218151158.GV21999@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131218151158.GV21999@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 04:11:58PM +0100, Peter Zijlstra wrote:
> On Wed, Dec 18, 2013 at 03:56:12PM +0100, Frederic Weisbecker wrote:
> > Because scheduler_ipi() conditionally calls irq_enter() and irq_exit()
> > (I wonder if that's a good idea btw, is that here to deal with spurious
> > scheduler IPIs of some sort?)
> 
> No its because the traditional scheduler IPI did all the work from the
> interrupt return path -- and like the comment in there says, for many of
> the IPIs that's still true.
> 
> So going through the architectures and making all scheduler_ipi callers
> do irq_enter/exit would actually make them slower.

Fair point!

Thanks.
