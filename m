Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935619Ab3DJKGa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 06:06:30 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:45159 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765344Ab3DJKG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 06:06:26 -0400
Date: Wed, 10 Apr 2013 12:06:20 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
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
Subject: Re: [PATCH 2/7] sched: Update rq clock on nohz CPU before setting
 fair group shares
Message-ID: <20130410100620.GA28402@gmail.com>
References: <1365266760-24725-1-git-send-email-fweisbec@gmail.com>
 <1365266760-24725-3-git-send-email-fweisbec@gmail.com>
 <1365499591.30071.3.camel@laptop>
 <CAFTL4hxcQyv_J4ky8wL0rzVemWPpBcjuCV=FeHBvXn5Bht-3OA@mail.gmail.com>
 <1365577512.30071.11.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365577512.30071.11.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> I think Mike once tried something along the lines of keeping a per rq state that 
> got cleared at the end of schedule() but that doesn't catch things like the 
> migrate handlers I think.

We'd need a rq->clock.valid debug flag, which is set by a sched-clock update, and 
cleared by the end of all scheduler operations, not just schedule().

Then sched_clock() could have a pretty efficient assert in it. Are there bugs that 
such an approach would not catch?

Thaks,

	Ingo
