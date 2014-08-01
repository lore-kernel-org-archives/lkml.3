Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbaHAIOa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 04:14:30 -0400
Received: from mga14.intel.com ([192.55.52.115]:60991 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648AbaHAIO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 04:14:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,778,1400050800"; 
   d="scan'208";a="570365214"
Date: Fri, 1 Aug 2014 16:14:23 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Aaron Lu <aaron.lu@intel.com>, Rik van Riel <riel@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org, jhladky@redhat.com
Subject: Re: [LKP] [sched/numa] a43455a1d57: +94.1%
 proc-vmstat.numa_hint_faults_local
Message-ID: <20140801081423.GA21249@localhost>
References: <53d70ee6.JsUEmW5dWsv8dev+%fengguang.wu@intel.com>
 <53D72FF5.90908@intel.com>
 <20140729023940.37b6aebc@annuminas.surriel.com>
 <20140731104241.GA9918@twins.programming.kicks-ass.net>
 <20140801020330.GA30211@aaronlu.sh.intel.com>
 <20140801072911.GE19379@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140801072911.GE19379@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2014 at 09:29:11AM +0200, Peter Zijlstra wrote:
> On Fri, Aug 01, 2014 at 10:03:30AM +0800, Aaron Lu wrote:
> > > > > ebe06187bf2aec1  a43455a1d572daf7b730fe12e  
> > > > > ---------------  -------------------------  
> > > > >      94500 ~ 3%    +115.6%     203711 ~ 6%  ivb42/hackbench/50%-threads-pipe
> > > > >      67745 ~ 4%     +64.1%     111174 ~ 5%  lkp-snb01/hackbench/50%-threads-socket
> > > > >     162245 ~ 3%     +94.1%     314885 ~ 6%  TOTAL proc-vmstat.numa_hint_faults_local
> 
> > It means, for commit ebe06187bf2aec1, the number for
> > num_hint_local_faults is 94500 for ivb42 machine and 67745 for lkp-snb01
> > machine. The 3%, 4% following that number means the deviation of the
> > different runs to their average(we usually run it multiple times to
> > phase out possible sharp values). We should probably remove that
> > percentage, as they cause confusion if no detailed explanation and may
> > not mean much to the commit author and others(if the deviation is big
> > enough, we should simply drop that result).
> 
> Nah, variance is good, but the typical symbol would be +- or the fancy
> ±.
> 
> ~ when used as a unary op means 'approx' or 'about' or 'same order'
> ~ when used as a binary op means equivalence, a weaker equal, often in
> the vein of the unary op meaning.
> 
> Also see: http://en.wikipedia.org/wiki/Tilde#Mathematics
> 
> So while I think having a measure of variance is good, I think you
> picked entirely the wrong symbol.

Good point! We'll first try ± for the stddev percent and fall back to
+- if it turn out to not work well in some cases.

Thanks,
Fengguang
