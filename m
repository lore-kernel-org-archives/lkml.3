Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376AbaEHS2y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 14:28:54 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:60607 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753497AbaEHS2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 14:28:52 -0400
Date: Thu, 8 May 2014 14:28:48 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, Hugh Dickins <hughd@google.com>,
        Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 3/9] mm: memcontrol: retry reclaim for oom-disabled and
 __GFP_NOFAIL charges
Message-ID: <20140508182848.GP19914@cmpxchg.org>
References: <1398889543-23671-1-git-send-email-hannes@cmpxchg.org>
 <1398889543-23671-4-git-send-email-hannes@cmpxchg.org>
 <20140507144339.GI9489@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140507144339.GI9489@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 04:43:39PM +0200, Michal Hocko wrote:
> On Wed 30-04-14 16:25:37, Johannes Weiner wrote:
> > There is no reason why oom-disabled and __GFP_NOFAIL charges should
> > try to reclaim only once when every other charge tries several times
> > before giving up.  Make them all retry the same number of times.
> 
> I guess the idea whas that oom disabled (THP) allocation can fallback to
> a smaller allocation. I would suspect this would increase latency for
> THP page faults.

If it does, we should probably teach THP to use __GFP_NORETRY.

On that note, __GFP_NORETRY is currently useless for memcg because it
has !__GFP_WAIT semantics...  I'll include a fix for that in v2.
