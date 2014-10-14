Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344AbaJNRj0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 13:39:26 -0400
Received: from mta-out1.inet.fi ([62.71.2.197]:49811 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580AbaJNRjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 13:39:25 -0400
Date: Tue, 14 Oct 2014 20:38:37 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alex Thorlton <athorlton@sgi.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Hugh Dickins <hughd@google.com>, Bob Liu <lliubbo@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org
Subject: Re: [BUG] mm, thp: khugepaged can't allocate on requested node when
 confined to a cpuset
Message-ID: <20141014173837.GA8919@node.dhcp.inet.fi>
References: <20141008191050.GK3778@sgi.com>
 <20141014114828.GA6524@node.dhcp.inet.fi>
 <20141014145435.GA7369@worktop.fdxtended.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141014145435.GA7369@worktop.fdxtended.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 04:54:35PM +0200, Peter Zijlstra wrote:
> > Is there a reason why we should respect cpuset limitation for kernel
> > threads?
> 
> Yes, because we want to allow isolating CPUs from 'random' activity.

Okay, it makes sense for cpus_allowed. But we're talking about
mems_allowed, right?
 
> 
> > Should we bypass cpuset for PF_KTHREAD completely?
> 
> No. That'll break stuff.

Like what?

-- 
 Kirill A. Shutemov
