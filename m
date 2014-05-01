Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306AbaEAOft (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 10:35:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:55333 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755224AbaEAOfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 10:35:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,965,1389772800"; 
   d="scan'208";a="504321188"
Message-ID: <53625BC3.3000804@intel.com>
Date: Thu, 01 May 2014 07:35:47 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>, Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>
CC: Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>,
        Jan Kara <jack@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 11/17] mm: page_alloc: Use unsigned int for order in more
 places
References: <1398933888-4940-1-git-send-email-mgorman@suse.de> <1398933888-4940-12-git-send-email-mgorman@suse.de>
In-Reply-To: <1398933888-4940-12-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2014 01:44 AM, Mel Gorman wrote:
> X86 prefers the use of unsigned types for iterators and there is a
> tendency to mix whether a signed or unsigned type if used for page
> order. This converts a number of sites in mm/page_alloc.c to use
> unsigned int for order where possible.

Does this actually generate any different code?  I'd actually expect
something like 'order' to be one of the easiest things for the compiler
to figure out an absolute range on.

