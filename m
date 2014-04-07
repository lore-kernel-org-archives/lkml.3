Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbaDGQTR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 12:19:17 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:61986 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057AbaDGQTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 12:19:12 -0400
Date: Mon, 7 Apr 2014 20:19:10 +0400
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
Message-ID: <20140407161910.GJ1444@moon>
References: <1396883443-11696-1-git-send-email-mgorman@suse.de>
 <1396883443-11696-3-git-send-email-mgorman@suse.de>
 <5342C517.2020305@citrix.com>
 <20140407154935.GD7292@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140407154935.GD7292@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 07, 2014 at 04:49:35PM +0100, Mel Gorman wrote:
> On Mon, Apr 07, 2014 at 04:32:39PM +0100, David Vrabel wrote:
> > On 07/04/14 16:10, Mel Gorman wrote:
> > > _PAGE_NUMA is currently an alias of _PROT_PROTNONE to trap NUMA hinting
> > > faults. As the bit is shared care is taken that _PAGE_NUMA is only used in
> > > places where _PAGE_PROTNONE could not reach but this still causes problems
> > > on Xen and conceptually difficult.
> > 
> > The problem with Xen guests occurred because mprotect() /was/ confusing
> > PROTNONE mappings with _PAGE_NUMA and clearing the non-existant NUMA hints.
> 
> I didn't bother spelling it out in case I gave the impression that I was
> blaming Xen for the problem.  As the bit is now changes, does it help
> the Xen problem or cause another collision of some sort? There is no
> guarantee _PAGE_NUMA will remain as bit 62 but at worst it'll use bit 11
> and NUMA_BALANCING will depend in !KMEMCHECK.

Fwiw, we're using bit 11 for soft-dirty tracking, so i really hope worst case
never happen. (At the moment I'm trying to figure out if with this set
it would be possible to clean up ugly macros in pgoff_to_pte for 2 level pages).
