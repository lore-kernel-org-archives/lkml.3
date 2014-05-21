Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698AbaEUWLr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 18:11:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49982 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376AbaEUWLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 18:11:45 -0400
Date: Wed, 21 May 2014 15:11:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mgorman@suse.de>
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
Message-Id: <20140521151142.9d084dd64251bce4c44c214d@linux-foundation.org>
In-Reply-To: <20140521120916.GS23991@suse.de>
References: <1399974350-11089-1-git-send-email-mgorman@suse.de>
	<1399974350-11089-19-git-send-email-mgorman@suse.de>
	<20140520154900.GO23991@suse.de>
	<20140520123453.09a76dd0c8fad40082a16289@linux-foundation.org>
	<20140521120916.GS23991@suse.de>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2014 13:09:16 +0100 Mel Gorman <mgorman@suse.de> wrote:

> > From: Andrew Morton <akpm@linux-foundation.org>
> > Subject: mm/shmem.c: don't run init_page_accessed() against an uninitialised pointer
> > 
> > If shmem_getpage() returned an error then it didn't necessarily initialise
> > *pagep.  So shmem_write_begin() shouldn't be playing with *pagep in this
> > situation.
> > 
> > Fixes an oops when "mm: non-atomically mark page accessed during page
> > cache allocation where possible" (quite reasonably) left *pagep
> > uninitialized.
> > 
> > Reported-by: Prabhakar Lad <prabhakar.csengg@gmail.com>
> > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > Cc: Vlastimil Babka <vbabka@suse.cz>
> > Cc: Jan Kara <jack@suse.cz>
> > Cc: Michal Hocko <mhocko@suse.cz>
> > Cc: Hugh Dickins <hughd@google.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Dave Hansen <dave.hansen@intel.com>
> > Cc: Mel Gorman <mgorman@suse.de>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 
> Acked-by: Mel Gorman <mgorman@suse.de>

What to do with
http://ozlabs.org/~akpm/mmots/broken-out/mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible-fix.patch?

We shouldn't need it any more.  otoh it's pretty harmless.  otooh it
will hide bugs such as this one.

