Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718AbaDGTQ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 15:16:26 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:45544 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755610AbaDGTQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 15:16:25 -0400
Date: Mon, 7 Apr 2014 23:16:22 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: David Vrabel <david.vrabel@citrix.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Anvin <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Steven Noonan <steven@uplinklabs.net>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Linux-MM <linux-mm@kvack.org>,
        Linux-X86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [PATCH 2/3] x86: Define _PAGE_NUMA with unused physical address
 bits PMD and PTE levels
Message-ID: <20140407191622.GA23983@moon>
References: <1396883443-11696-1-git-send-email-mgorman@suse.de>
 <1396883443-11696-3-git-send-email-mgorman@suse.de>
 <5342C517.2020305@citrix.com>
 <20140407154935.GD7292@suse.de>
 <20140407161910.GJ1444@moon>
 <20140407182854.GH7292@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140407182854.GH7292@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 07, 2014 at 07:28:54PM +0100, Mel Gorman wrote:
> > > I didn't bother spelling it out in case I gave the impression that I was
> > > blaming Xen for the problem.  As the bit is now changes, does it help
> > > the Xen problem or cause another collision of some sort? There is no
> > > guarantee _PAGE_NUMA will remain as bit 62 but at worst it'll use bit 11
> > > and NUMA_BALANCING will depend in !KMEMCHECK.
> > 
> > Fwiw, we're using bit 11 for soft-dirty tracking, so i really hope worst case
> > never happen. (At the moment I'm trying to figure out if with this set
> > it would be possible to clean up ugly macros in pgoff_to_pte for 2 level pages).
> 
> I had considered the soft-dirty tracking usage of the same bit. I thought I'd
> be able to swizzle around it or a further worst case of having soft-dirty and
> automatic NUMA balancing mutually exclusive. Unfortunately upon examination
> it's not obvious how to have both of them share a bit and I suspect any
> attempt to will break CRIU.  In my current tree, NUMA_BALANCING cannot be
> set if MEM_SOFT_DIRTY which is not particularly satisfactory. Next on the
> list is examining if _PAGE_BIT_IOMAP can be used.

Thanks for info, Mel! It seems indeed if no more space left on x86-64 (in
the very worst case which I still think won't happen anytime soon) we'll
have to make them mut. exclusive. But for now (with 62 bit used for numa)
they can live together, right?
