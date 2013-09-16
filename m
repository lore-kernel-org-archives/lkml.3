Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920Ab3IPGCc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 02:02:32 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41835 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587Ab3IPGCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 02:02:30 -0400
Date: Mon, 16 Sep 2013 08:02:10 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@linux.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC] Restrict kernel spawning of threads to a specified set of
 cpus.
Message-ID: <20130916060210.GM21832@twins.programming.kicks-ass.net>
References: <0000014112a921ae-51d171bf-e8d4-4569-bd20-94dabda2d5ba-000000@email.amazonses.com>
 <20130912151102.GB23839@somewhere>
 <alpine.DEB.2.02.1309121030390.21473@gentwo.org>
 <0000014112d66287-d0abaeb1-71ff-48a0-8740-f984d47400a7-000000@email.amazonses.com>
 <20130912183023.GA25386@somewhere>
 <20130913092553.GL31370@twins.programming.kicks-ass.net>
 <00000141179a5b1f-b94a8394-9e98-400c-ae7f-59cdcfce60a6-000000@email.amazonses.com>
 <20130913144008.GF21832@twins.programming.kicks-ass.net>
 <alpine.DEB.2.02.1309131010480.26487@gentwo.org>
 <0000014117fb2ea3-ec97f4c4-344b-42c5-b27c-be876f723942-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000014117fb2ea3-ec97f4c4-344b-42c5-b27c-be876f723942-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 03:40:40PM +0000, Christoph Lameter wrote:
> Hmmm... usermodehelper is based on workqueues. I guess this will
> ultimately come down to modify the workqueue behavior for
> WORK_CPU_UNBOUND?

You don't need to keep it like that -- in fact I would suggest removing
that dependency and creating an extra (explicit) unbound thread spawner
that both usermodehelper and kworker can use for unbound threads.

> If WORK_CPU_UNBOUND could mean to limit process execution to the affinity
> of kthreadd then we are fine.

No, kthreadd must stay clean, if must not have any affinity nor be part
of any cgroup like thing. We must have means of spawning clean kthreads,
therefore we need to create a new parent for these special cases.

