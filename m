Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758240AbaGWXUH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 19:20:07 -0400
Received: from relay3.sgi.com ([192.48.152.1]:56359 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751532AbaGWXUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 19:20:05 -0400
Date: Wed, 23 Jul 2014 18:20:38 -0500
From: Alex Thorlton <athorlton@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: Alex Thorlton <athorlton@sgi.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, kirill.shutemov@linux.intel.com,
        Ingo Molnar <mingo@kernel.org>, Hugh Dickins <hughd@google.com>,
        lliubbo@gmail.com, Johannes Weiner <hannes@cmpxchg.org>,
        srivatsa.bhat@linux.vnet.ibm.com,
        Dave Hansen <dave.hansen@linux.intel.com>, dfults@sgi.com,
        hedi@sgi.com
Subject: Re: [patch] mm, thp: do not allow thp faults to avoid cpuset
 restrictions
Message-ID: <20140723232038.GV8578@sgi.com>
References: <20140723220538.GT8578@sgi.com>
 <alpine.DEB.2.02.1407231516570.23495@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1407231545520.1389@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1407231545520.1389@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 03:50:09PM -0700, David Rientjes wrote:
> The page allocator relies on __GFP_WAIT to determine if ALLOC_CPUSET 
> should be set in allocflags.  ALLOC_CPUSET controls if a page allocation 
> should be restricted only to the set of allowed cpuset mems.
> 
> Transparent hugepages clears __GFP_WAIT when defrag is disabled to prevent 
> the fault path from using memory compaction or direct reclaim.  Thus, it 
> is unfairly able to allocate outside of its cpuset mems restriction as a 
> side-effect.
> 
> This patch ensures that ALLOC_CPUSET is only cleared when the gfp mask is 
> truly GFP_ATOMIC by verifying it is also not a thp allocation.

Tested.  Works as expected.

Tested-by: Alex Thorlton <athorlton@sgi.com>
