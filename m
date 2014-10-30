Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760345AbaJ3OOO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 10:14:14 -0400
Received: from gum.cmpxchg.org ([85.214.110.215]:43326 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753923AbaJ3OON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 10:14:13 -0400
Date: Thu, 30 Oct 2014 10:14:01 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Michal Hocko <mhocko@suse.cz>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, riel@redhat.com, peterz@infradead.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm: initialize variable for mem_cgroup_end_page_stat
Message-ID: <20141030141401.GA24520@phnom.home.cmpxchg.org>
References: <1414633464-19419-1-git-send-email-sasha.levin@oracle.com>
 <20141030082712.GB4664@dhcp22.suse.cz>
 <54523DDE.9000904@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54523DDE.9000904@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 09:32:14AM -0400, Sasha Levin wrote:
> On 10/30/2014 04:27 AM, Michal Hocko wrote:
> > On Wed 29-10-14 21:44:24, Sasha Levin wrote:
> >> > Commit "mm: memcontrol: fix missed end-writeback page accounting" has changed
> >> > the behaviour of mem_cgroup_begin_page_stat() to not always set the "locked"
> >> > parameter.
> >> > 
> >> > We should initialize it at the callers to prevent garbage being used in a
> >> > later call to mem_cgroup_end_page_stat().
> > The contract is that if the returned memcg is non-NULL then the locked
> > is always initialized. Nobody but mem_cgroup_end_page_stat should touch
> > this variable and this function makes sure it uses it properly. Similar
> > applies to flags which is initialized only if we really take the slow
> > path (has a meaning only if locked == true).
> > 
> > So this is not really needed. Was this triggered by a compiler warning?
> 
> The problem is that you are attempting to read 'locked' when you call
> mem_cgroup_end_page_stat(), so it gets used even before you enter the
> function - and using uninitialized variables is undefined.

We are not using that value anywhere if !memcg.  What path are you
referring to?

> Yes, it's a compiler warning.

Could you provide that please, including arch, and gcc version?

Thanks
