Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbaA0RGJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 12:06:09 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:42360 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675AbaA0RGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 12:06:07 -0500
Date: Mon, 27 Jan 2014 09:06:02 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@linux.intel.com,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [rcu] c0f4dfd4f9: -65% softirqs.RCU
Message-ID: <20140127170602.GO9012@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140119121608.GB2859@localhost>
 <20140119231114.GE10038@linux.vnet.ibm.com>
 <20140120122912.GA18137@localhost>
 <20140121044100.GS10038@linux.vnet.ibm.com>
 <20140124111130.GA24254@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140124111130.GA24254@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14012717-0928-0000-0000-00000600D69B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 24, 2014 at 07:11:30PM +0800, Fengguang Wu wrote:
> On Mon, Jan 20, 2014 at 08:41:00PM -0800, Paul E. McKenney wrote:
> > On Mon, Jan 20, 2014 at 08:29:12PM +0800, Fengguang Wu wrote:
> > > On Sun, Jan 19, 2014 at 03:11:14PM -0800, Paul E. McKenney wrote:
> > > > On Sun, Jan 19, 2014 at 08:16:08PM +0800, Fengguang Wu wrote:
> > > > > Hi Paul,
> > > > > 
> > > > > Just FYI, we noticed the following changes (which looks good) on old commit
> > > > > c0f4dfd4f9 ("rcu: Make RCU_FAST_NO_HZ take advantage of numbered callbacks") 
> > > > > in test case dd-write/4HDD-JBOD-cfq-btrfs-1dd:
> > > > > 
> > > > > b11cc5 (parent)  c0f4dfd4f90f1667d234d21f1  
> > > > > ---------------  -------------------------  
> > > > >     213757 ~ 4%     -65.4%      73929 ~ 3%  softirqs.RCU
> > > > >      21193 ~ 5%     -36.5%      13451 ~ 4%  softirqs.SCHED
> > > > >       2036 ~ 4%     -59.4%        825 ~ 3%  vmstat.system.cs
> > > > >    1304520 ~ 4%     -59.2%     532451 ~ 3%  perf-stat.context-switches
> > > > >      95685 ~ 4%     -44.0%      53598 ~ 2%  perf-stat.cpu-migrations
> > > > 
> > > > Glad it helped!  IIRC, this same commit increased latencies due to
> > > > synchronize_rcu() latency increasing.  So this is the good side of
> > > > that other not-so-good result.  ;-)
> > > 
> > > If you care it and there is a low cost way for user space to get that
> > > synchronize_rcu() latency, I'd be eager to collect it in my tests. :)
> > 
> > Would a kernel module that measured the latency be OK, or do you need
> > some system call that is exposed to synchronize_rcu() latency?
> 
> Kernel module should be good enough for me. Perhaps something like
> kernel/latencytop.c?

So you are looking for something that measures synchronize_rcu() latency
for the synchronize_rcu() calls that occur naturally in the kernel, rather
than having a focused microbenchmark?

							Thanx, Paul

