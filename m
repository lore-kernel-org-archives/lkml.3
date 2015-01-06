Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779AbbAFQ01 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 11:26:27 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:56595 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554AbbAFQ0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 11:26:25 -0500
Date: Tue, 6 Jan 2015 17:26:24 +0100
From: Andreas Mohr <andi@lisas.de>
To: Christoph Lameter <cl@linux.com>
Cc: Andreas Mohr <andi@lisas.de>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH 6/6] mm/slab: allocation fastpath without disabling irq
Message-ID: <20150106162624.GB24898@rhlx01.hs-esslingen.de>
References: <1420421851-3281-7-git-send-email-iamjoonsoo.kim@lge.com>
 <20150105172139.GA11201@rhlx01.hs-esslingen.de>
 <20150106013122.GB17222@js1304-P5Q-DELUXE>
 <20150106103439.GA8669@rhlx01.hs-esslingen.de>
 <alpine.DEB.2.11.1501060931500.31349@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1501060931500.31349@gentwo.org>
X-Priority: none
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 09:33:15AM -0600, Christoph Lameter wrote:
> On Tue, 6 Jan 2015, Andreas Mohr wrote:
> > by merely queuing them into a simple submission queue
> > which then will be delay-applied by main-context
> > either once main-context enters a certain "quiet" state (e.g. context switch?),
> > or once main-context needs to actively take into account
> 
> This is basically the same approach as you mentioned before and would
> multiply the resources needed. I think we are close to be able to avoid
> allocations from interrupt contexts. Someone would need to perform an
> audit to see what is left to be done. If so then lots of allocator paths
> both in the page allocator and slab allocator can be dramatically
> simplified.

OK, so we seem to be already well near the finishing line of single-context
operation.

In case of multi-context access, in general I'd guess
that challenges are similar to
"traditional" multi-thread-capable heap allocator implementations in userspace,
where I'm sure large amounts of research papers (some dead-tree?)
have been written about how to achieve scalable low-contention
multi-thread access arbitration to the same shared underlying memory resource
(but since in Linux circles some implementations exceed usual
accumulated research knowledge / Best Practice, such papers may or may not be
of much help ;)

Andreas Mohr
