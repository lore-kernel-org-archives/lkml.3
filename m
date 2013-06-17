Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933001Ab3FQNH5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 09:07:57 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43239 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932791Ab3FQNH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 09:07:56 -0400
Date: Mon, 17 Jun 2013 15:07:38 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Shi <alex.shi@intel.com>
Cc: Paul Turner <pjt@google.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Michael Wang <wangyun@linux.vnet.ibm.com>,
        Jason Low <jason.low2@hp.com>,
        Changlong Xie <changlongx.xie@intel.com>, sgruszka@redhat.com,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: [patch v8 3/9] sched: set initial value of runnable avg for new
 forked task
Message-ID: <20130617130738.GW3204@twins.programming.kicks-ass.net>
References: <1370589652-24549-1-git-send-email-alex.shi@intel.com>
 <1370589652-24549-4-git-send-email-alex.shi@intel.com>
 <CAPM31RJFsh_gBXBHc4E6z=MtORR9D8sWs=86Yqy9onxK9x9fOg@mail.gmail.com>
 <51BB25BC.9070500@intel.com>
 <20130617092146.GM3204@twins.programming.kicks-ass.net>
 <51BEDD9E.600@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51BEDD9E.600@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 05:57:50PM +0800, Alex Shi wrote:
> On 06/17/2013 05:21 PM, Peter Zijlstra wrote:
> >> > 
> >> > and make forking balancing imbalance since incorrect load_avg_contrib.
> >> > 
> >> > Further more, Morten Rasmussen notice some tasks were not launched at
> >> > once after created. So Paul and Peter suggest giving a start value for
> >> > new task runnable avg time same as sched_slice().
> >> > 
> >> > Signed-off-by: Alex Shi <alex.shi@intel.com>
> >> > Signed-off-by: Paul Turner <pjt@google.com>
> > Should you all go read: Documentation/SubmittingPatches , or am I
> > somehow confused on the SoB rules?
> 
> has this should been right, if Paul had handed in the modified patch as
> he suggested? :)
> 
> Sorry for stupid, I still don't know what's SoB rule?

Right, so it depends on who actually wrote the patch; the only case
that's really hard is when a patch is fully co-authored -- agile dev
nonsense like, 4 hands 1 keyboard situation or so.

Typically there's 1 somebody who did most work on a particular patch;
that someone would be Author/From and have first SoB.

If thereafter the patch becomes part of an aggregate work; he who
compiles can add another SoB; possibly with an extra [] line describing
'smallish' changes that were needed to the initial patch to make it fit
the aggregate.

Example:

From: PJT

foo patch implements foo because bar; note the fubar detail.

SoB: PJT
[alex@intel: changed ponies into horses to make it fit]
SoB: Alex

The other case is where a 'simple' modification of the initial patch
simply won't do; you need to change the core idea of the patch or
similar. In this case I've seen things like:

From: Alex

foo patch implements foo because bar; note the fubar detail.

Based-on-patch-by: PJT
SoB: Alex


This isn't actually in the submitting patches document and I'm not sure
it should be; although some clarification for these weird cases might be
useful.


