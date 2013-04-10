Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936628Ab3DJLDF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 07:03:05 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:52927
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934127Ab3DJLDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 07:03:03 -0400
Message-ID: <1365591767.30071.45.camel@laptop>
Subject: Re: [PATCH 2/7] sched: Update rq clock on nohz CPU before setting
 fair group shares
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>
Date: Wed, 10 Apr 2013 13:02:47 +0200
In-Reply-To: <20130410100620.GA28402@gmail.com>
References: <1365266760-24725-1-git-send-email-fweisbec@gmail.com>
	 <1365266760-24725-3-git-send-email-fweisbec@gmail.com>
	 <1365499591.30071.3.camel@laptop>
	 <CAFTL4hxcQyv_J4ky8wL0rzVemWPpBcjuCV=FeHBvXn5Bht-3OA@mail.gmail.com>
	 <1365577512.30071.11.camel@laptop> <20130410100620.GA28402@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-10 at 12:06 +0200, Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > I think Mike once tried something along the lines of keeping a per rq state that 
> > got cleared at the end of schedule() but that doesn't catch things like the 
> > migrate handlers I think.
> 
> We'd need a rq->clock.valid debug flag, which is set by a sched-clock update, and 
> cleared by the end of all scheduler operations, not just schedule().
> 
> Then sched_clock() could have a pretty efficient assert in it. Are there bugs that 
> such an approach would not catch?

It requires manual iteration of all scheduler operations which is prone
to 'accidents'.

I'd clear at the beginning, but that's more or less the same thing.

We have the .sched.text section but I'm not sure we've been consistent
enough with that to be useful. But otherwise we'd be able to clear on
section entry/exit or so.

