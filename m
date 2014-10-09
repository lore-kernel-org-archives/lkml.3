Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363AbaJIN7i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 09:59:38 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:41034 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbaJIN71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 09:59:27 -0400
Date: Thu, 9 Oct 2014 09:59:24 -0400
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Preeti U Murthy <preeti@linux.vnet.ibm.com>, lizefan@huawei.com,
        anton@samba.org, svaidy@linux.vnet.ibm.com, rjw@rjwysocki.net,
        paulmck@linux.vnet.ibm.com, mingo@kernel.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpusets: Make cpus_allowed and mems_allowed masks
 hotplug invariant
Message-ID: <20141009135924.GE14387@htj.dyndns.org>
References: <20141008070739.1170.33313.stgit@preeti.in.ibm.com>
 <20141008080706.GC10832@worktop.programming.kicks-ass.net>
 <543505EF.7070804@linux.vnet.ibm.com>
 <20141008101828.GG10832@worktop.programming.kicks-ass.net>
 <54364564.3090305@linux.vnet.ibm.com>
 <20141009130611.GA14387@htj.dyndns.org>
 <20141009134758.GU10832@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141009134758.GU10832@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Peter.

On Thu, Oct 09, 2014 at 03:47:58PM +0200, Peter Zijlstra wrote:
> You do know we disagree on this :-)

Yeap. :)

...
> And while you all can try and pretend hotplug is a 'normal' and 'sane'
> operation with cpusets, the same failure more very much still exists
> with the regular affinity controls. So you can pretend all you want, but
> its a clear and utter fail.
> 
> You cannot give the kernel contradictory instructions and then pretend
> all is well and dandy.

But even if you view it that way, the current legacy implementation is
deficient to say the least.  It puts way too much trust in the
userland while not giving it mechanisms to deal with the situation.
It's not like the userland is an all-knowing entity and short of the
printk there's no way to detect such automatic migrations or to know
the previous state.  If this actually was seen as a configuration
failure, it would have made a lot more sense to just not run those
tasks unless they're SIGKILL'd.

This is all moot tho.  We can't change the behavior for the legacy
hierarchies and we can't auto-migrate for the unified hierarchy, so
there isn't much left to decide.

Thanks.

-- 
tejun
