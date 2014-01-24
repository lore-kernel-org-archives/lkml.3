Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371AbaAXLMG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 06:12:06 -0500
Received: from mga09.intel.com ([134.134.136.24]:63819 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475AbaAXLME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 06:12:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,712,1384329600"; 
   d="scan'208";a="464069228"
Date: Fri, 24 Jan 2014 19:11:30 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@linux.intel.com,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [rcu] c0f4dfd4f9: -65% softirqs.RCU
Message-ID: <20140124111130.GA24254@localhost>
References: <20140119121608.GB2859@localhost>
 <20140119231114.GE10038@linux.vnet.ibm.com>
 <20140120122912.GA18137@localhost>
 <20140121044100.GS10038@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140121044100.GS10038@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 08:41:00PM -0800, Paul E. McKenney wrote:
> On Mon, Jan 20, 2014 at 08:29:12PM +0800, Fengguang Wu wrote:
> > On Sun, Jan 19, 2014 at 03:11:14PM -0800, Paul E. McKenney wrote:
> > > On Sun, Jan 19, 2014 at 08:16:08PM +0800, Fengguang Wu wrote:
> > > > Hi Paul,
> > > > 
> > > > Just FYI, we noticed the following changes (which looks good) on old commit
> > > > c0f4dfd4f9 ("rcu: Make RCU_FAST_NO_HZ take advantage of numbered callbacks") 
> > > > in test case dd-write/4HDD-JBOD-cfq-btrfs-1dd:
> > > > 
> > > > b11cc5 (parent)  c0f4dfd4f90f1667d234d21f1  
> > > > ---------------  -------------------------  
> > > >     213757 ~ 4%     -65.4%      73929 ~ 3%  softirqs.RCU
> > > >      21193 ~ 5%     -36.5%      13451 ~ 4%  softirqs.SCHED
> > > >       2036 ~ 4%     -59.4%        825 ~ 3%  vmstat.system.cs
> > > >    1304520 ~ 4%     -59.2%     532451 ~ 3%  perf-stat.context-switches
> > > >      95685 ~ 4%     -44.0%      53598 ~ 2%  perf-stat.cpu-migrations
> > > 
> > > Glad it helped!  IIRC, this same commit increased latencies due to
> > > synchronize_rcu() latency increasing.  So this is the good side of
> > > that other not-so-good result.  ;-)
> > 
> > If you care it and there is a low cost way for user space to get that
> > synchronize_rcu() latency, I'd be eager to collect it in my tests. :)
> 
> Would a kernel module that measured the latency be OK, or do you need
> some system call that is exposed to synchronize_rcu() latency?

Kernel module should be good enough for me. Perhaps something like
kernel/latencytop.c?

Thanks,
Fengguang
