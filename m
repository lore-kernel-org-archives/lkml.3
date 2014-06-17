Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965078AbaFQQaz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:30:55 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:49369 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964847AbaFQQaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:30:52 -0400
Date: Tue, 17 Jun 2014 18:30:48 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov@parallels.com>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 04/12] mm: memcontrol: retry reclaim for oom-disabled and
 __GFP_NOFAIL charges
Message-ID: <20140617163048.GC9572@dhcp22.suse.cz>
References: <1402948472-8175-1-git-send-email-hannes@cmpxchg.org>
 <1402948472-8175-5-git-send-email-hannes@cmpxchg.org>
 <20140617135344.GC19886@dhcp22.suse.cz>
 <20140617154527.GC7331@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140617154527.GC7331@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 17-06-14 11:45:27, Johannes Weiner wrote:
> On Tue, Jun 17, 2014 at 03:53:44PM +0200, Michal Hocko wrote:
> > On Mon 16-06-14 15:54:24, Johannes Weiner wrote:
> > > There is no reason why oom-disabled and __GFP_NOFAIL charges should
> > > try to reclaim only once when every other charge tries several times
> > > before giving up.  Make them all retry the same number of times.
> > 
> > OK, this makes sense for oom-disabled and __GFP_NOFAIL but does it make
> > sense to do additional reclaim for tasks with fatal_signal_pending?
> > 
> > It is little bit unexpected, because we bypass if the condition happens
> > before the reclaim but then we ignore it.
> 
> "mm: memcontrol: rearrange charging fast path", moves the pending
> signal check inside the retry block, right before reclaim.

Right you are.

Acked-by: Michal Hocko <mhocko@suse.cz>

-- 
Michal Hocko
SUSE Labs
