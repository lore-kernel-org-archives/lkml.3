Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452AbaBNQip (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 11:38:45 -0500
Received: from mail-qc0-f172.google.com ([209.85.216.172]:44996 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbaBNQio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 11:38:44 -0500
Date: Fri, 14 Feb 2014 11:38:40 -0500
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Jason J. Herne" <jjherne@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: Subject: Warning in workqueue.c
Message-ID: <20140214163840.GH31544@htj.dyndns.org>
References: <20140207193604.GA8833@htj.dyndns.org>
 <52F8F0FB.3080206@linux.vnet.ibm.com>
 <20140210231742.GK25350@mtj.dyndns.org>
 <52FB90C6.4010701@linux.vnet.ibm.com>
 <52FC3C83.8020303@cn.fujitsu.com>
 <52FD07B2.5080402@linux.vnet.ibm.com>
 <20140213204102.GC17608@htj.dyndns.org>
 <20140214160923.GK27965@twins.programming.kicks-ass.net>
 <20140214162556.GF31544@htj.dyndns.org>
 <20140214162854.GO27965@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140214162854.GO27965@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 05:28:54PM +0100, Peter Zijlstra wrote:
> On Fri, Feb 14, 2014 at 11:25:56AM -0500, Tejun Heo wrote:
> > Hey, we now even keep normal kthreads across cpu down/ups. :)
> 
> Well, we keep them, but parked, they're not allowed to run.

Yeah, that's true.  In the long term, I think we'll need to have
better distinction between the work items which actually need affinity
for correctness and which is just doing it as an optimization.  It's
already happening now in a rather ad-hoc way with WQ_POWER_EFFICIENT.
Anyways, once we actually make that distinction clearly, it should
probably be possible to flush all per-cpu ones and keep them parked
across offline.  Right now, we have mixture of the two and the
knowledge is only present in cpu_down callbacks of each user making it
difficult to do that.

Thanks.

-- 
tejun
