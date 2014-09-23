Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050AbaIWO2W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 10:28:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39531 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752957AbaIWO2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 10:28:19 -0400
Date: Tue, 23 Sep 2014 16:28:16 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, Greg Thelen <gthelen@google.com>,
        Dave Hansen <dave@sr71.net>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: memcontrol: lockless page counters
Message-ID: <20140923142816.GC10046@dhcp22.suse.cz>
References: <1411132928-16143-1-git-send-email-hannes@cmpxchg.org>
 <20140922144436.GG336@dhcp22.suse.cz>
 <20140922155049.GA6630@cmpxchg.org>
 <20140922172800.GA4343@dhcp22.suse.cz>
 <20140922195829.GA5197@cmpxchg.org>
 <20140923132553.GB10046@dhcp22.suse.cz>
 <20140923140526.GA15014@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140923140526.GA15014@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 23-09-14 10:05:26, Johannes Weiner wrote:
[...]
> That's one way to put it.  But the way I see it is that I remove a
> generic resource counter and replace it with a pure memory counter
> which I put where we account and limit memory - with one exception
> that is hardly worth creating a dedicated library file for.

So you completely seem to ignore people doing CONFIG_CGROUP_HUGETLB &&
!CONFIG_MEMCG without any justification and hiding it behind performance
improvement which those users even didn't ask for yet.

All that just to not have one additional header and c file hidden by
CONFIG_PAGE_COUNTER selected by both controllers. No special
configuration option is really needed for CONFIG_PAGE_COUNTER.

> I only explained my plans of merging all memory controllers because I
> assumed we could ever be on the same page when it comes to this code.

I doubt this is a good plan but I might be wrong here. The main thing
stays there is no good reason to make hugetlb depend on memcg right now
and such a change _shouldn't_ be hidden behind an unrelated change. From
hugetlb container point of view this is just a different counter which
doesn't depend on memcg. I am really surprised you are pushing for this
so hard right now because it only distracts from the main motivation of
your patch.

> But regardless of that, my approach immediately simplifies Kconfig,
> Makefiles, #includes, and you haven't made a good point why the
> hugetlb controller depending on memcg would harm anybody in real life.

Usecases for hugetlb and memcg controllers have basically zero overlap
they simply manage different resources and so it is natural to use one
without the other.
-- 
Michal Hocko
SUSE Labs
