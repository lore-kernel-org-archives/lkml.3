Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083Ab3DJFZh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 01:25:37 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:42253 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab3DJFZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 01:25:36 -0400
X-AuditID: 9c93016f-b7b3fae0000004d3-2c-5164f7ce2eaf
Date: Wed, 10 Apr 2013 14:26:19 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Minchan Kim <minchan@kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 2/3] mm, slub: count freed pages via rcu as this task's
 reclaimed_slab
Message-ID: <20130410052619.GD5872@lge.com>
References: <1365470478-645-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1365470478-645-2-git-send-email-iamjoonsoo.kim@lge.com>
 <0000013def3255c0-87577820-0ad9-46ac-8498-0589db4e7180-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000013def3255c0-87577820-0ad9-46ac-8498-0589db4e7180-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Christoph.

On Tue, Apr 09, 2013 at 02:28:06PM +0000, Christoph Lameter wrote:
> On Tue, 9 Apr 2013, Joonsoo Kim wrote:
> 
> > Currently, freed pages via rcu is not counted for reclaimed_slab, because
> > it is freed in rcu context, not current task context. But, this free is
> > initiated by this task, so counting this into this task's reclaimed_slab
> > is meaningful to decide whether we continue reclaim, or not.
> > So change code to count these pages for this task's reclaimed_slab.
> 
> slab->reclaim_state guides the reclaim actions in vmscan.c. With this
> patch slab->reclaim_state could get quite a high value without new pages being
> available for allocation. slab->reclaim_state will only be updated
> when the RCU period ends.

Okay.

In addition, there is a little place who use SLAB_DESTROY_BY_RCU.
I will drop this patch[2/3] and [3/3] for next spin.

Thanks.

> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
