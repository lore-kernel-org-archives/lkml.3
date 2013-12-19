Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574Ab3LSKWg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 05:22:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47507 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008Ab3LSKWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 05:22:33 -0500
Date: Thu, 19 Dec 2013 11:22:31 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Rik van Riel <riel@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Chao Yang <chayang@redhat.com>, linux-mm@kvack.org,
        aarcange@redhat.com, mgorman@suse.de,
        Veaceslav Falico <vfalico@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        David Rientjes <rientjes@google.com>,
        Michel Lespinasse <walken@google.com>
Subject: Re: [PATCH] mm,numa,THP: initialize hstate for THP page size
Message-ID: <20131219102231.GE10855@dhcp22.suse.cz>
References: <20131218170314.1e57bea7@cuia.bos.redhat.com>
 <20131218140830.924fa0a3bab0d497db5e256c@linux-foundation.org>
 <52B21FC7.7070905@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52B21FC7.7070905@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Adding Dave and Mel]

On Wed 18-12-13 17:20:55, Rik van Riel wrote:
> On 12/18/2013 05:08 PM, Andrew Morton wrote:
> >On Wed, 18 Dec 2013 17:03:14 -0500 Rik van Riel <riel@redhat.com> wrote:
> >
> >>When hugetlbfs is started with a non-default page size, it is
> >>possible that no hstate is initialized for the page sized used
> >>by transparent huge pages.
> >>
> >>This causes copy_huge_page to crash on a null pointer. Make
> >>sure we always have an hstate initialized for the page sized
> >>used by THP.
> >>
> >
> >A bit more context is needed here please - so that people can decide
> >which kernel version(s) need patching.
> 
> That is a good question.
> 
> Looking at the git log, this might go back to 2008,
> when the hugepagesz and default_hugepagesz boot
> options were introduced.
> 
> Of course, back then there was no way to use 2MB
> pages together with 1GB pages.
> 
> That did not come until transparent huge pages were
> introduced back in 2011.  It looks like the transparent
> huge page code avoids the bug (accidentally?) by calling
> copy_user_huge_page when COWing a THP, instead of
> copy_huge_page, this avoids iterating over hstates[].
> 
> That means it should not be possible for the bug to
> have been triggered until the numa balancing code
> got merged.
> 

copy_huge_page as hugetlb specific thing. It relies on hstate which is
obviously not existing for THP pages. So why do we use it for thp pages
in the first place?

Mel, your "mm: numa: Add THP migration for the NUMA working set scanning
fault case." has added check for PageTransHuge in migrate_page_copy so
it uses the shared copy_huge_page now. Dave has already tried to fix it
by https://lkml.org/lkml/2013/10/28/592 but this one has been dropped
later with "to-be-updated".

Dave do you have an alternative for your patch?

-- 
Michal Hocko
SUSE Labs
