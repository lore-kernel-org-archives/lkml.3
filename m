Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129AbaJ0H5R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 03:57:17 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:40614 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbaJ0H5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 03:57:16 -0400
X-Original-SENDERIP: 10.177.222.213
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Mon, 27 Oct 2014 16:58:30 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-mm@kvack.org, penberg@kernel.org, iamjoonsoo@lge.com
Subject: Re: [RFC 0/4] [RFC] slub: Fastpath optimization (especially for RT)
Message-ID: <20141027075830.GF23379@js1304-P5Q-DELUXE>
References: <20141022155517.560385718@linux.com>
 <20141023080942.GA7598@js1304-P5Q-DELUXE>
 <alpine.DEB.2.11.1410230916090.19494@gentwo.org>
 <20141024045630.GD15243@js1304-P5Q-DELUXE>
 <alpine.DEB.2.11.1410240938460.29214@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1410240938460.29214@gentwo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 09:41:49AM -0500, Christoph Lameter wrote:
> > I found that you said retrieving tid first is sufficient to do
> > things right in old discussion. :)
> 
> Right but the tid can be obtained from a different processor.
> 
> 
> One other aspect of this patchset is that it reduces the cache footprint
> of the alloc and free functions. This typically results in a performance
> increase for the allocator. If we can avoid the page_address() and
> virt_to_head_page() stuff that is required because we drop the ->page
> field in a sufficient number of places then this may be a benefit that
> goes beyond the RT and CONFIG_PREEMPT case.

Yeah... if we can avoid those function calls, it would be good.

But, current struct kmem_cache_cpu occupies just 32 bytes on 64 bits
machine, and, that means just 1 cacheline. Reducing size of struct may have
no remarkable performance benefit in this case.

Thanks.
