Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722Ab3IKSGB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 14:06:01 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52740 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476Ab3IKSF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 14:05:59 -0400
Date: Wed, 11 Sep 2013 20:05:42 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Peter Anvin <hpa@zytor.com>, Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/7] sched: Add NEED_RESCHED to the preempt_count
Message-ID: <20130911180541.GR31370@twins.programming.kicks-ass.net>
References: <20130910130811.507933095@infradead.org>
 <20130910132011.116593485@infradead.org>
 <522FCE9D.4010707@amacapital.net>
 <20130911082530.GN31370@twins.programming.kicks-ass.net>
 <20130911110635.GT26785@twins.programming.kicks-ass.net>
 <CALCETrUECkOZkxao0d1467rEFcSF3jzddNo1awshE4uK-wsWGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUECkOZkxao0d1467rEFcSF3jzddNo1awshE4uK-wsWGQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 09:35:08AM -0700, Andy Lutomirski wrote:
> I bet that this improves cross-cpu wakeup latency, too -- the old code
> would presumably wake up the cpu and then immediately interrupt it.

Yeah,. its what clued Mike in to there being a problem.

> It might be nice to rename one or both of need_resched and
> test_need_resched, though -- the difference is somewhat inscrutable.

I agreed, I've just been unable to come up with anything sane.

The best I could come up with is renaming
{set,clear,test}_need_resched() to {}_tif_need_resched(), so we then end
up with test_tif_need_resched(), which is slightly more different from
need_resched().

Ideas?
