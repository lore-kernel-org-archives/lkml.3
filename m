Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121Ab3I3QFh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 12:05:37 -0400
Received: from mga14.intel.com ([143.182.124.37]:2926 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755580Ab3I3QFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 12:05:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1008,1371106800"; 
   d="scan'208";a="403218741"
Date: Mon, 30 Sep 2013 09:05:34 -0700
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
Message-ID: <20130930160534.GB2125@tassilo.jf.intel.com>
References: <1379937950-8411-1-git-send-email-kirill.shutemov@linux.intel.com>
 <20130924163740.4bc7db61e3e520798220dc4c@linux-foundation.org>
 <20130924234950.GC2018@tassilo.jf.intel.com>
 <20130930101300.GD2425@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130930101300.GD2425@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 11:13:00AM +0100, Mel Gorman wrote:
> On Tue, Sep 24, 2013 at 04:49:50PM -0700, Andi Kleen wrote:
> > > Sigh.  A pox on whoever thought up huge pages. 
> > 
> > managing 1TB+ of memory in 4K chunks is just insane.
> > The question of larger pages is not "if", but only "when".
> > 
> 
> Remember that there are at least two separate issues there. One is the
> handling data in larger granularities than a 4K page and the second is
> the TLB, pagetable etc handling. They are not necessarily the same problem.

It's the same problem in the end.

The hardware is struggling with 4K pages too (both i and d)

I expect longer term TLB/page optimization to have far more important
than all this NUMA placement work that people spend so much
time on.


-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
