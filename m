Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342Ab3LRPMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 10:12:23 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49227 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754959Ab3LRPMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 10:12:22 -0500
Date: Wed, 18 Dec 2013 16:11:58 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Stultz <john.stultz@linaro.org>, Alex Shi <alex.shi@linaro.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH 05/13] rcu: Fix unraised IPI to timekeeping CPU
Message-ID: <20131218151158.GV21999@twins.programming.kicks-ass.net>
References: <1387320692-28460-1-git-send-email-fweisbec@gmail.com>
 <1387320692-28460-6-git-send-email-fweisbec@gmail.com>
 <20131217232100.GC19211@linux.vnet.ibm.com>
 <20131218141348.GA18464@localhost.localdomain>
 <20131218142240.GP19211@linux.vnet.ibm.com>
 <20131218145610.GE18464@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131218145610.GE18464@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 03:56:12PM +0100, Frederic Weisbecker wrote:
> Because scheduler_ipi() conditionally calls irq_enter() and irq_exit()
> (I wonder if that's a good idea btw, is that here to deal with spurious
> scheduler IPIs of some sort?)

No its because the traditional scheduler IPI did all the work from the
interrupt return path -- and like the comment in there says, for many of
the IPIs that's still true.

So going through the architectures and making all scheduler_ipi callers
do irq_enter/exit would actually make them slower.
