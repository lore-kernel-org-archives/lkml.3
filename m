Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152Ab3HVLLx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 07:11:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:42301 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654Ab3HVLLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 07:11:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,933,1367996400"; 
   d="scan'208";a="384867328"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: David Rientjes <rientjes@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <alpine.DEB.2.02.1308211516290.6225@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1308201716510.25665@chino.kir.corp.google.com>
 <20130821142817.8EB4BE0090@blue.fi.intel.com>
 <alpine.DEB.2.02.1308211516290.6225@chino.kir.corp.google.com>
Subject: RE: [patch] mm, thp: count thp_fault_fallback anytime thp fault fails
Content-Transfer-Encoding: 7bit
Message-Id: <20130822111148.B931AE0090@blue.fi.intel.com>
Date: Thu, 22 Aug 2013 14:11:48 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:
> On Wed, 21 Aug 2013, Kirill A. Shutemov wrote:
> 
> > David Rientjes wrote:
> > > Currently, thp_fault_fallback in vmstat only gets incremented if a
> > > hugepage allocation fails.  If current's memcg hits its limit or the page
> > > fault handler returns an error, it is incorrectly accounted as a
> > > successful thp_fault_alloc.
> > > 
> > > Count thp_fault_fallback anytime the page fault handler falls back to
> > > using regular pages and only count thp_fault_alloc when a hugepage has
> > > actually been faulted.
> > > 
> > > Signed-off-by: David Rientjes <rientjes@google.com>
> > 
> > It's probably a good idea, but please make the behaviour consistent in
> > do_huge_pmd_wp_page() and collapse path, otherwise it doesn't make sense.
> > 
> 
> The collapse path has no fallback, the allocation either succeeds or it 
> fails.

THP_COLLAPSE_ALLOC should be counted after successful memcg charge or even
only after successful collapse.

-- 
 Kirill A. Shutemov
