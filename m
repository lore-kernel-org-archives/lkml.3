Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033Ab3GQJUh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 05:20:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41053 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446Ab3GQJUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 05:20:35 -0400
Date: Wed, 17 Jul 2013 11:20:31 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Li Zefan <lizefan@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>,
        Glauber Costa <glommer@openvz.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        kernel-team@lists.ubuntu.com, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [ 3.8.y.z extended stable ] Patch "memcg, kmem: fix reference
 count handling on the error path" has been added to staging queue
Message-ID: <20130717092031.GA31184@dhcp22.suse.cz>
References: <1374015242-28112-1-git-send-email-kamal@canonical.com>
 <20130716160658.fc30d70b5230aab5b3b3950b@linux-foundation.org>
 <1374018009.3225.123.camel@fourier>
 <20130716174548.f34bc75e.akpm@linux-foundation.org>
 <51E638D6.6030004@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E638D6.6030004@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 17-07-13 14:25:26, Li Zefan wrote:
> On 2013/7/17 8:45, Andrew Morton wrote:
> > On Tue, 16 Jul 2013 16:40:09 -0700 Kamal Mostafa <kamal@canonical.com> wrote:
> > 
> >> On Tue, 2013-07-16 at 16:06 -0700, Andrew Morton wrote:
> >>> On Tue, 16 Jul 2013 15:54:02 -0700 Kamal Mostafa <kamal@canonical.com> wrote:
> >>>
> >>>> This is a note to let you know that I have just added a patch titled
> >>>>
> >>>>     memcg, kmem: fix reference count handling on the error path
> >>>>
> >>>> to the linux-3.8.y-queue branch of the 3.8.y.z extended stable tree 
> >>>> which can be found at:
> >>>
> >>> hm, why.
> >>
> >> Because it said "Cc: <stable@vger.kernel.org> [3.8]", making me think
> >> the author specifically wanted it to be applied to 3.8-stable.
> > 
> > Damn, so it did, sorry.  Your version removed that line.
> > 
> > I don't know why I did that - afaict problems can only occur when
> > kmalloc(GFP_KERNEL) fails, and that's exceedingly unlikely.
> > 
> 
> I added the stable tag to this and the other patch, because the bugs were
> regressions introduced in recent kernels, and Michal sugguest we may want
> to backport them (but not in a strong feeling).

Yes it was a clear regression so I considered it good enough for stable.

> But surely the bug is extreamly unlikely,

But now that I am thinking about it some more it doesn't sounds that
unlikely. With kmem accounting the kmalloc allocation might fail much
more easily. What if the task which creates the group reaches the kmem
limit in its group?

So I think adding this to stable makes some sense. I agree that the
changelog could have been much more specific and will try to do better
next time.

The patch fixes reference counting imbalance and potential
use-after-free.

> and seems we currently want to be more strictly on what patches should
> go into stable, I think it's fine to drop it from stable.

-- 
Michal Hocko
SUSE Labs
