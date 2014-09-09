Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857AbaIIVdP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 17:33:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56867 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbaIIVdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 17:33:14 -0400
Date: Tue, 9 Sep 2014 22:33:09 +0100
From: Mel Gorman <mgorman@suse.de>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Hugh Dickins <hughd@google.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: mm: BUG in unmap_page_range
Message-ID: <20140909213309.GQ17501@suse.de>
References: <20140805144439.GW10819@suse.de>
 <alpine.LSU.2.11.1408051649330.6591@eggly.anvils>
 <53E17F06.30401@oracle.com>
 <53E989FB.5000904@oracle.com>
 <53FD4D9F.6050500@oracle.com>
 <20140827152622.GC12424@suse.de>
 <540127AC.4040804@oracle.com>
 <54082B25.9090600@oracle.com>
 <20140908171853.GN17501@suse.de>
 <540DEDE7.4020300@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <540DEDE7.4020300@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 01:56:55PM -0400, Sasha Levin wrote:
> On 09/08/2014 01:18 PM, Mel Gorman wrote:
> > A worse possibility is that somehow the lock is getting corrupted but
> > that's also a tough sell considering that the locks should be allocated
> > from a dedicated cache. I guess I could try breaking that to allocate
> > one page per lock so DEBUG_PAGEALLOC triggers but I'm not very
> > optimistic.
> 
> I did see ptl corruption couple days ago:
> 
> 	https://lkml.org/lkml/2014/9/4/599
> 
> Could this be related?
> 

Possibly although the likely explanation then would be that there is
just general corruption coming from somewhere. Even using your config
and applying a patch to make linux-next boot (already in Tejun's tree)
I was unable to reproduce the problem after running for several hours. I
had to run trinity on tmpfs as ext4 and xfs blew up almost immediately
so I have a few questions.

1. What filesystem are you using?

2. What compiler in case it's an experimental compiler? I ask because I
   think I saw a patch from you adding support so that the kernel would
   build with gcc 5

3. Does your hardware support TSX or anything similarly funky that would
   potentially affect locking?

4. How many sockets are on your test machine in case reproducing it
   depends in a machine large enough to open a timing race?

As I'm drawing a blank on what would trigger the bug I'm hoping I can
reproduce this locally and experiement a bit.

Thanks.

-- 
Mel Gorman
SUSE Labs
