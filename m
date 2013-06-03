Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab3FCGN3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 02:13:29 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:54842 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab3FCGNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 02:13:22 -0400
X-AuditID: 9c93017e-b7c0cae0000006f6-7b-51ac34007ba6
Date: Mon, 3 Jun 2013 15:13:20 +0900
From: Minchan Kim <minchan@kernel.org>
To: Dave Hansen <dave@sr71.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mgorman@suse.de, tim.c.chen@linux.intel.com
Subject: Re: [v4][PATCH 2/6] mm: swap: make 'struct page' and swp_entry_t
 variants of swapcache_free().
Message-ID: <20130603061320.GA2795@blaptop>
References: <20130531183855.44DDF928@viggo.jf.intel.com>
 <20130531183858.3C8C10C7@viggo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130531183858.3C8C10C7@viggo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dave,

On Fri, May 31, 2013 at 11:38:58AM -0700, Dave Hansen wrote:
> 
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> swapcache_free() takes two arguments:
> 
> 	void swapcache_free(swp_entry_t entry, struct page *page)
> 
> Most of its callers (5/7) are from error handling paths haven't even
> instantiated a page, so they pass page=NULL.  Both of the callers
> that call in with a 'struct page' create and pass in a temporary
> swp_entry_t.
> 
> Now that we are deferring clearing page_private() until after
> swapcache_free() has been called, we can just create a variant
> that takes a 'struct page' and does the temporary variable in
> the helper.
> 
> That leaves all the other callers doing
> 
> 	swapcache_free(entry, NULL)
> 
> so create another helper for them that makes it clear that they
> need only pass in a swp_entry_t.
> 
> One downside here is that delete_from_swap_cache() now does
> an extra swap_address_space() call.  But, those are pretty
> cheap (just some array index arithmetic).

I lost from this description.

Old behavior

delete_from_swap_cache
        swap_address_space
        __delete_from_swap_cache
                swap_address_space


New behavior

delete_from_swap_cache
        __delete_from_swap_cache
                swap_address_space
                
So you removes a swap_address_space, not adding a extra call.
Am I missing something?

> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>

Otherwise, looks good to me
Reviewed-by: Minchan Kim <minchan@kernel.org>

-- 
Kind regards,
Minchan Kim
