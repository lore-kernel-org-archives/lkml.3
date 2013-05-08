Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758573Ab3EHQM5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 12:12:57 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37983 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758125Ab3EHQMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 12:12:54 -0400
Date: Wed, 8 May 2013 18:11:02 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Shi <alex.shi@intel.com>
Cc: mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org,
        arjan@linux.intel.com, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, len.brown@intel.com,
        rafael.j.wysocki@intel.com, jkosina@suse.cz, clark.williams@gmail.com,
        tony.luck@intel.com, keescook@chromium.org, mgorman@suse.de,
        riel@redhat.com
Subject: Re: [PATCH v4 0/6] sched: use runnable load based balance
Message-ID: <20130508161102.GB8459@dyad.programming.kicks-ass.net>
References: <1367040344-14485-1-git-send-email-alex.shi@intel.com>
 <20130501121421.GA19602@dyad.programming.kicks-ass.net>
 <5181B579.9000808@intel.com>
 <20130502103508.GA13196@dyad.programming.kicks-ass.net>
 <51836D74.2030409@intel.com>
 <5188B272.3010207@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5188B272.3010207@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 07, 2013 at 03:51:14PM +0800, Alex Shi wrote:
> On 05/03/2013 03:55 PM, Alex Shi wrote:
> > 
> >> That should probably look like:
> >>
> >> 	preempt_disable();
> >> 	raw_spin_unlock_irq();
> >> 	preempt_enable_no_resched();
> >> 	schedule();
> >>
> >> Otherwise you might find a performance regression on PREEMPT=y kernels.
> > 
> > Yes, right!
> > Thanks a lot for reminder. The following patch will fix it.
> >>
> 
> Peter, would you like to pick this patch?

There's this huge series from walken that touches the same code.. I'll wait to
see what happens with that.
