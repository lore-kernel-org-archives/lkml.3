Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932438AbaJNOzI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 10:55:08 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:43752 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932147AbaJNOzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 10:55:07 -0400
Date: Tue, 14 Oct 2014 16:54:35 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Alex Thorlton <athorlton@sgi.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Hugh Dickins <hughd@google.com>, Bob Liu <lliubbo@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org
Subject: Re: [BUG] mm, thp: khugepaged can't allocate on requested node when
 confined to a cpuset
Message-ID: <20141014145435.GA7369@worktop.fdxtended.com>
References: <20141008191050.GK3778@sgi.com>
 <20141014114828.GA6524@node.dhcp.inet.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141014114828.GA6524@node.dhcp.inet.fi>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 02:48:28PM +0300, Kirill A. Shutemov wrote:

> Why whould you want to pin khugpeaged? Is there a valid use-case?
> Looks like userspace shoots to its leg.

Its just bad design to put so much work in another context. But the
use-case is isolating other cpus.

> Is there a reason why we should respect cpuset limitation for kernel
> threads?

Yes, because we want to allow isolating CPUs from 'random' activity.

> Should we bypass cpuset for PF_KTHREAD completely?

No. That'll break stuff.
