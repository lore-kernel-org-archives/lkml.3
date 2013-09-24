Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821Ab3IXXty (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 19:49:54 -0400
Received: from mga03.intel.com ([143.182.124.21]:43246 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754169Ab3IXXtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 19:49:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,974,1371106800"; 
   d="scan'208";a="298969846"
Date: Tue, 24 Sep 2013 16:49:50 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Matthew Wilcox <willy@linux.intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, Dave Hansen <dave@sr71.net>,
        Ning Qu <quning@google.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv6 00/22] Transparent huge page cache: phase 1, everything
 but mmap()
Message-ID: <20130924234950.GC2018@tassilo.jf.intel.com>
References: <1379937950-8411-1-git-send-email-kirill.shutemov@linux.intel.com>
 <20130924163740.4bc7db61e3e520798220dc4c@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130924163740.4bc7db61e3e520798220dc4c@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 24, 2013 at 04:37:40PM -0700, Andrew Morton wrote:
> On Mon, 23 Sep 2013 15:05:28 +0300 "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com> wrote:
> 
> > It brings thp support for ramfs, but without mmap() -- it will be posted
> > separately.
> 
> We were never going to do this :(
> 
> Has anyone reviewed these patches much yet?

There already was a lot of review by various people.

This is not the first post, just the latest refactoring.

> > Intro
> > -----
> > 
> > The goal of the project is preparing kernel infrastructure to handle huge
> > pages in page cache.
> > 
> > To proof that the proposed changes are functional we enable the feature
> > for the most simple file system -- ramfs. ramfs is not that useful by
> > itself, but it's good pilot project.
> 
> At the very least we should get this done for a real filesystem to see
> how intrusive the changes are and to evaluate the performance changes.

That would give even larger patches, and people already complain
the patchkit is too large.

The only good way to handle this is baby steps, and you 
have to start somewhere.

> Sigh.  A pox on whoever thought up huge pages. 

managing 1TB+ of memory in 4K chunks is just insane.
The question of larger pages is not "if", but only "when".

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
