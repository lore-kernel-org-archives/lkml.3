Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670AbbAERwi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 12:52:38 -0500
Received: from resqmta-ch2-10v.sys.comcast.net ([69.252.207.42]:48242 "EHLO
	resqmta-ch2-10v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753292AbbAERwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 12:52:37 -0500
Date: Mon, 5 Jan 2015 11:52:35 -0600 (CST)
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
In-Reply-To: <20150105172139.GA11201@rhlx01.hs-esslingen.de>
Message-ID: <alpine.DEB.2.11.1501051151200.25076@gentwo.org>
References: <20150105172139.GA11201@rhlx01.hs-esslingen.de>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Jan 2015, Andreas Mohr wrote:

> These thoughts also mean that I'm unsure (difficult to determine)
> of whether this change is good (i.e. a clean step in the right direction),
> or whether instead the implementation could easily directly be made
> fully independent from IRQ constraints.

We have thought a couple of times about making it independent of
interrupts. We can do that if there is guarantee that no slab operations
are going to be performed from an interrupt context. That in turn will
simplify allocator design significantly.

Regarding this patchset: I think this has the character of an RFC at this
point. There are some good ideas here but this needs to mature a bit and
get lots of feedback.

