Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338AbaIVR2H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 13:28:07 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:64079 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958AbaIVR2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 13:28:05 -0400
Date: Mon, 22 Sep 2014 19:28:00 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, Greg Thelen <gthelen@google.com>,
        Dave Hansen <dave@sr71.net>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: memcontrol: lockless page counters
Message-ID: <20140922172800.GA4343@dhcp22.suse.cz>
References: <1411132928-16143-1-git-send-email-hannes@cmpxchg.org>
 <20140922144436.GG336@dhcp22.suse.cz>
 <20140922155049.GA6630@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140922155049.GA6630@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 22-09-14 11:50:49, Johannes Weiner wrote:
> On Mon, Sep 22, 2014 at 04:44:36PM +0200, Michal Hocko wrote:
> > On Fri 19-09-14 09:22:08, Johannes Weiner wrote:
[...]
> > Nevertheless I think that the counter should live outside of memcg (it
> > is ugly and bad in general to make HUGETLB controller depend on MEMCG
> > just to have a counter). If you made kernel/page_counter.c and led both
> > containers select CONFIG_PAGE_COUNTER then you do not need a dependency
> > on MEMCG and I would find it cleaner in general.
> 
> The reason I did it this way is because the hugetlb controller simply
> accounts and limits a certain type of memory and in the future I would
> like to make it a memcg extension, just like kmem and swap.

I am not sure this is the right way to go. Hugetlb has always been
"special" and I do not see any advantage to pull its specialness into
memcg proper. It would just make the code more complicated. I can also
imagine users who simply do not want to pay memcg overhead and use only
hugetlb controller.

Besides that it is not like a separate page_counter with a clear
interface would cause more maintenance overhead so I really do not see
any reason to pull it into memcg.
-- 
Michal Hocko
SUSE Labs
