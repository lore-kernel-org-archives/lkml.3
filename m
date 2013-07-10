Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab3GJL1m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 07:27:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53468 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754395Ab3GJL1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 07:27:40 -0400
Date: Wed, 10 Jul 2013 13:27:37 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Zhang Yanfei <zhangyanfei.yes@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        Glauber Costa <glommer@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        Minchan Kim <minchan@kernel.org>, Jiang Liu <jiang.liu@huawei.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] Support multiple pages allocation
Message-ID: <20130710112737.GG4437@dhcp22.suse.cz>
References: <1372840460-5571-1-git-send-email-iamjoonsoo.kim@lge.com>
 <20130703152824.GB30267@dhcp22.suse.cz>
 <51D44890.4080003@gmail.com>
 <51D44AE7.1090701@gmail.com>
 <20130704042450.GA7132@lge.com>
 <20130704100044.GB7833@dhcp22.suse.cz>
 <20130710003142.GA2152@lge.com>
 <20130710091703.GD4437@dhcp22.suse.cz>
 <20130710095533.GA5557@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130710095533.GA5557@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 10-07-13 18:55:33, Joonsoo Kim wrote:
> On Wed, Jul 10, 2013 at 11:17:03AM +0200, Michal Hocko wrote:
> > On Wed 10-07-13 09:31:42, Joonsoo Kim wrote:
> > > On Thu, Jul 04, 2013 at 12:00:44PM +0200, Michal Hocko wrote:
[...]
> > > > Which benchmark you are using for this testing?
> > > 
> > > I use my own module which do allocation repeatedly.
> > 
> > I am not sure this microbenchmark will tell us much. Allocations are
> > usually not short lived so the longer time might get amortized.
> > If you want to use the multi page allocation for read ahead then try to
> > model your numbers on read-ahead workloads.
> 
> Of couse. In later, I will get the result on read-ahead workloads or
> vmalloc workload which is recommended by Zhang.
> 
> I think, without this microbenchmark, we cannot know this modification's
> performance effect to single page allocation accurately. Because the impact
> to single page allocation is relatively small and it is easily hidden by
> other factors.

The main thing is whether the numbers you get from an artificial
microbenchmark matter at all. You might see a regression which cannot be
hit in practice because other effects are of magnitude more significant.
-- 
Michal Hocko
SUSE Labs
