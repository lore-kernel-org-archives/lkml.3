Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897AbaJOJOQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 05:14:16 -0400
Received: from mta-out1.inet.fi ([62.71.2.226]:46274 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbaJOJOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 05:14:14 -0400
Date: Wed, 15 Oct 2014 12:13:41 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Yu Zhao <yuzhao@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Hugh Dickins <hughd@google.com>,
        Sasha Levin <sasha.levin@oracle.com>, Bob Liu <lliubbo@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        David Rientjes <rientjes@google.com>, Vlastimil Babka <vbabka@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: free compound page with correct order
Message-ID: <20141015091341.GB12538@node.dhcp.inet.fi>
References: <1413317800-25450-1-git-send-email-yuzhao@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413317800-25450-1-git-send-email-yuzhao@google.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 01:16:39PM -0700, Yu Zhao wrote:
> Compound page should be freed by put_page() or free_pages() with
> correct order. Not doing so with causing the tail pages leaked.
> 
> The compound order can be obtained by compound_order() or use
> HPAGE_PMD_ORDER in our case. Some people would argue the latter
> is faster but I prefer the former which is more general.
> 
> Signed-off-by: Yu Zhao <yuzhao@google.com>

Urghh.. Sorry about that.

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Fixes: 97ae17497e99 ("thp: implement refcounting for huge zero page")
Cc: stable@vger.kernel.org # v3.8+

-- 
 Kirill A. Shutemov
