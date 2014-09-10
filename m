Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbaIJTLc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 15:11:32 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:48979 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbaIJTLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 15:11:31 -0400
Date: Wed, 10 Sep 2014 12:09:40 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Sasha Levin <sasha.levin@oracle.com>
cc: Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: mm: BUG in unmap_page_range
In-Reply-To: <54104E24.5010402@oracle.com>
Message-ID: <alpine.LSU.2.11.1409101148290.1262@eggly.anvils>
References: <20140805144439.GW10819@suse.de> <alpine.LSU.2.11.1408051649330.6591@eggly.anvils> <53E17F06.30401@oracle.com> <53E989FB.5000904@oracle.com> <53FD4D9F.6050500@oracle.com> <20140827152622.GC12424@suse.de> <540127AC.4040804@oracle.com>
 <54082B25.9090600@oracle.com> <20140908171853.GN17501@suse.de> <540DEDE7.4020300@oracle.com> <20140909213309.GQ17501@suse.de> <540F7D42.1020402@oracle.com> <alpine.LSU.2.11.1409091903390.10989@eggly.anvils> <54104E24.5010402@oracle.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Sep 2014, Sasha Levin wrote:
> On 09/09/2014 10:45 PM, Hugh Dickins wrote:
> > Sasha, you say you're getting plenty of these now, but I've only seen
> > the dump for one of them, on Aug26: please post a few more dumps, so
> > that we can look for commonality.
> 
> I wasn't saving older logs for this issue so I only have 2 traces from
> tonight. If that's not enough please let me know and I'll try to add
> a few more.

Thanks, these two are useful, mainly because the register contents most
likely to be ptes are in both of these ...900, with no sign of a ...902.

So the RW bit I got excited about yesterday is clearly not necessary for
the bug (though it's still possible that it was good for implicating page
migration, and page migration still play a part in the story).

> > And please attach a disassembly of change_protection_range() (noting
> > which of the dumps it corresponds to, in case it has changed around):
> > "Code" just shows a cluster of ud2s for the unlikely bugs at end of the
> > function, we cannot tell at all what should be in the registers by then.
> 
> change_protection_range() got inlined into change_protection(), it applies to
> both traces above:

Thanks for supplying, but the change in inlining means that
change_protection_range() and change_protection() are no longer
relevant for these traces, we now need to see change_pte_range()
instead, to confirm that what I expect are ptes are indeed ptes.

If you can include line numbers (objdump -ld) in the disassembly, so
much the better, but should be decipherable without.  (Or objdump -Sd
for source, but I often find that harder to unscramble, can't say why.)

Thanks,
Hugh
