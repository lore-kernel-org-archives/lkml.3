Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935932Ab3DJLvB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 07:51:01 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:50606 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932987Ab3DJLvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 07:51:00 -0400
Date: Wed, 10 Apr 2013 13:50:56 +0200
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
Message-ID: <20130410115056.GA30852@gmail.com>
References: <1365266760-24725-1-git-send-email-fweisbec@gmail.com>
 <1365266760-24725-3-git-send-email-fweisbec@gmail.com>
 <1365499591.30071.3.camel@laptop>
 <CAFTL4hxcQyv_J4ky8wL0rzVemWPpBcjuCV=FeHBvXn5Bht-3OA@mail.gmail.com>
 <1365577512.30071.11.camel@laptop>
 <20130410100620.GA28402@gmail.com>
 <1365591767.30071.45.camel@laptop>
 <20130410110650.GD28828@gmail.com>
 <1365594427.30071.61.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365594427.30071.61.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, 2013-04-10 at 13:06 +0200, Ingo Molnar wrote:
> 
> > There's just a handful of high level entry points, right? schedule(), wakeup, 
> > scheduler tick, maybe notifiers - anything else? 
> 
> I suppose there's some cgroup muck and the various system calls; most
> of them should be covered if we take some lower level primitives or so.
> 
> We could 'simply' hijack rq->lock and clear the state every time we
> acquire or release it.. maybe have an exemption for the balance double
> lock ops.

That would be feasible ...

Thanks,

	Ingo
