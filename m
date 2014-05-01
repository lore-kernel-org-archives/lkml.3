Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354AbaEAPi0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 11:38:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:32031 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839AbaEAPiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 11:38:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,965,1389772800"; 
   d="scan'208";a="504372157"
Message-ID: <53626A70.2010709@intel.com>
Date: Thu, 01 May 2014 08:38:24 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>,
        Jan Kara <jack@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 11/17] mm: page_alloc: Use unsigned int for order in more
 places
References: <1398933888-4940-1-git-send-email-mgorman@suse.de> <1398933888-4940-12-git-send-email-mgorman@suse.de> <53625BC3.3000804@intel.com> <20140501151116.GM23991@suse.de>
In-Reply-To: <20140501151116.GM23991@suse.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2014 08:11 AM, Mel Gorman wrote:
> On Thu, May 01, 2014 at 07:35:47AM -0700, Dave Hansen wrote:
>> On 05/01/2014 01:44 AM, Mel Gorman wrote:
>>> X86 prefers the use of unsigned types for iterators and there is a
>>> tendency to mix whether a signed or unsigned type if used for page
>>> order. This converts a number of sites in mm/page_alloc.c to use
>>> unsigned int for order where possible.
>>
>> Does this actually generate any different code?  I'd actually expect
>> something like 'order' to be one of the easiest things for the compiler
>> to figure out an absolute range on.
> 
> Yeah, it generates different code. Considering that this patch affects an
> API that can be called external to the code block how would the compiler
> know what the range of order would be in all cases?

The compiler comprehends that if you do a check against a constant like
MAX_ORDER early in the function that the the variable now has a limited
range, like the check we do first-thing in __alloc_pages_slowpath().

The more I think about it, at least in page_alloc.c, I don't see any
checks for order<0, which means the compiler isn't free to do this
anyway.  Your move over to an unsigned type gives that check for free
essentially.

So this makes a lot of sense in any case.  I was just curious if it
affected the code.
