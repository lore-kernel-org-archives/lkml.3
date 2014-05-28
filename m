Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbaE1XRQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 19:17:16 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:50337 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751217AbaE1XRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 19:17:15 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArhPAMlthlN5LL1sPGdsb2JhbABagweDRIUIom0BAQEBAQEGmB0BgRAXAwEBAQE4NYIlAQEFOhwjEAgDGAklDwUlAwcaE4hB2BsXFoU/iH0HgyuBFQSZdIsYi1or
Date: Thu, 29 May 2014 09:17:08 +1000
From: Dave Chinner <david@fromorbit.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Minchan Kim <minchan@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, rusty@rustcorp.com.au, mst@redhat.com,
        Dave Hansen <dave.hansen@intel.com>
Subject: Re: [RFC 2/2] x86_64: expand kernel stack to 16K
Message-ID: <20140528231708.GE6677@dastard>
References: <1401260039-18189-1-git-send-email-minchan@kernel.org>
 <1401260039-18189-2-git-send-email-minchan@kernel.org>
 <20140528101401.43853563@gandalf.local.home>
 <f00f9b56-704d-4d03-ad0e-ec3ba2d122fd@email.android.com>
 <20140528221118.GN8554@dastard>
 <5386664A.5060304@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5386664A.5060304@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 03:42:18PM -0700, H. Peter Anvin wrote:
> On 05/28/2014 03:11 PM, Dave Chinner wrote:
> > On Wed, May 28, 2014 at 07:23:23AM -0700, H. Peter Anvin wrote:
> >> We tried for 4K on x86-64, too, for b quite a while as I recall.
> >> The kernel stack is a one of the main costs for a thread.  I would
> >> like to decouple struct thread_info from the kernel stack (PJ
> >> Waskewicz was working on that before he left Intel) but that
> >> doesn't buy us all that much.
> >>
> >> 8K additional per thread is a huge hit.  XFS has indeed always
> >> been a canary, or troublespot, I suspect because it originally
> >> came from another kernel where this was not an optimization
> >> target.
> > 
> > <sigh>
> > 
> > Always blame XFS for stack usage problems.
> > 
> > Even when the reported problem is from IO to an ext4 filesystem.
> > 
> 
> You were the one calling it a canary.

That doesn't mean it's to blame. Don't shoot the messenger...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
