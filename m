Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021AbaFLN4S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 09:56:18 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:34952 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755792AbaFLN4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 09:56:17 -0400
Date: Thu, 12 Jun 2014 09:56:00 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Greg Thelen <gthelen@google.com>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Michel Lespinasse <walken@google.com>, Tejun Heo <tj@kernel.org>,
        Roman Gushchin <klamm@yandex-team.ru>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] memcg: Allow guarantee reclaim
Message-ID: <20140612135600.GI2878@cmpxchg.org>
References: <20140611075729.GA4520@dhcp22.suse.cz>
 <1402473624-13827-1-git-send-email-mhocko@suse.cz>
 <1402473624-13827-2-git-send-email-mhocko@suse.cz>
 <20140611153631.GH2878@cmpxchg.org>
 <20140612132207.GA32720@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140612132207.GA32720@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 03:22:07PM +0200, Michal Hocko wrote:
> On Wed 11-06-14 11:36:31, Johannes Weiner wrote:
> [...]
> > This code is truly dreadful.
> > 
> > Don't call it guarantee when it doesn't guarantee anything.  I thought
> > we agreed that min, low, high, max, is reasonable nomenclature, please
> > use it consistently.
> 
> I can certainly change the internal naming. I will use your wmark naming
> suggestion.

Cool, thanks.

> > With my proposed cleanups and scalability fixes in the other mail, the
> > vmscan.c changes to support the min watermark would be something like
> > the following.
> 
> The semantic is, however, much different as pointed out in the other email.
> The following on top of you cleanup will lead to the same deadlock
> described in 1st patch (mm, memcg: allow OOM if no memcg is eligible
> during direct reclaim).

I'm currently reworking shrink_zones() and getting rid of
all_unreclaimable() etc. to remove the code duplication.

> Anyway, the situation now is pretty chaotic. I plan to gather all the
> patchse posted so far and repost for the future discussion. I just need
> to finish some internal tasks and will post it soon.

That would be great, thanks, it's really hard to follow this stuff
halfway in and halfway outside of -mm.

Now that we roughly figured out what knobs and semantics we want, it
would be great to figure out the merging logistics.

I would prefer if we could introduce max, high, low, min in unified
hierarchy, and *only* in there, so that we never have to worry about
it coexisting and interacting with the existing hard and soft limit.

It would also be beneficial to introduce them all close to each other,
develop them together, possibly submit them in the same patch series,
so that we know the requirements and how the code should look like in
the big picture and can offer a fully consistent and documented usage
model in the unified hierarchy.

Does that make sense?
