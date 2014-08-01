Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751251AbaHAED0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 00:03:26 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:3239 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbaHAEDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 00:03:25 -0400
Message-ID: <1406865802.4243.3.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [LKP] [sched/numa] a43455a1d57: +94.1%
 proc-vmstat.numa_hint_faults_local
From: Davidlohr Bueso <davidlohr@hp.com>
To: Aaron Lu <aaron.lu@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org, jhladky@redhat.com,
        Fengguang Wu <fengguang.wu@intel.com>
Date: Thu, 31 Jul 2014 21:03:22 -0700
In-Reply-To: <20140801020330.GA30211@aaronlu.sh.intel.com>
References: <53d70ee6.JsUEmW5dWsv8dev+%fengguang.wu@intel.com>
	 <53D72FF5.90908@intel.com> <20140729023940.37b6aebc@annuminas.surriel.com>
	 <20140731104241.GA9918@twins.programming.kicks-ass.net>
	 <20140801020330.GA30211@aaronlu.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-08-01 at 10:03 +0800, Aaron Lu wrote:
> On Thu, Jul 31, 2014 at 12:42:41PM +0200, Peter Zijlstra wrote:
> > On Tue, Jul 29, 2014 at 02:39:40AM -0400, Rik van Riel wrote:
> > > On Tue, 29 Jul 2014 13:24:05 +0800
> > > Aaron Lu <aaron.lu@intel.com> wrote:
> > > 
> > > > FYI, we noticed the below changes on
> > > > 
> > > > git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> > > > commit a43455a1d572daf7b730fe12eb747d1e17411365 ("sched/numa: Ensure task_numa_migrate() checks the preferred node")
> > > > 
> > > > ebe06187bf2aec1  a43455a1d572daf7b730fe12e  
> > > > ---------------  -------------------------  
> > > >      94500 ~ 3%    +115.6%     203711 ~ 6%  ivb42/hackbench/50%-threads-pipe
> > > >      67745 ~ 4%     +64.1%     111174 ~ 5%  lkp-snb01/hackbench/50%-threads-socket
> > > >     162245 ~ 3%     +94.1%     314885 ~ 6%  TOTAL proc-vmstat.numa_hint_faults_local
> > > 
> > > Hi Aaron,
> > > 
> > > Jirka Hladky has reported a regression with that changeset as
> > > well, and I have already spent some time debugging the issue.
> > 
> > So assuming those numbers above are the difference in
> 
> Yes, they are.
> 
> It means, for commit ebe06187bf2aec1, the number for
> num_hint_local_faults is 94500 for ivb42 machine and 67745 for lkp-snb01
> machine. The 3%, 4% following that number means the deviation of the
> different runs to their average(we usually run it multiple times to
> phase out possible sharp values). We should probably remove that
> percentage, as they cause confusion if no detailed explanation and may
> not mean much to the commit author and others(if the deviation is big
> enough, we should simply drop that result).
> 
> The percentage in the middle is the change between the two commits.
> 
> Another thing is the meaning of the numbers, it doesn't seem that
> evident they are for proc-vmstat.numa_hint_faults_local. Maybe something
> like this is better?

Instead of removing info, why not document what each piece of data
represents. Or add headers to the table. etc.

Thanks,
Davidlohr

