Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991AbaIMMlm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 08:41:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:2683 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471AbaIMMll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 08:41:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,517,1406617200"; 
   d="scan'208";a="590826979"
Date: Sat, 13 Sep 2014 20:41:38 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Christoph Lameter <cl@linux.com>, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        LKP <lkp@01.org>, linux-kernel@vger.kernel.org
Subject: Re: [percpu] BUG: unable to handle kernel NULL pointer dereference
 at (null)
Message-ID: <20140913124138.GB20185@localhost>
References: <20140902045830.GA11321@localhost>
 <20140902153403.GY5001@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1409021052400.10607@gentwo.org>
 <20140902162110.GB5001@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1409021155410.10607@gentwo.org>
 <20140902171657.GG5001@linux.vnet.ibm.com>
 <20140904123845.GA19925@localhost>
 <20140904160428.GE5001@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140904160428.GE5001@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 09:04:28AM -0700, Paul E. McKenney wrote:
> On Thu, Sep 04, 2014 at 08:38:45PM +0800, Fengguang Wu wrote:
> > On Tue, Sep 02, 2014 at 10:16:57AM -0700, Paul E. McKenney wrote:
> > > On Tue, Sep 02, 2014 at 11:55:58AM -0500, Christoph Lameter wrote:
> > > > On Tue, 2 Sep 2014, Paul E. McKenney wrote:
> > > > 
> > > > > Added by ac1bea85781e (sched,rcu: Make cond_resched() report RCU quiescent
> > > > > states), removed by 4a81e8328d379 (rcu: Reduce overhead of cond_resched()
> > > > > checks for RCU).  So, as you say, no effect on contemporary kernels.
> > > > 
> > > > Well not sure what to make out of all of this....
> > > 
> > > Yep, still confused as to how the patch adding the definition could have
> > > caused a failure.  Fengguang, any thoughts?
> > 
> > Yeah this is confusing.. I checked carefully and find that commit
> > 0e98023 and afea227 are built on 2 quite different servers -- which
> > might generate slightly different code. I'll fix this issue and make
> > the build server selection more consistent.
> 
> Looking forward to seeing what shows up!

The new bisect catches commit 945fa9c631b04febe295a3a2a00c7e4a3cfb97db
("torture: Dump ftrace buffer when the RCU grace period stalls"). I
just reported it in another email.

Thanks,
Fengguang
