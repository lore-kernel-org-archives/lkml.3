Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693Ab3GDKAy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 06:00:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40763 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751895Ab3GDKAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 06:00:52 -0400
Date: Thu, 4 Jul 2013 12:00:44 +0200
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
Message-ID: <20130704100044.GB7833@dhcp22.suse.cz>
References: <1372840460-5571-1-git-send-email-iamjoonsoo.kim@lge.com>
 <20130703152824.GB30267@dhcp22.suse.cz>
 <51D44890.4080003@gmail.com>
 <51D44AE7.1090701@gmail.com>
 <20130704042450.GA7132@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130704042450.GA7132@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 04-07-13 13:24:50, Joonsoo Kim wrote:
> On Thu, Jul 04, 2013 at 12:01:43AM +0800, Zhang Yanfei wrote:
> > On 07/03/2013 11:51 PM, Zhang Yanfei wrote:
> > > On 07/03/2013 11:28 PM, Michal Hocko wrote:
> > >> On Wed 03-07-13 17:34:15, Joonsoo Kim wrote:
> > >> [...]
> > >>> For one page allocation at once, this patchset makes allocator slower than
> > >>> before (-5%). 
> > >>
> > >> Slowing down the most used path is a no-go. Where does this slow down
> > >> come from?
> > > 
> > > I guess, it might be: for one page allocation at once, comparing to the original
> > > code, this patch adds two parameters nr_pages and pages and will do extra checks
> > > for the parameter nr_pages in the allocation path.
> > > 
> > 
> > If so, adding a separate path for the multiple allocations seems better.
> 
> Hello, all.
> 
> I modify the code for optimizing one page allocation via likely macro.
> I attach a new one at the end of this mail.
> 
> In this case, performance degradation for one page allocation at once is -2.5%.
> I guess, remained overhead comes from two added parameters.
> Is it unreasonable cost to support this new feature?

Which benchmark you are using for this testing?

> I think that readahead path is one of the most used path, so this penalty looks
> endurable. And after supporting this feature, we can find more use cases.

What about page faults? I would oppose that page faults are _much_ more
frequent than read ahead so you really cannot slow them down.

[...]
-- 
Michal Hocko
SUSE Labs
