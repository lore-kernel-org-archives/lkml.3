Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498AbaDGVZn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 17:25:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35102 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753771AbaDGVZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 17:25:41 -0400
Date: Mon, 7 Apr 2014 22:25:35 +0100
From: Mel Gorman <mgorman@suse.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Steven Noonan <steven@uplinklabs.net>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Linux-MM <linux-mm@kvack.org>,
        Linux-X86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [PATCH 2/3] x86: Define _PAGE_NUMA with unused physical address
 bits PMD and PTE levels
Message-ID: <20140407212535.GJ7292@suse.de>
References: <1396883443-11696-1-git-send-email-mgorman@suse.de>
 <1396883443-11696-3-git-send-email-mgorman@suse.de>
 <5342C517.2020305@citrix.com>
 <20140407154935.GD7292@suse.de>
 <20140407161910.GJ1444@moon>
 <20140407182854.GH7292@suse.de>
 <5342FC0E.9080701@zytor.com>
 <20140407193646.GC23983@moon>
 <5342FFB0.6010501@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <5342FFB0.6010501@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 07, 2014 at 12:42:40PM -0700, H. Peter Anvin wrote:
> On 04/07/2014 12:36 PM, Cyrill Gorcunov wrote:
> > On Mon, Apr 07, 2014 at 12:27:10PM -0700, H. Peter Anvin wrote:
> >> On 04/07/2014 11:28 AM, Mel Gorman wrote:
> >>>
> >>> I had considered the soft-dirty tracking usage of the same bit. I thought I'd
> >>> be able to swizzle around it or a further worst case of having soft-dirty and
> >>> automatic NUMA balancing mutually exclusive. Unfortunately upon examination
> >>> it's not obvious how to have both of them share a bit and I suspect any
> >>> attempt to will break CRIU.  In my current tree, NUMA_BALANCING cannot be
> >>> set if MEM_SOFT_DIRTY which is not particularly satisfactory. Next on the
> >>> list is examining if _PAGE_BIT_IOMAP can be used.
> >>
> >> Didn't we smoke the last user of _PAGE_BIT_IOMAP?
> > 
> > Seems so, at least for non-kernel pages (not considering this bit references in
> > xen code, which i simply don't know but i guess it's used for kernel pages only).
> > 
> 
> David Vrabel has a patchset which I presumed would be pulled through the
> Xen tree this merge window:
> 
> [PATCHv5 0/8] x86/xen: fixes for mapping high MMIO regions (and remove
> _PAGE_IOMAP)
> 
> That frees up this bit.
> 

Thanks, I was not aware of that patch.  Based on it, I intend to force
automatic NUMA balancing to depend on !XEN and see what the reaction is. If
support for Xen is really required then it potentially be re-enabled if/when
that series is merged assuming they do not need the bit for something else.

-- 
Mel Gorman
SUSE Labs
