Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285AbaJUK7m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 06:59:42 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:37208 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754948AbaJUK7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 06:59:41 -0400
Date: Tue, 21 Oct 2014 12:59:34 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Alex Thorlton <athorlton@sgi.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Hugh Dickins <hughd@google.com>, Bob Liu <lliubbo@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org
Subject: Re: [BUG] mm, thp: khugepaged can't allocate on requested node when
 confined to a cpuset
Message-ID: <20141021105934.GV23531@worktop.programming.kicks-ass.net>
References: <20141008191050.GK3778@sgi.com>
 <20141010092052.GU4750@worktop.programming.kicks-ass.net>
 <20141010185620.GA3745@sgi.com>
 <54385635.5020709@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54385635.5020709@suse.cz>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2014 at 11:57:09PM +0200, Vlastimil Babka wrote:
> Hm I haven't seen the code yet, but is perhaps the NUMA scanning working
> similarly enough that a single scanner could handle both the NUMA and THP
> bits to save time?

IIRC the THP thing doesn't need the fault thing, which makes it an
entirely different beast. Then again, we do walk the actual page-tables
through change_protection, but changing that means we have to duplicate
all that code, then again, maybe the current THP stuff already carries
something like that.


