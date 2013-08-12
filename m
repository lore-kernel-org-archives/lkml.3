Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752Ab3HLNvz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 09:51:55 -0400
Received: from mga14.intel.com ([143.182.124.37]:21071 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756629Ab3HLNvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 09:51:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,862,1367996400"; 
   d="scan'208";a="345124250"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Ning Qu <quning@gmail.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        linux-fsdevel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mgorman@suse.de>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, Wu Fengguang <fengguang.wu@intel.com>,
        Jan Kara <jack@suse.cz>, Dave Hansen <dave@sr71.net>,
        linux-mm@kvack.org, Hillf Danton <dhillf@gmail.com>,
        Ning Qu <quning@google.com>
In-Reply-To: <93894D4C-57FA-46B5-9141-4EFADEB7009E@gmail.com>
References: <93894D4C-57FA-46B5-9141-4EFADEB7009E@gmail.com>
Subject: RE: [PATCH] thp: Fix deadlock situation in vma_adjust with huge page
 in page cache
Content-Transfer-Encoding: 7bit
Message-Id: <20130812135509.DDF5FE0090@blue.fi.intel.com>
Date: Mon, 12 Aug 2013 16:55:09 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ning Qu wrote:
> In vma_adjust, the current code grabs i_mmap_mutex before calling
> vma_adjust_trans_huge. This used to be fine until huge page in page
> cache comes in. The problem is the underlying function
> split_file_huge_page will also grab the i_mmap_mutex before splitting
> the huge page in page cache. Obviously this is causing deadlock
> situation.
> 
> This fix is to move the vma_adjust_trans_huge before grab the lock for
> file, the same as what the function is currently doing for anonymous
> memory.
> 
> Tested, everything works fine so far.
> 
> Signed-off-by: Ning Qu <quning@google.com>

Thanks, applied.

-- 
 Kirill A. Shutemov
