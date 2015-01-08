Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782AbbAHBE3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 20:04:29 -0500
Received: from peace.netnation.com ([204.174.223.2]:54817 "EHLO
	peace.netnation.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbbAHBE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 20:04:27 -0500
Date: Wed, 7 Jan 2015 17:04:26 -0800
From: Simon Kirby <sim@hostway.ca>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Holger Hoffst?tte <holger.hoffstaette@googlemail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: Dirty pages underflow on 3.14.23
Message-ID: <20150108010426.GB6664@hostway.ca>
References: <alpine.LRH.2.02.1501051744020.5119@file01.intranet.prod.int.rdu2.redhat.com>
 <20150106150250.GA26895@phnom.home.cmpxchg.org>
 <alpine.LRH.2.02.1501061246400.16437@file01.intranet.prod.int.rdu2.redhat.com>
 <pan.2015.01.07.10.57.46@googlemail.com>
 <20150107212858.GA6664@hostway.ca>
 <54ADA99A.90501@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54ADA99A.90501@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2015 at 10:48:10PM +0100, Vlastimil Babka wrote:

> On 01/07/2015 10:28 PM, Simon Kirby wrote:
>
> > Hmm...A possibly-related issue...Before trying this, after a fresh boot,
> > /proc/vmstat showed:
> > 
> > nr_alloc_batch 4294541205
> 
> This can happen, and not be a problem in general. However, there was a fix
> abe5f972912d086c080be4bde67750630b6fb38b in 3.17 for a potential performance
> issue if this counter overflows on single processor configuration. It was marked
> stable, but the 3.16 series was discontinued before the fix could be backported.
> So if you are on single-core, you might hit the performance issue.

That particular commit seems to just change the code path in that case,
but should it be underflowing at all on UP?

> > Still, nr_alloc_batch reads as 4294254379 after MySQL restart, and now
> > seems to stay up there.
> 
> Hm if it stays there, then you are probably hitting the performance issue. Look
> at /proc/zoneinfo, which zone has the underflow. It means this zone will get
> unfair amount of allocations, while others may contain stale data and would be
> better candidates.

In this case, it has only 640MB, and there's only DMA and Normal. This is
affecting Normal, and DMA is so small that it probably doesn't matter.

Simon-
