Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761AbaJINGY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 09:06:24 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:37826 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbaJINGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 09:06:15 -0400
Date: Thu, 9 Oct 2014 09:06:11 -0400
From: Tejun Heo <tj@kernel.org>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, lizefan@huawei.com, anton@samba.org,
        svaidy@linux.vnet.ibm.com, rjw@rjwysocki.net,
        paulmck@linux.vnet.ibm.com, mingo@kernel.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpusets: Make cpus_allowed and mems_allowed masks
 hotplug invariant
Message-ID: <20141009130611.GA14387@htj.dyndns.org>
References: <20141008070739.1170.33313.stgit@preeti.in.ibm.com>
 <20141008080706.GC10832@worktop.programming.kicks-ass.net>
 <543505EF.7070804@linux.vnet.ibm.com>
 <20141008101828.GG10832@worktop.programming.kicks-ass.net>
 <54364564.3090305@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54364564.3090305@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2014 at 01:50:52PM +0530, Preeti U Murthy wrote:
> However what remains to be answered is that the V2 of cgroup design -
> the default hierarchy, tracks hotplug operations for children cgroups as
> well. Tejun, Li, will not the concerns that Peter raised above hold for
> the default hierarchy as well?

I don't think the legacy one is a good design.  Kernel shouldn't lose
configurations in an irreversible way and the legacy one is also
making random cpuset flips by migrating tasks upwards anyway.  In
terms of hotunplug behavior, the legacy and unified ones behave the
same.  The only difference is that the configuration is independent of
the current state and the configured behavior is restored when the
cpus come back.  The other side is that the legacy hierarchy behavior
simply can't be allowed when the hierarchy is shared among multiple
controllers as in the unified hierarchy.  It affects all other
controllers attached to the hierarchy.

That said, we can't change the behavior on the legacy one.  It's a
very userland visible behavior.  We simply can't change it, so
unfortunately you're stuck with it at least on the legacy hierarchy.

Thanks.

-- 
tejun
