Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867Ab3JHPls (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 11:41:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43641 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797Ab3JHPlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 11:41:47 -0400
Date: Tue, 8 Oct 2013 17:33:25 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] rcusync: introduce struct rcu_sync_ops
Message-ID: <20131008153325.GB16558@redhat.com>
References: <20131004184614.GA17536@redhat.com> <20131004184629.GA17550@redhat.com> <CA+55aFxfbV2AsOUhL318AH8y4BUe2FXFb8aTFuqPqc_2SdV2MA@mail.gmail.com> <20131004153012.19245adb@gandalf.local.home> <CA+55aFwda1pErt32162S_1gq=Kkge7Gj3n2sm_rOopAtz2bVUQ@mail.gmail.com> <20131005171746.GA17664@redhat.com> <20131008091339.GN3081@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131008091339.GN3081@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08, Peter Zijlstra wrote:
>
> I think Linus meant to have rcu_sync_{enter,exit} as inlines with a
> const enum argument for the gp_type.
>
> That said; yes that will generate better code, but also more code, and
> like Steven already argued performance isn't really an issue here since
> we're going to potentially sleep for a rather long time.

Yes, I do not think that we should make them "inline". Plus we need the
non-inline rcu_sync_func() anyway.

Thanks again for the last series you sent.

Oleg.

