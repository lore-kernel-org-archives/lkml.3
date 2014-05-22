Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075AbaEVAIC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 20:08:02 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55479 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753793AbaEVAIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 20:08:00 -0400
Date: Thu, 22 May 2014 01:07:56 +0100
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>,
        Jan Kara <jack@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>
Subject: Re: [PATCH] mm: non-atomically mark page accessed during page cache
 allocation where possible -fix
Message-ID: <20140522000755.GB23991@suse.de>
References: <1399974350-11089-1-git-send-email-mgorman@suse.de>
 <1399974350-11089-19-git-send-email-mgorman@suse.de>
 <20140520154900.GO23991@suse.de>
 <20140520123453.09a76dd0c8fad40082a16289@linux-foundation.org>
 <20140521120916.GS23991@suse.de>
 <20140521151142.9d084dd64251bce4c44c214d@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20140521151142.9d084dd64251bce4c44c214d@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 03:11:42PM -0700, Andrew Morton wrote:
> On Wed, 21 May 2014 13:09:16 +0100 Mel Gorman <mgorman@suse.de> wrote:
> 
> > > From: Andrew Morton <akpm@linux-foundation.org>
> > > Subject: mm/shmem.c: don't run init_page_accessed() against an uninitialised pointer
> > > 
> > > If shmem_getpage() returned an error then it didn't necessarily initialise
> > > *pagep.  So shmem_write_begin() shouldn't be playing with *pagep in this
> > > situation.
> > > 
> > > Fixes an oops when "mm: non-atomically mark page accessed during page
> > > cache allocation where possible" (quite reasonably) left *pagep
> > > uninitialized.
> > > 
> > > Reported-by: Prabhakar Lad <prabhakar.csengg@gmail.com>
> > > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > > Cc: Vlastimil Babka <vbabka@suse.cz>
> > > Cc: Jan Kara <jack@suse.cz>
> > > Cc: Michal Hocko <mhocko@suse.cz>
> > > Cc: Hugh Dickins <hughd@google.com>
> > > Cc: Peter Zijlstra <peterz@infradead.org>
> > > Cc: Dave Hansen <dave.hansen@intel.com>
> > > Cc: Mel Gorman <mgorman@suse.de>
> > > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > 
> > Acked-by: Mel Gorman <mgorman@suse.de>
> 
> What to do with
> http://ozlabs.org/~akpm/mmots/broken-out/mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible-fix.patch?
> 
> We shouldn't need it any more.  otoh it's pretty harmless.  otooh it
> will hide bugs such as this one.
> 

Drop it.

-- 
Mel Gorman
SUSE Labs
