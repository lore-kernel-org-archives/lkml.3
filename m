Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050Ab3I3Sv1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 14:51:27 -0400
Received: from mga03.intel.com ([143.182.124.21]:27466 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755525Ab3I3Sv0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 14:51:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1009,1371106800"; 
   d="scan'208";a="367868807"
Date: Mon, 30 Sep 2013 11:51:06 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        linux-mm@kvack.org, Matthew Wilcox <willy@linux.intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, Dave Hansen <dave@sr71.net>,
        Ning Qu <quning@google.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv6 00/22] Transparent huge page cache: phase 1, everything
 but mmap()
Message-ID: <20130930185106.GD2125@tassilo.jf.intel.com>
References: <1379937950-8411-1-git-send-email-kirill.shutemov@linux.intel.com>
 <20130924163740.4bc7db61e3e520798220dc4c@linux-foundation.org>
 <20130930100249.GB2425@suse.de>
 <20130930101029.GC2425@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130930101029.GC2425@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> AFAIK, this is not a problem in the vast majority of modern CPUs

Let's do some simple math: e.g. a Sandy Bridge system has 512 4K iTLB L2 entries.
That's around 2MB. There's more and more code whose footprint exceeds
that.

Besides iTLB is not the only target. It is also useful for 
data of course.

> > and I found it very hard to be motivated to review the series as a result.
> > I suspected that in many cases that the cost of IO would continue to dominate
> > performance instead of TLB pressure

The trend is to larger and larger memories, keeping things in memory.

In fact there's a good argument that memory sizes are growing faster
than TLB capacities. And without large TLBs we're even further off
the curve.

> Oh, one last thing I forgot. While tmpfs-based workloads were not likely to
> benefit I would expect that sysV shared memory workloads would potentially
> benefit from this.  hugetlbfs is still required for shared memory areas
> but it is not a problem that is addressed by this series.

Of course it's only the first step. But if noone does the babysteps
then the other usages will also not ever materialize.

I expect once ramfs works, extending it to tmpfs etc. should be
straight forward.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
