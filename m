Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630Ab3HUVQz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 17:16:55 -0400
Received: from mail-qe0-f49.google.com ([209.85.128.49]:44429 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969Ab3HUVQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 17:16:54 -0400
Date: Wed, 21 Aug 2013 17:16:50 -0400
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <kmo@daterainc.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Christoph Lameter <cl@gentwo.org>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] idr: Use this_cpu_ptr() for percpu_ida
Message-ID: <20130821211650.GD2436@htj.dyndns.org>
References: <000001405a4b39ef-0715410a-5061-41e9-9414-86559f16570d-000000@email.amazonses.com>
 <20130807195733.GB11612@kmo-pixel>
 <000001405e5776ba-bcc96088-b5e8-4abe-b98e-2e9d7d9b112b-000000@email.amazonses.com>
 <1377033546.32763.4.camel@haakon3.risingtidesystems.com>
 <20130820142956.1194d8c798abf53f884a1fb6@linux-foundation.org>
 <20130821020132.GA4051@kmo-pixel>
 <20130821020742.GA3495@htj.dyndns.org>
 <20130821023151.GC4051@kmo-pixel>
 <20130821115941.GA18617@mtj.dyndns.org>
 <20130821210901.GA4657@kmo-pixel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130821210901.GA4657@kmo-pixel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Kent.

On Wed, Aug 21, 2013 at 02:09:01PM -0700, Kent Overstreet wrote:
> These "micro optimizations" mean either less pointer chasing or less
> branching in the _common_ case; you'd trade common case performance for
> avoiding ever doing higher order allocations (and 2 with COMPACTION=n
> and 4 with COMPACTION=y is not particularly high order!).

Order 4 allocation probably isn't as bad as before but it still is a
lot nastier than single page allocations.  You say doing it the other
way would harm the common case performance but didn't answer my
question about the number of IDs being served per page.  How many can
be served from a single page?  And how many from two layer single page
configuration?  How are you defining the "common" case?

> I don't buy that that's a good tradeoff. If you're convinced radix trees
> are the way to go and it can be done without much performance cost, why
> not code it up and show us?

Well, I'm not the one trying to rewrite ida, so the onus to justify
the proposed code is primarily on you.  Another thing is that the
proposed code is *not* using the existing radix tree and instead
implementing its own simplified radix tree, which *can* be fine but
the bar to clear is fairly high.  You have to be able to show
*clearly* that using the existing radix tree is not an option.  Until
now, the only thing that I gathered is the simplified thing is gonna
be faster in some extreme cases while having clear disadvantage in
terms of memory allocation.  Not very convincing.

Thanks.

-- 
tejun
