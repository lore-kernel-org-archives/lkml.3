Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934420Ab3IDIZK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 04:25:10 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:56125 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934389Ab3IDIZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 04:25:07 -0400
X-AuditID: 9c93017d-b7cdfae0000026c0-f0-5226ee618657
Date: Wed, 4 Sep 2013 17:25:05 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/16] slab: overload struct slab over struct page to
 reduce memory usage
Message-ID: <20130904082505.GA16355@lge.com>
References: <1377161065-30552-1-git-send-email-iamjoonsoo.kim@lge.com>
 <00000140a6ec66e5-a4d245c0-76b6-4a8b-9cf0-d941ca9e08b0-000000@email.amazonses.com>
 <20130823063539.GD22605@lge.com>
 <5226ab2c.02092b0a.5eed.ffffd7e4SMTPIN_ADDED_BROKEN@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5226ab2c.02092b0a.5eed.ffffd7e4SMTPIN_ADDED_BROKEN@mx.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 04, 2013 at 11:38:04AM +0800, Wanpeng Li wrote:
> Hi Joonsoo,
> On Fri, Aug 23, 2013 at 03:35:39PM +0900, Joonsoo Kim wrote:
> >On Thu, Aug 22, 2013 at 04:47:25PM +0000, Christoph Lameter wrote:
> >> On Thu, 22 Aug 2013, Joonsoo Kim wrote:
> >
> [...]
> >struct slab's free = END
> >kmem_bufctl_t array: ACTIVE ACTIVE ACTIVE ACTIVE ACTIVE
> ><we get object at index 0>
> >
> 
> Is there a real item for END in kmem_bufctl_t array as you mentioned above?
> I think the kmem_bufctl_t array doesn't include that and the last step is 
> not present. 

Yes, there is. BUFCTL_END is what I told for END. A slab is initialized in
cache_init_objs() and a last step in that function is to set last entry of
a free array of a slab to BUFCTL_END. This value remains in the whole life
cycle of a slab.

Thanks.
