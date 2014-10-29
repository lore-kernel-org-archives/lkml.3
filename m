Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041AbaJ2IQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 04:16:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:40684 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755513AbaJ2IQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 04:16:51 -0400
Date: Wed, 29 Oct 2014 09:16:40 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Vikas Shivappa <vikas.shivappa@linux.intel.com>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        Will Auld <will.auld@intel.com>, Tejun Heo <tj@kernel.org>,
        Vikas Shivappa <vikas.shivappa@intel.com>
Subject: Re: Cache Allocation Technology Design
Message-ID: <20141029081640.GT3337@twins.programming.kicks-ass.net>
References: <1413485050.28564.14.camel@vshiva-Udesk>
 <20141020161855.GF12020@console-pimps.org>
 <20141024105306.GI12706@worktop.programming.kicks-ass.net>
 <20141028232215.GO12020@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141028232215.GO12020@console-pimps.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 11:22:15PM +0000, Matt Fleming wrote:
> On Fri, 24 Oct, at 12:53:06PM, Peter Zijlstra wrote:
> > 
> > NAK, cgroups must support full hierarchies, simply enforce that the
> > child cgroup's mask is a subset of the parent's.
> 
> For the specific case of Cache Allocation, if we're creating hierarchies
> from bitmasks, there's a very clear limit to how we can divide up the
> bits - we can't support an indefinite number of cgroup directories.
> 
> What do you mean by "full hierarchies"?

Ah, so one way around that is to only assign a (whats the CQE equivalent
of RMIDs again?) once you stick a task in.

But basically it means you need to allow things like:

root/virt/more/crap/hostA
                   /hostB
    /sanityA
    /random/other/yunk

Now, the root will have the entire bitmask set, any child, say
virt/more/crap can also have them all set, and you can maybe only start
differentiating in the /host[AB] bits.

Whether or not it makes sense, libvirt likes to create these pointless
deep hierarchies, as do a lot of other people for that matter.


