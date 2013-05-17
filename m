Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893Ab3EQN1V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 09:27:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34240 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752177Ab3EQN1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 09:27:20 -0400
Date: Fri, 17 May 2013 14:27:11 +0100
From: Mel Gorman <mgorman@suse.de>
To: Dave Hansen <dave@sr71.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, tim.c.chen@linux.intel.com
Subject: Re: [RFCv2][PATCH 2/5] make 'struct page' and swp_entry_t variants
 of swapcache_free().
Message-ID: <20130517132711.GL11497@suse.de>
References: <20130516203427.E3386936@viggo.jf.intel.com>
 <20130516203429.5293EA57@viggo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20130516203429.5293EA57@viggo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 16, 2013 at 01:34:29PM -0700, Dave Hansen wrote:
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
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
