Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877Ab3IZTGS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 15:06:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:6110 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753017Ab3IZTGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 15:06:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,987,1371106800"; 
   d="scan'208";a="384028523"
Date: Thu, 26 Sep 2013 12:05:56 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Zach Brown <zab@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
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
Message-ID: <20130926190556.GJ2018@tassilo.jf.intel.com>
References: <1379937950-8411-1-git-send-email-kirill.shutemov@linux.intel.com>
 <20130924163740.4bc7db61e3e520798220dc4c@linux-foundation.org>
 <20130924234950.GC2018@tassilo.jf.intel.com>
 <20130926183022.GN30372@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130926183022.GN30372@lenny.home.zabbo.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 11:30:22AM -0700, Zach Brown wrote:
> > > Sigh.  A pox on whoever thought up huge pages. 
> > 
> > managing 1TB+ of memory in 4K chunks is just insane.
> > The question of larger pages is not "if", but only "when".
> 
> And "how"!
> 
> Sprinking a bunch of magical if (thp) {} else {} throughtout the code
> looks like a stunningly bad idea to me.  It'd take real work to
> restructure the code such that the current paths are a degenerate case
> of the larger thp page case, but that's the work that needs doing in my
> estimation.

Sorry, but that is how all of large pages in the Linux VM works
(both THP and hugetlbfs) 

Yes it would be nice if small pages and large pages all ran
in a unified VM. But that's not how Linux is designed today.

Yes having a Pony would be nice too.

Back when huge pages were originally proposed Linus came
up with the "separate hugetlbfs VM" design and that is what were
stuck with today.

Asking for a whole scale VM redesign is just not realistic.

VM is always changing in baby steps. And the only 
known way to do that is to have if (thp) and if (hugetlbfs) .

-Andi 

-- 
ak@linux.intel.com -- Speaking for myself only
