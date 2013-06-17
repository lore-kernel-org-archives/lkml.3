Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286Ab3FQOBV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 10:01:21 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44805 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756193Ab3FQOBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 10:01:18 -0400
Date: Mon, 17 Jun 2013 16:01:00 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Turner <pjt@google.com>
Cc: Alex Shi <alex.shi@intel.com>, Ingo Molnar <mingo@redhat.com>,
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
Subject: Re: [patch v8 9/9] sched/tg: remove blocked_load_avg in balance
Message-ID: <20130617140100.GZ3204@twins.programming.kicks-ass.net>
References: <1370589652-24549-1-git-send-email-alex.shi@intel.com>
 <1370589652-24549-10-git-send-email-alex.shi@intel.com>
 <CAPM31RJ_0xgymfN+5FzQCSrv-qgpT+42EOmWke1rOGy7GfHcYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPM31RJ_0xgymfN+5FzQCSrv-qgpT+42EOmWke1rOGy7GfHcYg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 05:20:46AM -0700, Paul Turner wrote:
> On Fri, Jun 7, 2013 at 12:20 AM, Alex Shi <alex.shi@intel.com> wrote:
> > blocked_load_avg sometime is too heavy and far bigger than runnable load
> > avg, that make balance make wrong decision. So remove it.
> 
> Ok so this is  going to have terrible effects on the correctness of
> shares distribution; I'm fairly opposed to it in its present form.

Should someone take a look at the LTP cgroup tests to make sure they
cover this properly?
