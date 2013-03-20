Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932916Ab3CTS4Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 14:56:25 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:43055 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755567Ab3CTS4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 14:56:23 -0400
Date: Wed, 20 Mar 2013 19:56:18 +0100
From: Michal Hocko <mhocko@suse.cz>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch] mm, hugetlb: include hugepages in meminfo
Message-ID: <20130320185618.GC970@dhcp22.suse.cz>
References: <alpine.DEB.2.02.1303191714440.13526@chino.kir.corp.google.com>
 <20130320095306.GA21856@dhcp22.suse.cz>
 <alpine.DEB.2.02.1303201145260.17761@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1303201145260.17761@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 20-03-13 11:46:12, David Rientjes wrote:
> On Wed, 20 Mar 2013, Michal Hocko wrote:
> 
> > On Tue 19-03-13 17:18:12, David Rientjes wrote:
> > > Particularly in oom conditions, it's troublesome that hugetlb memory is 
> > > not displayed.  All other meminfo that is emitted will not add up to what 
> > > is expected, and there is no artifact left in the kernel log to show that 
> > > a potentially significant amount of memory is actually allocated as 
> > > hugepages which are not available to be reclaimed.
> > 
> > Yes, I like the idea. It's bitten me already in the past.
> > 
> > The only objection I have is that you print only default_hstate. You
> > just need to wrap your for_each_node_state by for_each_hstate to do
> > that.  With that applied, feel free to add my
> > Acked-by: Michal Hocko <mhocko@suse.cz>
> > 
> 
> I didn't do this because it isn't already exported in /proc/meminfo and 
> since we've made an effort to reduce the amount of information emitted by 
> the oom killer at oom kill time to avoid spamming the kernel log, I only 
> print the default hstate.

I do not see how this would make the output too much excessive. If
you do not want to have too many lines in the output then the hstate
loop can be pushed inside the node loop and have only per-node number
of lines same as you are proposing except you would have a complete
information.
Besides that we are talking about handful of hstates.

-- 
Michal Hocko
SUSE Labs
