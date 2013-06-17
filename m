Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282Ab3FQJWN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 05:22:13 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38153 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab3FQJWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 05:22:12 -0400
Date: Mon, 17 Jun 2013 11:21:46 +0200
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
Message-ID: <20130617092146.GM3204@twins.programming.kicks-ass.net>
References: <1370589652-24549-1-git-send-email-alex.shi@intel.com>
 <1370589652-24549-4-git-send-email-alex.shi@intel.com>
 <CAPM31RJFsh_gBXBHc4E6z=MtORR9D8sWs=86Yqy9onxK9x9fOg@mail.gmail.com>
 <51BB25BC.9070500@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51BB25BC.9070500@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 10:16:28PM +0800, Alex Shi wrote:
> On 06/14/2013 07:09 PM, Paul Turner wrote:
> > Minor comments; looks good otherwise.
> > 
> > Signed-off-by: Paul Turner <pjt@google.com>
> 
> thanks a lot Paul. the patch with your input updated here:
> 
> BTW, would you like to give some comments on the last patch of this patchset?
> 
> ---
> From ed35080d0bae803d68f84a3e683d34a356a5a5de Mon Sep 17 00:00:00 2001
> From: Alex Shi <alex.shi@intel.com>
> Date: Tue, 14 May 2013 09:41:09 +0800
> Subject: [PATCH 3/8] sched: set initial value of runnable avg for new forked
>  task
> 
> We need initialize the se.avg.{decay_count, load_avg_contrib} for a
> new forked task.
> Otherwise random values of above variables cause mess when do new task
> enqueue:
>     enqueue_task_fair
>         enqueue_entity
>             enqueue_entity_load_avg
> 
> and make forking balancing imbalance since incorrect load_avg_contrib.
> 
> Further more, Morten Rasmussen notice some tasks were not launched at
> once after created. So Paul and Peter suggest giving a start value for
> new task runnable avg time same as sched_slice().
> 
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> Signed-off-by: Paul Turner <pjt@google.com>

Should you all go read: Documentation/SubmittingPatches , or am I
somehow confused on the SoB rules?
