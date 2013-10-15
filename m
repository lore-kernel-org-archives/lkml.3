Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933884Ab3JOVE6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 17:04:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35537 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933794Ab3JOVEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 17:04:50 -0400
Date: Tue, 15 Oct 2013 17:03:20 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, Matt Mackall <mpm@selenic.com>,
        Cliff Wickman <cpw@sgi.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Pavel Emelyanov <xemul@parallels.com>, linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Mark Brown <broonie@kernel.org>
Message-ID: <1381871000-7fqziuur-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <20131015134317.02d819f6905f790007ba1842@linux-foundation.org>
References: <1381772230-26878-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <20131015134317.02d819f6905f790007ba1842@linux-foundation.org>
Subject: Re: [PATCH 0/11] update page table walker
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 01:43:17PM -0700, Andrew Morton wrote:
> On Mon, 14 Oct 2013 13:36:59 -0400 Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:
> 
> > Page table walker is widely used when you want to traverse page table
> > tree and do some work for the entries (and pages pointed to by them.)
> > This is a common operation, and keep the code clean and maintainable
> > is important. Moreover this patchset introduces caller-specific walk
> > control function which is helpful for us to newly introduce page table
> > walker to some other users. Core change comes from patch 1, so please
> > see it for how it's supposed to work.
> > 
> > This patchset changes core code in mm/pagewalk.c at first in patch 1 and 2,
> > and then updates all of current users to make the code cleaner in patch
> > 3-9. Patch 10 changes the interface of hugetlb_entry(), I put it here to
> > keep bisectability of the whole patchset. Patch 11 applies page table walker
> > to a new user queue_pages_range().
> 
> Unfortunately this is very incompatible with pending changes in
> fs/proc/task_mmu.c.  Especially Kirill's "mm, thp: change
> pmd_trans_huge_lock() to return taken lock".

OK, I'll rebase onto mmots in the next post, maybe after waiting for
a few days on the chance that somebody make comments and feedbacks.

> 
> Stephen will be away for a couple more weeks so I'll get an mmotm
> released and hopefully Thierry and Mark will scoop it up(?). 
> Alternatively, http://git.cmpxchg.org/?p=linux-mmots.git;a=summary is
> up to date.
> 
> Please take a look, decide what you think we should do?

This patchset is ver.1, so I think that we need reviews before thinking
about merging. Please wait for my next post on top of this tree.

Thanks,
Naoya Horiguchi
