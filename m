Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129Ab3ILGvP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 02:51:15 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:61871 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809Ab3ILGvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 02:51:14 -0400
X-AuditID: 9c930197-b7b82ae000001256-3b-5231646040b8
Date: Thu, 12 Sep 2013 15:51:38 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH 01/16] slab: correct pfmemalloc check
Message-ID: <20130912065138.GA8055@lge.com>
References: <1377161065-30552-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1377161065-30552-2-git-send-email-iamjoonsoo.kim@lge.com>
 <000001410d6dd2ea-858fd952-3568-44e9-ac6a-070810b732d0-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000001410d6dd2ea-858fd952-3568-44e9-ac6a-070810b732d0-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 02:30:03PM +0000, Christoph Lameter wrote:
> On Thu, 22 Aug 2013, Joonsoo Kim wrote:
> 
> > And, therefore we should check pfmemalloc in page flag of first page,
> > but current implementation don't do that. virt_to_head_page(obj) just
> > return 'struct page' of that object, not one of first page, since the SLAB
> > don't use __GFP_COMP when CONFIG_MMU. To get 'struct page' of first page,
> > we first get a slab and try to get it via virt_to_head_page(slab->s_mem).
> 
> Maybe using __GFP_COMP would make it consistent across all allocators and
> avoid the issue? We then do only have to set the flags on the first page.

Yes, you are right. It can be solved by using __GFP_COMP.
But I made this patch to clarify the problem in current code and to
be merged seperately.

If I solve the problem with __GFP_COMP which is implemented in [09/16]
of this patchset, it would also weaken the purpose of that patch.

Thanks.
