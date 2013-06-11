Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175Ab3FKQYb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 12:24:31 -0400
Received: from mga03.intel.com ([143.182.124.21]:5513 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754178Ab3FKQY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 12:24:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,846,1363158000"; 
   d="scan'208";a="315413430"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Dave Hansen <dave@sr71.net>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <51B74A7A.1040707@sr71.net>
References: <1370964919-16187-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1370964919-16187-3-git-send-email-kirill.shutemov@linux.intel.com>
 <51B74A7A.1040707@sr71.net>
Subject: Re: [PATCH 2/8] thp, mm: avoid PageUnevictable on active/inactive lru
 lists
Content-Transfer-Encoding: 7bit
Message-Id: <20130611162707.53DCBE0090@blue.fi.intel.com>
Date: Tue, 11 Jun 2013 19:27:07 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> On 06/11/2013 08:35 AM, Kirill A. Shutemov wrote:
> > active/inactive lru lists can contain unevicable pages (i.e. ramfs pages
> > that have been placed on the LRU lists when first allocated), but these
> > pages must not have PageUnevictable set - otherwise shrink_[in]active_list
> > goes crazy:
> 
> I think it's also important here to note if this is a bug that can be
> hit _currently_, or if this really is just a preparatory patch for
> transparent huge page cache.

I've mentioned in cover letter, that don't think the bug can be triggered on
current upstream code.

> From what I can see, this is _needed_ preparatory work, but it can also
> stand on its own because it simplifies things.  It should go in sooner
> rather than later.

Right.

-- 
 Kirill A. Shutemov
