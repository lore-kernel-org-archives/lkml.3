Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbbAFPdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 10:33:20 -0500
Received: from resqmta-ch2-07v.sys.comcast.net ([69.252.207.39]:50494 "EHLO
	resqmta-ch2-07v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751955AbbAFPdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 10:33:18 -0500
Date: Tue, 6 Jan 2015 09:33:15 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Andreas Mohr <andi@lisas.de>
cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH 6/6] mm/slab: allocation fastpath without disabling irq
In-Reply-To: <20150106103439.GA8669@rhlx01.hs-esslingen.de>
Message-ID: <alpine.DEB.2.11.1501060931500.31349@gentwo.org>
References: <1420421851-3281-7-git-send-email-iamjoonsoo.kim@lge.com> <20150105172139.GA11201@rhlx01.hs-esslingen.de> <20150106013122.GB17222@js1304-P5Q-DELUXE> <20150106103439.GA8669@rhlx01.hs-esslingen.de>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Jan 2015, Andreas Mohr wrote:
> by merely queuing them into a simple submission queue
> which then will be delay-applied by main-context
> either once main-context enters a certain "quiet" state (e.g. context switch?),
> or once main-context needs to actively take into account

This is basically the same approach as you mentioned before and would
multiply the resources needed. I think we are close to be able to avoid
allocations from interrupt contexts. Someone would need to perform an
audit to see what is left to be done. If so then lots of allocator paths
both in the page allocator and slab allocator can be dramatically
simplified.
