Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943AbaBXSfK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 13:35:10 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:65432 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903AbaBXSfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 13:35:05 -0500
Date: Mon, 24 Feb 2014 13:35:01 -0500
From: Tejun Heo <tj@kernel.org>
To: "Jason J. Herne" <jjherne@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: Subject: Warning in workqueue.c
Message-ID: <20140224183501.GC2522@htj.dyndns.org>
References: <20140207193604.GA8833@htj.dyndns.org>
 <52F8F0FB.3080206@linux.vnet.ibm.com>
 <20140210231742.GK25350@mtj.dyndns.org>
 <52FB90C6.4010701@linux.vnet.ibm.com>
 <52FC3C83.8020303@cn.fujitsu.com>
 <52FD07B2.5080402@linux.vnet.ibm.com>
 <20140213204102.GC17608@htj.dyndns.org>
 <20140214160923.GK27965@twins.programming.kicks-ass.net>
 <20140214162556.GF31544@htj.dyndns.org>
 <530B5EE3.8050200@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530B5EE3.8050200@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 10:01:55AM -0500, Jason J. Herne wrote:
> On 02/14/2014 11:25 AM, Tejun Heo wrote:
> >...
> >Hmmm... weird, p's rq shouldn't have changed without its cpus_allowed
> >busted.  Anyways, let's wait for Jason's test results and see whether
> >this is a regression at all.
> 
> I was unable to determine exactly when this behavior was introduced.
> The reason for this is because I keep hitting other bugs that
> prevent the test case from running, the most notable of which causes
> an immediate system hang. I also hit other warnings and bug messages
> and I'm not sure if they are related or if they will influence the
> probability of hitting the problem we are trying to solve here.
> What I did find is the following:
> 
> We hit this problem as far back as v3.10.
> The warning was introduced after v3.5 but before v3.6.

That's a bummer but it at least isn't a very new regression.  Peter,
any ideas on debugging this?  I can make workqueue to play block /
unblock dance to try to work around the issue but that'd be very
yucky.  It'd be great to root cause where the cpu selection anomaly is
coming from.

Thanks.

-- 
tejun
