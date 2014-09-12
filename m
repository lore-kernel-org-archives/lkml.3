Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665AbaILTBg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 15:01:36 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:60465 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbaILTBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 15:01:35 -0400
Date: Fri, 12 Sep 2014 21:00:57 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Iacob <iacobcatalin@gmail.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Will Deacon <will.deacon@arm.com>, Ingo Molnar <mingo@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 0/8] nohz: Fix nohz kick irq work on tick v2
Message-ID: <20140912190057.GQ16043@twins.programming.kicks-ass.net>
References: <1410384808-14760-1-git-send-email-fweisbec@gmail.com>
 <20140911082812.GU6758@twins.programming.kicks-ass.net>
 <20140912180547.GB5824@lerouge>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140912180547.GB5824@lerouge>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 08:05:49PM +0200, Frederic Weisbecker wrote:
> > Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> 
> Intel? :-) Wow.

Yeah, moved about a month ago :-)

> Note, I fear I'll have to turn the static_cpu_has into cpu_has. The
> alternatives code which initialize all static_cpu_has() things
> is called from check_bugs() in start_kernel() which is way after
> IRQs are enabled for the 1st time. irq_work_tick() has many opportunities
> to run in between.

Ah well. It was worth a try I suppose.
