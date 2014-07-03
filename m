Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbaGCDvI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 23:51:08 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:44302 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbaGCDvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 23:51:07 -0400
Message-ID: <1404359462.5137.72.camel@marge.simpson.net>
Subject: Re: [PATCH] sched: select 'idle' cfs_rq per task-group to prevent
 tg-internal imbalance
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: Michael wang <wangyun@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Alex Shi <alex.shi@linaro.org>, Paul Turner <pjt@google.com>,
        Mel Gorman <mgorman@suse.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Thu, 03 Jul 2014 05:51:02 +0200
In-Reply-To: <53B41B7E.8020009@redhat.com>
References: <53A11A89.5000602@linux.vnet.ibm.com>
	 <20140623094251.GS19860@laptop.programming.kicks-ass.net>
	 <53A8F1DE.2060908@linux.vnet.ibm.com>
	 <20140701082020.GL6758@twins.programming.kicks-ass.net>
	 <53B273A2.5050500@linux.vnet.ibm.com> <53B41B7E.8020009@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-02 at 10:47 -0400, Rik van Riel wrote: 
> On 07/01/2014 04:38 AM, Michael wang wrote:
> > On 07/01/2014 04:20 PM, Peter Zijlstra wrote:
> > [snip]
> >>>
> >>> Just wondering could we make this another scheduler feature?
> >>
> >> No; sched_feat() is for debugging, BIG CLUE: its guarded by
> >> CONFIG_SCHED_DEBUG, anybody using it in production or anywhere else is
> >> broken.
> >>
> >> If people are using it, I should remove or at least randomize the
> >> interface.
> > 
> > Fair enough... but is there any suggestions on how to handle this issue?
> > 
> > Currently when dbench running with stress, it could only gain one CPU,
> > and cpu-cgroup cpu.shares is meaningless, is there any good methods to
> > address that?
> 
> select_idle_sibling will iterate over all of the CPUs
> in an LLC domain if there is no idle cpu in the domain.
> 
> I suspect it would not take much extra code to track
> down the idlest CPU in the LLC domain, and make sure to
> schedule tasks there, in case no completely idle CPU
> was found.
> 
> Are there any major problems with that thinking?

That's full wake balance.. if that was cheap, select_idle_sibling()
would not exist.

-Mike

