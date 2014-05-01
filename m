Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362AbaEAPLX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 11:11:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35699 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721AbaEAPLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 11:11:21 -0400
Date: Thu, 1 May 2014 16:11:16 +0100
From: Mel Gorman <mgorman@suse.de>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>,
        Jan Kara <jack@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 11/17] mm: page_alloc: Use unsigned int for order in more
 places
Message-ID: <20140501151116.GM23991@suse.de>
References: <1398933888-4940-1-git-send-email-mgorman@suse.de>
 <1398933888-4940-12-git-send-email-mgorman@suse.de>
 <53625BC3.3000804@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <53625BC3.3000804@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2014 at 07:35:47AM -0700, Dave Hansen wrote:
> On 05/01/2014 01:44 AM, Mel Gorman wrote:
> > X86 prefers the use of unsigned types for iterators and there is a
> > tendency to mix whether a signed or unsigned type if used for page
> > order. This converts a number of sites in mm/page_alloc.c to use
> > unsigned int for order where possible.
> 
> Does this actually generate any different code?  I'd actually expect
> something like 'order' to be one of the easiest things for the compiler
> to figure out an absolute range on.
> 

Yeah, it generates different code. Considering that this patch affects an
API that can be called external to the code block how would the compiler
know what the range of order would be in all cases?

-- 
Mel Gorman
SUSE Labs
